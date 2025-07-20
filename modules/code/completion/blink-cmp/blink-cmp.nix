{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins;  {
  options.vim.code.completion = {
    blinkCmp = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "enable autocomplete";
      };
      sources = mkOption {
        description = nvim.nmd.asciiDoc ''
          Attribute set of source names for completion.
          If an attribute set is provided, then the menu value of
          `vim_item` in the format will be set to the value (if
          utilizing the completion menu mapping function).
          Note: only use a single attribute name per attribute set
          
          For blink.cmp, sources are specified as strings and configured
          in the providers section.
        '';
        type = with types; attrsOf (nullOr str);
        default = {};
        example = ''
          {lsp = "[LSP]"; buffer = "[Buffer]"; path = "[Path]";}
        '';
      };
      compat_sources = mkOption {
        type = with types; listOf str;
        default = [];
        description = nvim.nmd.asciiDoc ''
          List of nvim-cmp source names to use via blink.compat.
          Only applicable when using blink-cmp.
        '';
        example = ''["cmp-git" "cmp-npm"]'';
      };
      formatting = {
        format = mkOption {
          description = nvim.nmd.asciiDoc ''
            The function used to customize the appearance of the completion menu.
            If <<opt-vim.lsp.lspkind.enable>> is true, then the function
            will be called before modifications from lspkind.
            Default is to call the menu mapping function.
            
            For blink.cmp, this integrates with the appearance.kind_icons option.
          '';
          type = types.str;
          default = "blink_cmp_menu_map";
          example = nvim.nmd.literalAsciiDoc ''
            [source,lua]
            ---
            function(entry, vim_item)
              return vim_item
            end
            ---
          '';
        };
      };
      appearance = {
        nerd_font_variant = mkOption {
          type = types.enum ["mono" "normal"];
          default = "mono";
          description = nvim.nmd.asciiDoc ''
            Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'.
            Adjusts spacing to ensure icons are aligned.
            Only applicable when using blink-cmp.
          '';
        };
        use_nvim_cmp_as_default = mkOption {
          type = types.bool;
          default = false;
          description = nvim.nmd.asciiDoc ''
            Sets the fallback highlight groups to nvim-cmp's highlight groups.
            Useful when your theme doesn't support blink.cmp.
            Only applicable when using blink-cmp.
          '';
        };
      };
      completion = {
        auto_brackets = mkOption {
          type = types.bool;
          default = true;
          description = nvim.nmd.asciiDoc ''
            Enable experimental auto-brackets support.
            Only applicable when using blink-cmp.
          '';
        };
        documentation = {
          auto_show = mkOption {
            type = types.bool;
            default = true;
            description = nvim.nmd.asciiDoc ''
              Automatically show documentation popup.
              Only applicable when using blink-cmp.
            '';
          };
          auto_show_delay_ms = mkOption {
            type = types.int;
            default = 200;
            description = nvim.nmd.asciiDoc ''
              Delay in milliseconds before showing documentation.
              Only applicable when using blink-cmp.
            '';
          };
        };
        ghost_text = {
          enabled = mkOption {
            type = types.bool;
            default = false;
            description = nvim.nmd.asciiDoc ''
              Enable ghost text completion preview.
              Only applicable when using blink-cmp.
            '';
          };
        };
      };
      keymap = {
        preset = mkOption {
          type = types.enum ["default" "super-tab" "enter"];
          default = "enter";
          description = nvim.nmd.asciiDoc ''
            Keymap preset to use. Options:
            - default: Standard keymaps
            - super-tab: Tab for everything
            - enter: Enter to accept, tab to select
            Only applicable when using blink-cmp.
          '';
        };
      };
      cmdline = {
        enabled = mkOption {
          type = types.bool;
          default = false;
          description = nvim.nmd.asciiDoc ''
            Enable completion in command line mode.
            Only applicable when using blink-cmp.
          '';
        };
      };
      snippets = {
        expand = mkOption {
          type = types.str;
          default = "vim.snippet.expand(snippet)";
          description = nvim.nmd.asciiDoc ''
            Function to expand snippets. 
            Only applicable when using blink-cmp.
          '';
          example = nvim.nmd.literalAsciiDoc ''
            [source,lua]
            ---
            function(snippet, _)
              vim.snippet.expand(snippet)
            end
            ---
          '';
        };
      };
    };
  };
}
