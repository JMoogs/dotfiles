# Settings for devices with NVIDIA GPUs
{
  pkgs,
  lib,
  config,
  ...
}: {
  boot.kernelParams = ["nvidia_drm.fbdev=1"];

  hardware.graphics = {
    extraPackages = [pkgs.libvdpau-va-gl pkgs.nvidia-vaapi-driver];
  };

  hardware.nvidia = {
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

  services.xserver.videoDrivers = lib.mkForce ["nvidia"];

  hardware.nvidia-container-toolkit.enable = true;

  nixpkgs.config.nvidia.acceptLicense = true;

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NIXOS_OZONE_WL = "1";
  };
}
