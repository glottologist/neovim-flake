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
          enable = false;
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
        telescope.enable = true;
      };

      keys = {
        whichKey.enable = true;
        cheatsheet.enable = true;
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
            windsurf.enable = true;
          };
          completion = {
            nvimCmp.enable = false;
            blinkCmp.enable = true;
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
            
            rust.enable= true;
            nix.enable=true;
            markdown.enable = true;
          };
      };


      };
  






    };
  };
in {
  inherit neovimConfiguration mainConfig;
}
