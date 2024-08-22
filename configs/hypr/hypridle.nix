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
            then 120
            else 600;
          on-timeout = "hyprlock";
        }
      ]
      ++ lib.optionals (userOptions.device == "laptop") [
        {
          timeout = 180;
          on-timeout = "systemctl suspend";
        }
      ];
  };
}
