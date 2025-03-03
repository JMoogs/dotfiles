{
  enable = true;
  functions = {
    # Set the prompt to [user]@[hostname] [path] normally, but <nix-shell> [path] when in a nix shell.
    fish_greeting = '''';
    fish_prompt = ''      ;
            set -l nix_shell_info (
              if test -n "$IN_NIX_SHELL"
                echo -n "<nix-shell>"
              else if test "$SHLVL" -ge 4
                echo -n "<nix-shell>"
              else
                echo -n "$USER@$hostname"
              end
            )
            # echo -n -s "$nix_shell_info ~>"
            printf '%s %s%s%s > ' $nix_shell_info (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
    '';

    y = ''
      set tmp (mktemp -t "yazi-cwd.XXXXXX")
      yazi $argv --cwd-file="$tmp"
      if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
      	builtin cd -- "$cwd"
      end
      rm -f -- "$tmp"
    '';
  };
}
