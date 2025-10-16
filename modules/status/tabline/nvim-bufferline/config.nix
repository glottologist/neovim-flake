{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.status.tabline.nvimBufferline;
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

      vim.luaConfigRC.bufferline-keys = nvim.dag.entryAnywhere ''
        ${nvim.lua.writeIf config.vim.keys.whichKey.enable ''
          require('mini.icons').setup()
          local mini_icons = require('mini.icons')
          local get_icon = function(category, name)
            local icon, hl = mini_icons.get(category, name)
            return icon
          end

          require("which-key").add({
            -- Main Buffer group
            { "<leader>b", group = "Buffer", icon = get_icon("default", "file") },

            -- Buffer cycling
            { "<leader>bc", group = "Cycle", icon = get_icon("lsp", "reference") },
            { "<leader>bcn", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer", icon = get_icon("lsp", "reference") },
            { "<leader>bcp", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer", icon = get_icon("lsp", "reference") },

            -- Buffer moving
            { "<leader>bm", group = "Move", icon = get_icon("lsp", "operator") },
            { "<leader>bmn", "<cmd>BufferLineMoveNext<CR>", desc = "Move next", icon = get_icon("lsp", "operator") },
            { "<leader>bmp", "<cmd>BufferLineMovePrev<CR>", desc = "Move previous", icon = get_icon("lsp", "operator") },

            -- Buffer closing
            { "<leader>bx", group = "Close", icon = get_icon("lsp", "keyword") },
            { "<leader>bxl", "<cmd>BufferLineCloseLeft<CR>", desc = "Close left", icon = get_icon("lsp", "keyword") },
            { "<leader>bxr", "<cmd>BufferLineCloseRight<CR>", desc = "Close right", icon = get_icon("lsp", "keyword") },
            { "<leader>bxo", "<cmd>BufferLineCloseOthers<CR>", desc = "Close others", icon = get_icon("lsp", "keyword") },

            -- Quick close others
            { "<leader>X", "<cmd>BufferLineCloseOthers<CR>", desc = "Close all other buffers", icon = get_icon("lsp", "keyword") },

            -- Buffer sorting
            { "<leader>bs", group = "Sort", icon = get_icon("lsp", "method") },
            { "<leader>bse", "<cmd>BufferLineSortByExtension<CR>", desc = "Sort by extension", icon = get_icon("lsp", "method") },
            { "<leader>bsd", "<cmd>BufferLineSortByDirectory<CR>", desc = "Sort by directory", icon = get_icon("lsp", "method") },
            { "<leader>bst", "<cmd>BufferLineSortByTabs<CR>", desc = "Sort by tabs", icon = get_icon("lsp", "method") },

            -- Buffer tab operations
            { "<leader>bt", group = "Tab", icon = get_icon("default", "file") },
            { "<leader>btr", "<cmd>BufferLineTabRename<CR>", desc = "Rename tab", icon = get_icon("lsp", "text") },

            -- Buffer picking
            { "<leader>bp", "<cmd>BufferLinePick<CR>", desc = "Pick buffer", icon = get_icon("lsp", "event") },

            -- Buffer go-to (numbered buffers)
            { "<leader>bg", group = "Go to", icon = get_icon("lsp", "number") },
            { "<leader>bg1", "<cmd>BufferLineGoToBuffer 1<CR>", desc = "Go to buffer 1", icon = "1" },
            { "<leader>bg2", "<cmd>BufferLineGoToBuffer 2<CR>", desc = "Go to buffer 2", icon = "2" },
            { "<leader>bg3", "<cmd>BufferLineGoToBuffer 3<CR>", desc = "Go to buffer 3", icon = "3" },
            { "<leader>bg4", "<cmd>BufferLineGoToBuffer 4<CR>", desc = "Go to buffer 4", icon = "4" },
            { "<leader>bg5", "<cmd>BufferLineGoToBuffer 5<CR>", desc = "Go to buffer 5", icon = "5" },
            { "<leader>bg6", "<cmd>BufferLineGoToBuffer 6<CR>", desc = "Go to buffer 6", icon = "6" },
            { "<leader>bg7", "<cmd>BufferLineGoToBuffer 7<CR>", desc = "Go to buffer 7", icon = "7" },
            { "<leader>bg8", "<cmd>BufferLineGoToBuffer 8<CR>", desc = "Go to buffer 8", icon = "8" },
            { "<leader>bg9", "<cmd>BufferLineGoToBuffer 9<CR>", desc = "Go to buffer 9", icon = "9" },
          })
        ''}
      '';

      vim.nnoremap = {
        "<silent><leader>btr" = ":BufferLineTabRename<CR>";
        "<silent><leader>bxl" = ":BufferLineCloseLeft<CR>";
        "<silent><leader>bxr" = ":BufferLineCloseRight<CR>";
        "<silent><leader>bxo" = ":BufferLineCloseOthers<CR>";
        "<silent><leader>X" = ":BufferLineCloseOthers<CR>";
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
              highlights = {
          -- Background fill (the area not covered by buffers)
          fill = {
            bg = '#eeeeee', -- color00: main background
          },

          -- Inactive buffers (background tabs)
          background = {
            fg = '#878787', -- color05: muted gray for inactive text
            bg = '#bcbcbc', -- color08: slightly darker than main bg for inactive tabs
          },

          -- Active/selected buffer
          buffer_selected = {
            fg = '#444444', -- color07: dark gray for good contrast on light bg
            bg = '#eeeeee', -- color00: main background to make it stand out
            bold = true,
            italic = false,
          },

          -- Buffer visible (when you have multiple windows)
          buffer_visible = {
            fg = '#005f87', -- color06: dark blue for visible but not active
            bg = '#d0d0d0', -- slightly darker than main bg
          },

          -- Close buttons
          close_button = {
            fg = '#878787', -- color05: muted for inactive close buttons
            bg = '#bcbcbc', -- color08: matches inactive buffer bg
          },
          close_button_selected = {
            fg = '#af0000', -- color01: red for active close button
            bg = '#eeeeee', -- color00: matches selected buffer bg
          },
          close_button_visible = {
            fg = '#005f87', -- color06: matches visible buffer fg
            bg = '#d0d0d0',
          },

          -- Separators (the thin lines between buffers)
          separator = {
            fg = '#eeeeee', -- color00: same as main bg to make separators invisible
            bg = '#bcbcbc', -- color08: inactive buffer bg
          },
          separator_selected = {
            fg = '#eeeeee', -- color00: same as main bg
            bg = '#eeeeee', -- color00: selected buffer bg
          },
          separator_visible = {
            fg = '#eeeeee', -- color00: same as main bg
            bg = '#d0d0d0',
          },

          -- Modified indicator (the dot that shows unsaved changes)
          modified = {
            fg = '#d75f00', -- color12: orange for modified indicator
            bg = '#bcbcbc', -- color08: inactive buffer bg
          },
          modified_selected = {
            fg = '#d75f00', -- color12: orange for modified indicator
            bg = '#eeeeee', -- color00: selected buffer bg
          },
          modified_visible = {
            fg = '#d75f00', -- color12: orange for modified indicator
            bg = '#d0d0d0',
          },

          -- Duplicate file names (when you have files with same name)
          duplicate = {
            fg = '#8700af', -- color11: purple for duplicates
            bg = '#bcbcbc', -- color08: inactive buffer bg
          },
          duplicate_selected = {
            fg = '#8700af', -- color11: purple for duplicates
            bg = '#eeeeee', -- color00: selected buffer bg
            bold = true,
          },
          duplicate_visible = {
            fg = '#8700af', -- color11: purple for duplicates
            bg = '#d0d0d0',
          },

          -- Tab separators (if using tabline mode)
          tab = {
            fg = '#878787', -- color05: muted gray
            bg = '#bcbcbc', -- color08: inactive buffer bg
          },
          tab_selected = {
            fg = '#444444', -- color07: dark gray
            bg = '#eeeeee', -- color00: main background
            bold = true,
          },
          tab_close = {
            fg = '#af0000', -- color01: red for close button
            bg = '#bcbcbc', -- color08: inactive buffer bg
          },

          -- Error/Warning/Info/Hint indicators (if using diagnostics)
          error = {
            fg = '#af0000', -- color01: red for errors
            bg = '#bcbcbc', -- color08: inactive buffer bg
          },
          error_selected = {
            fg = '#af0000', -- color01: red for errors
            bg = '#eeeeee', -- color00: selected buffer bg
          },

          warning = {
            fg = '#d75f00', -- color12: orange for warnings
            bg = '#bcbcbc', -- color08: inactive buffer bg
          },
          warning_selected = {
            fg = '#d75f00', -- color12: orange for warnings
            bg = '#eeeeee', -- color00: selected buffer bg
          },

          info = {
            fg = '#0087af', -- color04: blue for info
            bg = '#bcbcbc', -- color08: inactive buffer bg
          },
          info_selected = {
            fg = '#0087af', -- color04: blue for info
            bg = '#eeeeee', -- color00: selected buffer bg
          },

          hint = {
            fg = '#008700', -- color02: green for hints
            bg = '#bcbcbc', -- color08: inactive buffer bg
          },
          hint_selected = {
            fg = '#008700', -- color02: green for hints
            bg = '#eeeeee', -- color00: selected buffer bg
          },

          -- Pick indicators (for buffer picking mode)
          pick = {
            fg = '#d70000', -- color09: bright red
            bg = '#bcbcbc', -- color08: inactive buffer bg
            bold = true,
          },
          pick_selected = {
            fg = '#d70000', -- color09: bright red
            bg = '#eeeeee', -- color00: selected buffer bg
            bold = true,
          },
        },
                options = {
                  mode = "buffers",
                  numbers = "both",
                  close_command = ${mouse.close},
                  right_mouse_command = ${mouse.right},
                  left_mouse_command = "buffer %d",
                  middle_mouse_command = nil,
                  indicator = {
                    style = "underline",
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
                  update_in_insert = true,
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
