{
  pkgs,
  themes,
  ...
}: {
  enable = true;
  defaultEditor = true;

  colorschemes = {
    dracula.enable = themes.name == "dracula";

    catppuccin = {
      enable = themes.name == "frappe" || themes.name == "latte";
      settings.flavour = themes.name;
    };
  };

  globals = {
    # Set <space> as the leader key
    # See `:help mapleader`
    mapleader = " ";
    maplocalleader = " ";
    have_nerd_font = true;
  };

  opts = {
    # Sets the current number to the current line number, and others to relative
    number = true;
    relativenumber = true;

    # Ignore case when searching
    ignorecase = true;
    # Override the 'ignorecase' option if the search pattern contains uppercase
    smartcase = true;

    # The left column with numberings
    signcolumn = "yes";

    # Update time in ms
    updatetime = 250;

    # Changes which-key popup display time
    timeoutlen = 300;

    # Determine split directions
    splitright = true;
    splitbelow = true;

    # Display different whitespace
    list = true;
    # NOTE: .__raw here means that this field is raw lua code
    listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

    # Setting inccommand causes live updates to features such as `:s/old/new`
    # Setting this to split shows all changes in mini windows.
    inccommand = "split";

    # Minimum lines at top and bottom
    scrolloff = 10;

    # Unbind mouse
    mouse = null;
    ttymouse = null;
  };

  keymaps = [
    # Stop highlighting (from a search) on clicking escape
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
    }

    # Moving between split windows
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w><C-h>";
      options = {
        desc = "Move focus to the left window";
      };
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w><C-l>";
      options = {
        desc = "Move focus to the right window";
      };
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w><C-j>";
      options = {
        desc = "Move focus to the lower window";
      };
    }

    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w><C-k>";
      options = {
        desc = "Move focus to the upper window";
      };
    }

    # Format buffer
    {
      mode = "";
      key = "<leader>f";
      action.__raw = ''
        function()
          require('conform').format { async = true, lsp_fallback = true }
        end
      '';
      options = {
        desc = "[F]ormat buffer";
      };
    }

    # Open Neo-tree
    {
      key = "\\";
      action = "<cmd>Neotree reveal<cr>";
      options = {
        desc = "NeoTree reveal";
      };
    }
  ];

  # Literally no clue: https://nix-community.github.io/nixvim/NeovimOptions/autoGroups/index.html
  autoGroups = {
    kickstart-highlight-yank = {
      clear = true;
    };

    kickstart-lsp-attach = {
      clear = true;
    };

    lint = {
      clear = true;
    };
  };

  autoCmd = [
    # Highlight when yanking text
    {
      event = ["TextYankPost"];
      desc = "Highlight when yanking (copying) text";
      group = "kickstart-highlight-yank";
      callback.__raw = ''
        function()
          vim.highlight.on_yank()
        end
      '';
    }
  ];

  # Any extra packages required such as formatters
  extraPackages = with pkgs; [
    alejandra
    stylua
  ];

  # Additional lua configs
  extraConfigLuaPre = ''
    -- require('neodev').setup {} -- For LSP (broken?)
  '';

  # Additional lua configs 2
  extraConfigLua = ''
    require('cmp').event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done()) -- For autopairs
  '';

  # Autodetect tabstop and shiftwidth
  plugins.sleuth.enable = true;

  # Allows commenting regions with `gc`
  plugins.comment.enable = true;

  # Highlight comments such as todo
  plugins.todo-comments = {
    enable = true;
    signs = true;
  };

  # Show pending keybinds
  plugins.which-key = {
    enable = true;
    settings.spec = [
      {
        __unkeyed = "<leader>c";
        group = "[C]ode";
      }
      {
        __unkeyed = "<leader>c_";
        hidden = true;
      }
      {
        __unkeyed = "<leader>d";
        group = "[D]ocument";
      }
      {
        __unkeyed = "<leader>d_";
        hidden = true;
      }
      {
        __unkeyed = "<leader>r";
        group = "[R]ename";
      }
      {
        __unkeyed = "<leader>r_";
        hidden = true;
      }
      {
        __unkeyed = "<leader>s";
        group = "[S]earch";
      }
      {
        __unkeyed = "<leader>s_";
        hidden = true;
      }
      {
        __unkeyed = "<leader>w";
        group = "[W]orkspace";
      }
      {
        __unkeyed = "<leader>w_";
        hidden = true;
      }
      {
        __unkeyed = "<leader>t";
        group = "[T]oggle";
      }
      {
        __unkeyed = "<leader>t_";
        hidden = true;
      }
      {
        __unkeyed = "<leader>h";
        group = "Git [H]unk";
      }
      {
        __unkeyed = "<leader>h_";
        hidden = true;
      }
    ];
  };

  plugins.telescope = {
    enable = true;

    # Enable extensions
    extensions = {
      fzf-native.enable = true;
      ui-select.enable = true;
    };

    keymaps = {
      "<leader>sh" = {
        mode = "n";
        action = "help_tags";
        options = {
          desc = "[S]earch [H]elp";
        };
      };
      "<leader>sk" = {
        mode = "n";
        action = "keymaps";
        options = {
          desc = "[S]earch [K]eymaps";
        };
      };
      "<leader>sf" = {
        mode = "n";
        action = "find_files";
        options = {
          desc = "[S]earch [F]iles";
        };
      };
      "<leader>ss" = {
        mode = "n";
        action = "builtin";
        options = {
          desc = "[S]earch [S]elect Telescope";
        };
      };
      "<leader>sw" = {
        mode = "n";
        action = "grep_string";
        options = {
          desc = "[S]earch current [W]ord";
        };
      };
      "<leader>sg" = {
        mode = "n";
        action = "live_grep";
        options = {
          desc = "[S]earch by [G]rep";
        };
      };
      "<leader>sd" = {
        mode = "n";
        action = "diagnostics";
        options = {
          desc = "[S]earch [D]iagnostics";
        };
      };
      "<leader>sr" = {
        mode = "n";
        action = "resume";
        options = {
          desc = "[S]earch [R]esume";
        };
      };
      "<leader>s" = {
        mode = "n";
        action = "oldfiles";
        options = {
          desc = "[S]earch Recent Files ('.' for repeat)";
        };
      };
      "<leader><leader>" = {
        mode = "n";
        action = "buffers";
        options = {
          desc = "[ ] Find existing buffers";
        };
      };
    };

    # Once again clueless
    settings = {
      extensions.__raw = "{ ['ui-select'] = { require('telescope.themes').get_dropdown() } }";
    };
  };

  # Highlighting
  plugins.treesitter = {
    enable = true;
    settings.indent.enable = true;
  };

  # Completions: https://github.com/JMartJonesy/kickstart.nixvim/blob/main/plugins/nvim-cmp.nix
  # idk
  plugins.luasnip.enable = true;
  # idk
  plugins.cmp-nvim-lsp.enable = true;
  # idk
  plugins.cmp-path.enable = true;

  # idk (bug related)
  extraLuaPackages = ps: [ps.jsregexp];

  plugins.cmp = {
    enable = true;

    settings = {
      snippet = {
        expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';
      };

      completion = {
        completeopt = "menu,menuone,noinsert";
        keyword_length = 2;
      };

      # For an understanding of why these mappings were
      # chosen, you will need to read `:help ins-completion`
      #
      # No, but seriously, Please read `:help ins-completion`, it is really good!
      mapping = {
        # Select the [n]ext item
        "<C-n>" = "cmp.mapping.select_next_item()";
        # Select the [p]revious item
        "<C-p>" = "cmp.mapping.select_prev_item()";
        # Scroll the documentation window [b]ack / [f]orward
        "<C-b>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        # Accept ([y]es) the completion.
        #  This will auto-import if your LSP supports it.
        #  This will expand snippets if the LSP sent a snippet.
        "<C-y>" = "cmp.mapping.confirm { select = true }";
        # If you prefer more traditional completion keymaps,
        # you can uncomment the following lines.
        "<CR>" = "cmp.mapping.confirm { select = true }";
        "<Tab>" = "cmp.mapping.select_next_item()";
        "<S-Tab>" = "cmp.mapping.select_prev_item()";

        # Manually trigger a completion from nvim-cmp.
        #  Generally you don't need this, because nvim-cmp will display
        #  completions whenever it has completion options available.
        "<C-Space>" = "cmp.mapping.complete {}";

        # Think of <c-l> as moving to the right of your snippet expansion.
        #  So if you have a snippet that's like:
        #  function $name($args)
        #    $body
        #  end
        #
        # <c-l> will move you to the right of the expansion locations.
        # <c-h> is similar, except moving you backwards.
        "<C-l>" = ''
          cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' })
        '';
        "<C-h>" = ''
          cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' })
        '';

        # For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        #    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      };

      # WARNING: If plugins.cmp.autoEnableSources Nixivm will automatically enable the
      # corresponding source plugins. This will work only when this option is set to a list.
      # If you use a raw lua string, you will need to explicitly enable the relevant source
      # plugins in your nixvim configuration.
      sources = [
        {
          name = "luasnip";
        }
        # Adds other completion capabilites.
        #  nvim-cmp does not ship with all sources by default. They are split
        #  into multiple repos for maintenance purposes.
        {
          name = "nvim_lsp";
        }
        {
          name = "path";
        }
      ];
    };
  };

  # Can possibly add these: https://github.com/JMartJonesy/kickstart.nixvim/blob/main/plugins/mini.nix

  # Show git changes
  plugins.gitsigns = {
    enable = true;
    settings = {
      signs = {
        add = {text = "+";};
        change = {text = "~";};
        delete = {text = "_";};
        topdelete = {text = "‾";};
        changedelete = {text = "~";};
      };
    };
  };

  # Autoformatting
  plugins.conform-nvim = {
    enable = true;
    notifyOnError = false;
    formatOnSave = ''
      function(bufnr)
        -- Disable "format_on_save lsp_fallback" for lanuages that don't
        -- have a well standardized coding style. You can add additional
        -- lanuages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype]
        }
      end
    '';
    formattersByFt = {
      lua = ["stylua"];
      nix = ["alejandra"];
      # Conform can also run multiple formatters sequentially
      # python = [ "isort "black" ];
      #
      # You can use a sublist to tell conform to run *until* a formatter
      # is found
      # javascript = [ [ "prettierd" "prettier" ] ];
    };
  };

  # LSP status updates
  plugins.fidget.enable = true;

  plugins.lsp = {
    enable = true;

    # Different language servers
    servers = {
      # C/C++
      clangd = {
        enable = true;
      };
      # Json
      jsonls.enable = true;
      # Typst
      typst-lsp.enable = true;
      # Nix
      nil-ls.enable = true;
      # Python
      pyright.enable = true;
      # Rust
      rust-analyzer.enable = true;
      rust-analyzer.installCargo = false;
      rust-analyzer.installRustc = false;

      tsserver.enable = true;
    };

    keymaps = {
      # Diagnostic keymaps
      diagnostic = {
        "[d" = {
          #mode = "n";
          action = "goto_prev";
          desc = "Go to previous [D]iagnostic message";
        };
        "]d" = {
          #mode = "n";
          action = "goto_next";
          desc = "Go to next [D]iagnostic message";
        };
        "<leader>e" = {
          #mode = "n";
          action = "open_float";
          desc = "Show diagnostic [E]rror messages";
        };
        "<leader>q" = {
          #mode = "n";
          action = "setloclist";
          desc = "Open diagnostic [Q]uickfix list";
        };
      };

      extra = [
        # Jump to the definition of the word under your cusor.
        #  This is where a variable was first declared, or where a function is defined, etc.
        #  To jump back, press <C-t>.
        {
          mode = "n";
          key = "gd";
          action.__raw = "require('telescope.builtin').lsp_definitions";
          options = {
            desc = "LSP: [G]oto [D]efinition";
          };
        }
        # Find references for the word under your cursor.
        {
          mode = "n";
          key = "gr";
          action.__raw = "require('telescope.builtin').lsp_references";
          options = {
            desc = "LSP: [G]oto [R]eferences";
          };
        }
        # Jump to the implementation of the word under your cursor.
        #  Useful when your language has ways of declaring types without an actual implementation.
        {
          mode = "n";
          key = "gI";
          action.__raw = "require('telescope.builtin').lsp_implementations";
          options = {
            desc = "LSP: [G]oto [I]mplementation";
          };
        }
        # Jump to the type of the word under your cursor.
        #  Useful when you're not sure what type a variable is and you want to see
        #  the definition of its *type*, not where it was *defined*.
        {
          mode = "n";
          key = "<leader>D";
          action.__raw = "require('telescope.builtin').lsp_type_definitions";
          options = {
            desc = "LSP: Type [D]efinition";
          };
        }
        # Fuzzy find all the symbols in your current document.
        #  Symbols are things like variables, functions, types, etc.
        {
          mode = "n";
          key = "<leader>ds";
          action.__raw = "require('telescope.builtin').lsp_document_symbols";
          options = {
            desc = "LSP: [D]ocument [S]ymbols";
          };
        }
        # Fuzzy find all the symbols in your current workspace.
        #  Similar to document symbols, except searches over your entire project.
        {
          mode = "n";
          key = "<leader>ws";
          action.__raw = "require('telescope.builtin').lsp_dynamic_workspace_symbols";
          options = {
            desc = "LSP: [W]orkspace [S]ymbols";
          };
        }
      ];

      lspBuf = {
        # Rename the variable under your cursor.
        #  Most Language Servers support renaming across files, etc.
        "<leader>rn" = {
          action = "rename";
          desc = "LSP: [R]e[n]ame";
        };
        # Execute a code action, usually your cursor needs to be on top of an error
        # or a suggestion from your LSP for this to activate.
        "<leader>ca" = {
          #mode = "n";
          action = "code_action";
          desc = "LSP: [C]ode [A]ction";
        };
        # Opens a popup that displays documentation about the word under your cursor
        #  See `:help K` for why this keymap.
        "K" = {
          action = "hover";
          desc = "LSP: Hover Documentation";
        };
        # WARN: This is not Goto Definition, this is Goto Declaration.
        #  For example, in C this would take you to the header.
        "gD" = {
          action = "declaration";
          desc = "LSP: [G]oto [D]eclaration";
        };
      };
    };

    # This code runs on opening a new file that the LSP recognizes
    onAttach = ''

      -- NOTE: Remember that Lua is a real programming language, and as such it is possible
      -- to define small helper and utility functions so you don't have to repeat yourself.
      --
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local map = function(keys, func, desc)
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
      end

      -- The following two autocommands are used to highlight references of the
      -- word under the cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      if client and client.server_capabilities.documentHighlightProvider then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = bufnr,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = bufnr,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- The following autocommand is used to enable inlay hints in your
      -- code, if the language server you are using supports them
      --
      -- This may be unwanted, since they displace some of your code
      if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, '[T]oggle Inlay [H]ints')
      end
    '';
  };

  # Browse file system
  plugins.neo-tree = {
    enable = true;

    filesystem = {
      window = {
        mappings = {
          "\\" = "close_window";
        };
      };
    };
  };

  # Linting
  plugins.lint = {
    enable = true;

    # NOTE: Enabling these will cause errors unless these tools are installed
    lintersByFt = {
      nix = ["nix"];
      # markdown = [
      #   "markdownlint"
      #   #vale
      # ];
      #clojure = ["clj-kondo"];
      #dockerfile = ["hadolint"];
      #inko = ["inko"];
      #janet = ["janet"];
      #json = ["jsonlint"];
      #rst = ["vale"];
      #ruby = ["ruby"];
      #terraform = ["tflint"];
      #text = ["vale"];
    };

    # Create autocommand which carries out the actual linting
    # on the specified events.
    autoCmd = {
      callback.__raw = ''
        function()
          require('lint').try_lint()
        end
      '';
      group = "lint";
      event = [
        "BufEnter"
        "BufWritePost"
        "InsertLeave"
      ];
    };
  };

  # TODO: Add debugger if required

  # Auto pairing
  plugins.nvim-autopairs.enable = true;
}
