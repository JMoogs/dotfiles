{
  enable = true;
  functions = {
    # Set the prompt to [user]@[hostname] [path] normally, but <nix-shell> [path] when in a nix shell.
    fish_greeting = '''';
    fish_prompt = '';
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
  };
  
}
