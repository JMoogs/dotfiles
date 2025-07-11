{...}: {
  programs.fastfetch = {
    enable = true;
    settings = {
      display = {
        separator = " ";
      };

      modules = [
        "break"
        {
          "type" = "cpu";
          "key" = "╭─ ";
          "format" = "{1}";
          "keyColor" = "green";
        }
        {
          "type" = "gpu";
          "key" = "├─ ";
          "format" = "{2}";
          "keyColor" = "green";
        }
        {
          "type" = "memory";
          "key" = "├─ ";
          "keyColor" = "green";
          "format" = "{2}";
        }
        {
          "type" = "display";
          "key" = "╰─󰍹 ";
          "keyColor" = "green";
          "compactType" = "original";
        }
        "break"
        {
          "type" = "shell";
          "key" = "╭─ ";
          "keyColor" = "yellow";
        }
        {
          "type" = "terminal";
          "key" = "├─ ";
          "keyColor" = "yellow";
        }
        {
          "type" = "wm";
          "key" = "╰─ ";
          "keyColor" = "yellow";
        }
        "break"
        {
          "type" = "title";
          "key" = "╭─ ";
          "format" = "{1}@{2}";
          "keyColor" = "blue";
        }
        {
          "type" = "os";
          "key" = "├─ ";
          "keyColor" = "blue";
        }
        {
          "type" = "kernel";
          "key" = "╰─ ";
          "format" = "{1} {2}";
          "keyColor" = "blue";
        }
        "break"
        "colors"
      ];
    };
  };
}
