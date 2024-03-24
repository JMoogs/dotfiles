# Installing
**This guide is WORK IN PROGRESS and may not be accurate.**

See also:
- [The wiki](https://nixos.wiki/wiki/NixOS_Installation_Guide)
- [The manual](https://nixos.org/manual/nixos/stable/index.html#ch-installation)

These steps assume you are only booting NixOS:
1. Connect to wifi. You're on your own for this step.
2. Create your partitions. You can use `fdisk -l` to view all partitions and your device name.
  - Create a GPT partition table: `parted [DEVICE_NAME] -- mklabel gpt` 
  - Create a root partition for your file system: `parted [DEVICE_NAME] -- mkpart root ext4 512MB -8GB`. This creates a partition taking the entire drive, except 512MB for the boot partition, and 8GB for the swap partition. You can use `parted [DEVICE_NAME] -- mkpart root ext4 512MB` to create a partition with no swap.
  - Optionally create your swap partition: `parted [DEVICE_NAME] -- mkpart swap linux-swap -8GB 100%`. Note that the -8GB in this command should be the same as the previous command.
  - Create the boot partition: `parted [DEVICE_NAME] -- mkpart ESP fat32 1MB 512MB`. If you have a swap partition, run `parted [DEVICE_NAME] -- set 3 esp on`. If you didn't create a swap partition, replace the 3 with a 2.
3. Format your partitions. Again, use `fdisk -l` to view your partitions.
  - Format your root partition: `mkfs.ext4 -L nixos [ROOT_PARTITION_NAME]`
  - Initialize your swap partition if it exists: `mkswap -L swap [SWAP_PARTITION_NAME]`
  - Format your boot partition: `mkfs.fat -F 32 -n boot [BOOT_PARTITION_NAME]`
4. Mount your partitions:
  - Mount your filesystem/root partition to `/mnt`: `mount [ROOT_PARTITION_NAME] /mnt`
  - Mount your boot partition to `/mnt/boot/efi`: `mkdir -p /mnt/boot/efi && mount [BOOT_PARTITION_NAME] /mnt/boot/efi`
5. Install git: `nix-env -f '<nixpkgs>' -iA git`
6. Set up config files:
  - If it does not exist, create `/mnt/etc/nixos`: `mkdir -p /mnt/etc/nixos`
  - Clone the repo: `git clone https://github.com/JMoogs/dotfiles.git /mnt/etc/nixos`
  - **IMPORTANT:** Generate a `hardware-configuration.nix` file: `nixos-generate-config --root /mnt`
  - cd into the config dir: `cd /mnt/etc/nixos`
  - Edit values in `./home.nix`: Change the options in `opts` and the names. Note that you have to change them twice, once for the i3 install and once for the hyprland install. The pc device option is for my home pc and won't work on others.
  - Edit values in `./configs/git.nix`.
7. Install: `nixos-install`
8. Reboot: `reboot`
9. Set a password: `passwd [username from home.nix]`
