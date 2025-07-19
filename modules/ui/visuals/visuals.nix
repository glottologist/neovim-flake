{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.ui.visuals;
in {
  options.vim.ui.visuals = {
    enable = mkEnableOption "Visual enhancements.";

    fidget = {
      enable = mkOption {
        type = types.bool;
        description = "Enable nvim LSP UI element [fidget-nvim]";
        default = false;
      };
      align = {
        bottom = mkOption {
          type = types.bool;
          description = "Align to bottom";
          default = true;
        };

        right = mkOption {
          type = types.bool;
          description = "Align to right";
          default = true;
        };
      };
    };

    indentBlankline = {
      enable = mkOption {
        type = types.bool;
        description = "Enable indentation guides [indent-blankline]";
        default = false;
      };
    };
  };
}
