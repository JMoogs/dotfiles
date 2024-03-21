{
  enable = true;
  settings =  {
    theme = "dracula";
    editor = {
      line-number = "relative";
      mouse = false;
      bufferline = "multiple";
      cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      file-picker = {
        hidden = false;
      };
      lsp = {
        display-messages = true;
      };
    };
    keys = {
      normal = {
        esc = ["collapse_selection" "keep_primary_selection"];
      };
      # Force using helix bindings
      insert = {
        up = "no_op";
        down = "no_op";
        left = "no_op";
        right = "no_op";
        pageup = "no_op";
        pagedown = "no_op";
        home = "no_op";
        end = "no_op";
      };
    };
  };
}
