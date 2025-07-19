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
          # These are mutually explusive.  Only enable one or the other
           neotree.enable = true;
           nvimtree.enable = false;
        };  
    
      statusline = {
        lualine = {
          enable = true;
          theme = "ayu_light";
        };
      };

      theme = {
        enable = true;
        name = "tokyonight";
        style = "day";
        transparent = false;
      };  

      tabline = {
        nvimBufferline.enable = true;
      };

      find = {
        telescope.enable = false;
      };

      keys = {
        whichKey.enable = true;
        cheatsheet.enable = false;
      };

    ui = {
      modes.enable=false;
      noice.enable=false;
      notifcations = {
         nvim-notify.enable=false;
      };
    };

      code = {
          ai = {
            windsurf.enable = false;
          };
          completion = {
            nvimCmp.enable = false;
            blinkCmp.enable = false;
          };
          lsp = {
            enable = true;
            formatOnSave = false;
            lspconfig.enable = true;
            lightbulb.enable = false;
            lspkind.enable = false;
            lspsaga.enable = false;
            lspsignature.enable = false;
            trouble.enable = false;
          };
          treesitter = {
            enable = true;
            fold = false;
          };

          languages = {
        enableLSP = true;
        enableFormat = false;
        enableTreesitter = false;
        enableExtraDiagnostics = false;
            
            rust.enable= true;
            nix.enable=false;
            markdown.enable = false;
          };
      };


      };
  






    };
  };
in {
  inherit neovimConfiguration mainConfig;
}
