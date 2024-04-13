# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ pkgs, config, lib, userOptions, unstable, ... }:

{
  imports =
    [ 
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  # Use Grub as the windows EFI partition is only 100mb
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      # To prevent storing extra files on EFI partition
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      # Dual boot
      useOSProber = true;
      efiSupport = true;
      device = "nodev";
      # Store 5 generations
      configurationLimit = 5;
    };
  };

  networking.hostName = userOptions.hostname; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    supportedLocales = [
      "C.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
    ];
    # inputMethod = {
    #   enabled = "fcitx5";
    #   fcitx5.addons = with pkgs; [
    #     fcitx5-mozc
    #   ];
    # };
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

  console.keyMap = "uk";

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = if userOptions.nvidia then with pkgs; [ libvdpau-va-gl nvidia-vaapi-driver ] else [];
  };

  # Xbox one controller driver
  hardware.xone.enable = true;

  hardware.nvidia = lib.attrsets.optionalAttrs userOptions.nvidia {
    # Modesetting is required.
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

    package = if userOptions.wm == "hyprland" then config.boot.kernelPackages.nvidiaPackages.production else config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Wayland 
  programs.hyprland = lib.attrsets.optionalAttrs (userOptions.wm == "hyprland") {
    enable = true;
    xwayland.enable = true;
    # Use unstable hyprland
    portalPackage = unstable.xdg-desktop-portal-hyprland;
    package = unstable.hyprland;
  };

  # Corectrl
  programs.corectrl.enable = true;
  
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = if userOptions.nvidia then ["nvidia"] else ["modesetting" "fbdev"];
    layout = "gb";

    # Hyprland login manager
    displayManager.sddm.enable = userOptions.wm == "hyprland";
    displayManager.sddm.wayland.enable = userOptions.wm == "hyprland";

    windowManager.i3 = lib.attrsets.optionalAttrs (userOptions.wm == "i3") {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3lock
      ];
    };

    displayManager.defaultSession = if userOptions.wm == "i3" then "none+i3" else null;

    # Enable wacom driver
    wacom.enable = true;
    
  };



  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # Use pipewire since it's needed for screensharing, etc. on Hyprland
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = true;
  };
  # Screensharing
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk]; 
  };

  # OpenRazer
  hardware.openrazer = {
    enable = true;
    users = ["${userOptions.username}"];
  };
  

  # Enable touchpad support (enabled default in most desktopManager).

  # Nix & Nixpkgs config
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = []; # Currently none required
  };

  # Environment variables
  environment.variables = {
    EDITOR = "hx";
    SHELL = "fish";
  };

  # Change shell to fish
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
  # Alias lazygit
  programs.fish.shellAliases = {
    lg = "lazygit";
    dev = "nix-shell --command fish";
    hbuild = "sudo nixos-rebuild switch --flake /etc/nixos#Jeremy-pc-hypr";
    ibuild = "sudo nixos-rebuild switch --flake /etc/nixos#Jeremy-nixos";
    cdconfig = "cd /etc/nixos";
    edithome = "sudoedit /etc/nixos/home.nix";
    editconfig = "sudoedit /etc/nixos/configuration.nix";
    editflake = "sudoedit /etc/nixos/flake.nix";
    # I do this so often that I may as well
    carog = "cargo";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."${userOptions.username}" = {
     isNormalUser = true;
     extraGroups = [ "wheel" "corectrl" ]; # Enable ‘sudo’ for the user.
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  # Waydroid for android apps
  virtualisation.waydroid.enable = true;

  # Ratbagd for mouse config?
  services.ratbagd.enable = true;

  # Mullvad
  services.mullvad-vpn.enable = true;

  # Allow swaylock to unlock PC
  security.pam.services.swaylock = {};

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

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

