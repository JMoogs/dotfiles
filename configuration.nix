# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{
  pkgs,
  config,
  lib,
  userOptions,
  ...
}: {
  imports = [
    # Include the hardware configuration so that drives can be mounted, etc.
    (
      if userOptions.device == "pc"
      then ./hardware-configs/PC.nix
      else if userOptions.device == "laptop"
      then ./hardware-configs/laptop.nix
      else null
    )
  ];

  # Setup the bootloader
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      # By mounting on `/boot/efi`, extra files (previous generations) can be stored on the root partition rather than the EFI partition
      efiSysMountPoint = "/boot/efi";
    };
    # Use grub as the bootloader
    grub = {
      enable = true;
      # Use OS Prober to detect a windows install
      useOSProber = true;
      efiSupport = true;
      device = "nodev";
      # Store 15 previous generations of configs
      configurationLimit = 15;
    };
  };
  # Use the latest kernel
  boot.kernelPackages =
    if userOptions.device == "pc"
    then pkgs.linuxPackages_6_6
    else pkgs.linuxPackages_latest;
  boot.kernelParams =
    if userOptions.nvidia
    then ["nvidia_drm.fbdev=1"]
    else [];
  boot.kernelModules =
    if userOptions.device == "pc"
    then ["r8125"]
    else [];
  boot.extraModulePackages =
    if userOptions.device == "pc"
    then [pkgs.linuxPackages_6_6.r8125]
    else [];

  # Set hostname
  networking.hostName = userOptions.hostname;
  # Use networkmanager for managing networks. It is easiest to use and the default of most distros.
  networking.networkmanager.enable = true;

  # Set the time zone
  # time.timeZone =
  #   if userOptions.device == "laptop"
  #   then "Asia/Tokyo"
  #   else "Europe/London";
  services.automatic-timezoned.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set internationalisation properties.
  i18n = {
    # Default locale. Determines the language for most things
    defaultLocale = "en_GB.UTF-8";
    # Extra locales that the system should support
    supportedLocales = [
      # The default POSIX locale
      "C.UTF-8/UTF-8"
      # English (British)
      "en_GB.UTF-8/UTF-8"
      # Japanese
      "ja_JP.UTF-8/UTF-8"
    ];
    # Add a way to input different languages
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        # Japanese input addon
        fcitx5-mozc
      ];
    };

    # Other environment variables to set, related to i18n
    extraLocaleSettings = {
      # LANG = "en_GB.UTF-8";
      # LC_MESSAGES = "en_GB.UTF-8";
      # LC_IDENTIFICATION = "en_GB.UTF-8";
      # LC_ALL = "en_GB.UTF-8";
      # LC_CTYPE = "en_GB.UTF-8";
      # LC_NUMERIC = "en_GB.UTF-8";
      # LC_TIME = "en_GB.UTF-8";
      # LC_COLLATE = "en_GB.UTF-8";
      # LC_NAME = "en_GB.UTF-8";
      # LC_MONETARY = "en_GB.UTF-8";
      # LC_PAPER = "en_GB.UTF-8";
      # LC_ADDRESS = "en_GB.UTF-8";
      # LC_TELEPHONE = "en_GB.UTF-8";
      # LC_MEASUREMENT = "en_GB.UTF-8";
    };
  };

  # The keyboard mapping for virtual consoles
  console.keyMap = "uk";

  # Add nerdfonts for different types of symbols
  fonts.packages = [pkgs.nerd-fonts.symbols-only pkgs.ipafont pkgs.kochi-substitute pkgs.noto-fonts-cjk-sans pkgs.roboto pkgs.source-sans-pro pkgs.source-sans];

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages =
      if userOptions.nvidia
      then [pkgs.libvdpau-va-gl pkgs.nvidia-vaapi-driver]
      else [];
  };

  # Enable the Xbox One controller driver
  hardware.xone.enable = true;

  # Nvidia setup
  hardware.nvidia = lib.attrsets.optionalAttrs userOptions.nvidia {
    # Modesetting is required
    modesetting.enable = true;

    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Set the kernel package
    package = config.boot.kernelPackages.nvidiaPackages.beta; # Use beta as we need Nvidia 555 for Explicit Sync as of right now
    # Options include:
    # config.boot.kernelPackages.nvidiaPackages.stable
    # config.boot.kernelPackages.nvidiaPackages.production
    # config.boot.kernelPackages.nvidiaPackages.beta
  };

  # Enable hyprland (note: I don't know if this actually has any effect since it's defined in home.nix)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    package = pkgs.hyprland;
  };

  # Tuxclocker
  programs.tuxclocker = {
    enable = true;
    enabledNVIDIADevices = [0];
    useUnfree = true;
  };

  # Sunshine for streaming: https://github.com/LizardByte/Sunshine
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  # Enable x11 (note: I don't know if this is needed anymore, maybe for XWayland it is?)
  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;

    # Set drivers
    videoDrivers =
      if userOptions.nvidia
      then ["nvidia"]
      else ["modesetting" "fbdev"];

    # Set the layout for xkeyboard
    xkb.layout = "gb";

    # Enable the wacom tablet driver
    wacom.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [pkgs.hplip];
  };

  # Enable sound.
  # Use pipewire since it's needed for screensharing, etc. on Hyprland
  # Enable basically everything
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = true;
  };

  # For screensharing
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };

  # OpenRazer to configure a razer mouse
  hardware.openrazer = {
    enable = true;
    # Adds the user to the razer group required for usage
    users = ["${userOptions.username}"];
  };

  # Nix & Nixpkgs config
  nix.settings = {
    # Enable nix flakes
    experimental-features = ["nix-command" "flakes"];

    # Enable the Hyprland cachix to prevent having to compile Hyprland from source (when running master)
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  nixpkgs.config = {
    # Allow unfree packages
    allowUnfree = true;
    allowBroken = true;
    # Add insecure packages that are required here
    permittedInsecurePackages = []; # Currently none required
    # Accept the nvidia driver license when running nvidia
    nvidia.acceptLicense = userOptions.nvidia;
  };

  nixpkgs.overlays = [
    # # Openrazer fix: https://github.com/NixOS/nixpkgs/issues/310205
    # (self: super: {
    #   openrazer-daemon = super.openrazer-daemon.overrideAttrs (oldAttrs: {
    #     nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [pkgs.gobject-introspection pkgs.wrapGAppsHook3 pkgs.python3Packages.wrapPython];
    #   });
    # })
  ];

  # Environment variables
  environment.variables = {
    # The `EDITOR` variable if often used when entering edit mode on a program
    EDITOR = "nvim";
    # Set the shell
    SHELL = "fish";
  };

  # For compatibility - these are bound on most Linux distros, but not on Nix by default
  environment.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  environment.systemPackages = [
    pkgs.libsForQt5.qt5.qtgraphicaleffects
  ];

  # Change shell to fish
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Alias lazygit
  programs.fish.shellAliases = {
    lg = "lazygit";
    # Quick entry into a dev shell
    dev = "nix-shell --command fish";
    neofetch = "fastfetch";
    rebuild =
      if userOptions.device == "pc"
      then "sudo nixos-rebuild switch --flake /etc/nixos#Jeremy-nixos"
      else if userOptions.device == "laptop"
      then "sudo nixos-rebuild switch --flake /etc/nixos#Jeremy-laptop"
      else null;

    # Aliases to quickly edit my config
    cdconfig = "cd /etc/nixos";
    edithome = "sudoedit /etc/nixos/home.nix";
    editconfig = "sudoedit /etc/nixos/configuration.nix";
    editflake = "sudoedit /etc/nixos/flake.nix";

    # For rust programming - I commonly mistype this
    # TODO: Maybe bind this in nix-shell?
    carog = "cargo";
  };

  # Define a user account. A password must be set imperatively using `passwd`
  users.users."${userOptions.username}" = {
    isNormalUser = true;
    extraGroups = ["wheel"]; # Enable ‘sudo’ for the user
  };

  # Enable steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Required for EasyEffects (https://github.com/wwmm/easyeffects)
  programs.dconf.enable = true;

  # Waydroid for android apps
  virtualisation.waydroid.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # Mullvad (VPN)
  services.mullvad-vpn.enable = true;

  # Allows Hyprlock to unlock a device
  security.pam.services.hyprlock = {};

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [696];
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = ["edict_test_db"];
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    7777 # Terraria's Port
    22000 # Syncthing's TCP listening port
    6970
    6971
  ];
  networking.firewall.allowedUDPPorts = [
    7777 # Terraria's Port
    6970
    6971
  ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
