
{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.tabline.nvimBufferline;
in {
  config = mkIf cfg.enable (
    let
      mouse = {
        right = "'vertical sbuffer %d'";
        close = ''
          function(bufnum)
            require("bufdelete").bufdelete(bufnum, false)
          end
        '';
      };
    in {
      vim.startPlugins = [
        "bufferline-nvim"
        "bufdelete-nvim"
        "nvim-web-devicons"
      ];

      vim.nnoremap = {
        "<silent><leader>btr" = ":BufferLineTabRename<CR>";
        "<silent><leader>bxl" = ":BufferLineCloseLeft<CR>";
        "<silent><leader>bxr" = ":BufferLineCloseRight<CR>";
        "<silent><leader>bxo" = ":BufferLineCloseOthers<CR>";
        "<silent><leader>bp" = ":BufferLinePick<CR>";
        "<silent><leader>bcn" = ":BufferLineCycleNext<CR>";
        "<silent><leader>bcp" = ":BufferLineCyclePrev<CR>";  
        "<silent><leader>bse" = ":BufferLineSortByExtension<CR>";
        "<silent><leader>bsd" = ":BufferLineSortByDirectory<CR>";
        "<silent><leader>bst" = ":BufferLineSortByTabs<CR>";
        "<silent><leader>bmn" = ":BufferLineMoveNext<CR>";
        "<silent><leader>bmp" = ":BufferLineMovePrev<CR>";
        "<silent><leader>bg1" = "<Cmd>BufferLineGoToBuffer 1<CR>";
        "<silent><leader>bg2" = "<Cmd>BufferLineGoToBuffer 2<CR>";
        "<silent><leader>bg3" = "<Cmd>BufferLineGoToBuffer 3<CR>";
        "<silent><leader>bg4" = "<Cmd>BufferLineGoToBuffer 4<CR>";
        "<silent><leader>bg5" = "<Cmd>BufferLineGoToBuffer 5<CR>";
        "<silent><leader>bg6" = "<Cmd>BufferLineGoToBuffer 6<CR>";
        "<silent><leader>bg7" = "<Cmd>BufferLineGoToBuffer 7<CR>";
        "<silent><leader>bg8" = "<Cmd>BufferLineGoToBuffer 8<CR>";
        "<silent><leader>bg9" = "<Cmd>BufferLineGoToBuffer 9<CR>";
      };

      vim.luaConfigRC.nvimBufferline = nvim.dag.entryAnywhere ''
        require("bufferline").setup({
          options = {
            mode = "buffers",
            numbers = "none",
            close_command = ${mouse.close},
            right_mouse_command = ${mouse.right},
            left_mouse_command = "buffer %d",
            middle_mouse_command = nil,
            indicator = {
              icon = "▎",
              style = "icon",
            },
            buffer_close_icon = "󰅖",
            modified_icon = "●",
            close_icon = "",
            left_trunc_marker = "",
            right_trunc_marker = "",
            max_name_length = 18,
            max_prefix_length = 15,
            tab_size = 18,
            diagnostics = "nvim_lsp",
            diagnostics_update_in_insert = false,
            color_icons = true,
            show_buffer_icons = true,
            show_buffer_close_icons = true,
            show_close_icon = true,
            show_tab_indicators = true,
            persist_buffer_sort = true,
            separator_style = "slant",
            enforce_regular_tabs = false,
            always_show_bufferline = true,
            sort_by = "id",
            offsets = {
              {
                filetype = "neo-tree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left",
              },
            },
          },
        })
      '';
    }
  );
}