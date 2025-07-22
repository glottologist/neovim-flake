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

    ccc = {
      enable = mkOption {
        type = types.bool;
        description = "Enable Create Colour Code plugin";
        default = false;
      };
    };
    cinnamon = {
      enable = mkOption {
        type = types.bool;
        description = "Enable Cinnamon Smooth Scrolling";
        default = false;
      };
    };

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
      listChar = mkOption {
        type = types.str;
        description = "Character for indentation line";
        default = "│";
      };

      fillChar = mkOption {
        description = "Character to fill indents";
        type = with types; nullOr types.str;
        default = "⋅";
      };

      eolChar = mkOption {
        description = "Character at end of line";
        type = with types; nullOr types.str;
        default = "↴";
      };

      showEndOfLine = mkOption {
        description = nvim.nmd.asciiDoc ''
          Displays the end of line character set by <<opt-vim.visuals.indentBlankline.eolChar>> instead of the
          indent guide on line returns.
        '';
        type = types.bool;
        default = cfg.indentBlankline.eolChar != null;
        defaultText = literalExpression "config.vim.visuals.indentBlankline.eolChar != null";
      };

      showCurrContext = mkOption {
        description = "Highlight current context from treesitter";
        type = types.bool;
        default = config.vim.code.treesitter.enable;
        defaultText = literalExpression "config.vim.treesitter.enable";
      };

      useTreesitter = mkOption {
        description = "Use treesitter to calculate indentation when possible.";
        type = types.bool;
        default = config.vim.code.treesitter.enable;
        defaultText = literalExpression "config.vim.treesitter.enable";
      };
    };

    twilight = {
      enable = mkOption {
        type = types.bool;
        description = "Enable twilight plugin";
        default = false;
      };
      context = mkOption {
        type = types.int;
        description = "Number of lines to show around the code currently being edited";
        default = "10";
      };

      useTreesitter = mkOption {
        description = "Use treesitter when available for the file.";
        type = types.bool;
        default = config.vim.code.treesitter.enable;
        defaultText = literalExpression "config.vim.treesitter.enable";
      };
    };
    zenmode = {
      enable = mkOption {
        type = types.bool;
        description = "Enable zenmode plugin";
        default = false;
      };
    };
  };
}
