{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
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

  # Required setup for the Realtek 8125 network driver for internet on PC
  boot.kernelPackages = pkgs.linuxPackages_6_6;
  boot.kernelModules = ["r8125"];
  boot.extraModulePackages = [pkgs.linuxPackages_6_6.r8125];

  networking.hostName = "Jeremy-nixos";

  programs.fish.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#Jeremy-nixos";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
