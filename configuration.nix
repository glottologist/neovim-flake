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
           neotree = {
             enable = true;
          };
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

  
      keys = {
        whichKey.enable = true;
        cheatsheet.enable = false;
      };




      };
  






    };
  };
in {
  inherit neovimConfiguration mainConfig;
}
