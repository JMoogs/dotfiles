{
  lib,
  userOptions,
  ...
}: {
  enable = true;

  settings = {
    lockCmd = "pidof hyprlock | hyprlock";

    listener =
      [
        {
          timeout =
            if userOptions.device == "laptop"
            then 240
            else 600;
          on-timeout = "hyprlock";
        }
      ]
      ++ lib.optionals (userOptions.device == "laptop") [
        {
          timeout = 360;
          on-timeout = "systemctl suspend";
        }
      ];
  };
}
