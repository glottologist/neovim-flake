{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.ui.noice;
in {
  config = mkIf cfg.enable {
    vim.startPlugins = [
      "noice-nvim"
      "nui-nvim"
    ];

    vim.luaConfigRC.noice-nvim = nvim.dag.entryAnywhere ''
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          signature = {
            enabled = false, -- FIXME: enabling this file throws an error which I couldn't figure out
          },
        },
        messages = {
          enabled = true, -- enables the Noice messages UI
          view = "cmdline_popup", -- default view for messages
          view_error = "cmdline_popup", -- view for errors
          view_warn = "cmdline_popup", -- view for warnings
        },
        popupmenu = {
          view = "mini",
        },
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = false, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },

        format = {
          cmdline = { pattern = "^:", icon = "", lang = "vim" },
          search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
          search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
          filter = { pattern = "^:%s*!", icon = "", lang = "bash" },
          lua = { pattern = "^:%s*lua%s+", icon = "", lang = "lua" },
          help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
          input = {},
        },

        -- Hide written messages
        routes = {}

      })
    '';
  };
}
