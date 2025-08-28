inputs: let
  modulesWithInputs = import ./modules inputs;

  neovimConfiguration = {
    modules ? [],
    pkgs,
    lib ? pkgs.lib,
    check ? false, # Disable the plugin checks to avoid errors
    extraSpecialArgs ? {},
  }:
    modulesWithInputs {
      inherit pkgs lib check extraSpecialArgs;
      configuration.imports = modules;
    };

  mainConfig = isDeveloper: {
    config = {
      vim = {
        # BASIC/CORE
        viAlias = true;
        vimAlias = true;
        useSystemClipboard = true;
        debugMode = {
          enable = false;
          level = 20;
          logFile = "/tmp/nvim.log";
        };

        # EXPLORER
        explorer = {
          # NvimTree and NeoTree are mutually exclusive.  Only enable one or the other
          neotree.enable = true;
          nvimtree.enable = false;

          # Buffer based file exploration
          oil.enable = true;
        };

        # STATUS
        status = {
          statusline = {
            lualine = {
              enable = true;
              theme = "ayu_light";
            };
          };
          tabline = {
            nvimBufferline.enable = true;
          };
        };

        # THEME
        theme = {
          enable = true;
          name = "tokyonight";
          style = "day";
          transparent = false;
          dependencies = ["lush"];
        };

        # FIND
        find = {
          telescope = {
            enable = true;
            media-files.enable = true;
            manix.enable = true;
            spectre.enable = true;
          };
        };

        # KEYS
        keys = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };

        # UI
        ui = {
          modes.enable = true;
          noice.enable = true;
          notifcations = {
            nvim-notify.enable = true;
          };
          motion = {
            ###  flash and eyeliner are mutualy exclusive - only enable 1 of them
            flash.enable = false;
            eyeliner.enable = true;

            mini.enable = true;
            spider.enable = true;
            harpoon.enable = true;
            tide.enable = true;
          };
          visuals = {
            enable = true;
            ccc.enable = true;
            cinnamon.enable = true;
            fidget.enable = true;
            indentBlankline = {
              enable = true;
              fillChar = null;
              eolChar = null;
              showCurrContext = true;
              useTreesitter = true;
            };
            twilight = {
              enable = true;
              context = 12;
              useTreesitter = true;
            };
            zenmode.enable = true;
          };
        };

        # CODE
        code = {
          actions = {
            actionsPreview.enable = true;
          };
          ai = {
            windsurf.enable = true;
          };
          completion = {
            nvimCmp.enable = false;
            blinkCmp.enable = true;
          };
          debug = {
            dap.enable = true;
          };
          diff = {
            diffview.enable = true;
          };
          folds = {
            ufo.enable = false;
          };
          format = {
            confrom.enable = true;
          };
          lint = {
            nvim-lint.enable = true;
          };
          lsp = {
            enable = true;
            formatOnSave = true;
            lspconfig.enable = true;
            lightbulb.enable = true;
            lspkind.enable = true;
            lspsaga.enable = true;
            lspsignature.enable = true;
            trouble.enable = true;
          };
          treesitter = {
            enable = true;
            fold = true;
          };

          languages = {
            enableLSP = true;
            enableFormat = true;
            enableTreesitter = true;
            enableExtraDiagnostics = false;

            rust.enable = true;
            nix.enable = true;
            markdown.enable = true;
          };
          git = {
            enable = true;
            gitworktrees.enable = true;
            gitsigns.enable = true;
            gitsigns.codeActions = false;
            neogit.enable = true;
          };
        };
      };
    };
  };
in {
  inherit neovimConfiguration mainConfig;
}
