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
          # These are mutually exclusive.  Only enable one or the other
          neotree.enable = true;
          nvimtree.enable = false;
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
        };

        # FIND
        find = {
          telescope = {
            enable = true;
            media-files.enable = true;
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
          ai = {
            windsurf.enable = true;
          };
          completion = {
            nvimCmp.enable = true;
            blinkCmp.enable = false;
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
            fold = false;
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
          };
        };
      };
    };
  };
in {
  inherit neovimConfiguration mainConfig;
}
