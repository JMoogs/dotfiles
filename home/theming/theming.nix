# Declares the themingModule NixOS option (a single theme enum).
# Per-app theme values (gtkTheme, kittyTheme, etc.) are resolved at call sites
# via home/theming/getTheme.nix rather than as NixOS options, which avoids
# circular dependencies between this module and the modules that consume it.
{lib, ...}: {
  options = {
    themingModule = {
      theme = lib.mkOption {
        type = lib.types.enum ["frappe" "latte" "dracula"];
        default = "frappe";
        description = "The theme to use.";
      };
    };
  };
}
