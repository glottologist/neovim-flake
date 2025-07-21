{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.lsp;
in {
  config = mkIf (cfg.enable && cfg.trouble.enable) {
    vim.startPlugins = ["trouble"];

    vim.nnoremap = {
      "<leader>ldt" = "<cmd>TroubleToggle<CR>";
      "<leader>ldw" = "<cmd>TroubleToggle workspace_diagnostics<CR>";
      "<leader>ldd" = "<cmd>TroubleToggle document_diagnostics<CR>";
      "<leader>ldr" = "<cmd>TroubleToggle lsp_references<CR>";
      "<leader>ldq" = "<cmd>TroubleToggle quickfix<CR>";
      "<leader>ldl" = "<cmd>TroubleToggle loclist<CR>";
    };
vim.luaConfigRC.trouble-keys = nvim.dag.entryAnywhere ''
        ${nvim.lua.writeIf config.vim.keys.whichKey.enable ''
          require('mini.icons').setup()
          local mini_icons = require('mini.icons')
          local get_icon = function(category, name)
            local icon, hl = mini_icons.get(category, name)
            return icon
          end

          require("which-key").add({
            -- Extend the existing LSP diagnostics group
            { "<leader>ld", group = "Diagnostics", icon = get_icon("lsp", "error") },
            
            -- Trouble diagnostics commands
            { "<leader>ldt", "<cmd>TroubleToggle<CR>", desc = "Toggle Trouble", icon = get_icon("lsp", "error") },
            { "<leader>ldw", "<cmd>TroubleToggle workspace_diagnostics<CR>", desc = "Workspace diagnostics", icon = get_icon("default", "directory") },
            { "<leader>ldd", "<cmd>TroubleToggle document_diagnostics<CR>", desc = "Document diagnostics", icon = get_icon("default", "file") },
            { "<leader>ldr", "<cmd>TroubleToggle lsp_references<CR>", desc = "LSP references", icon = get_icon("lsp", "reference") },
            { "<leader>ldq", "<cmd>TroubleToggle quickfix<CR>", desc = "Quickfix list", icon = get_icon("lsp", "array") },
            { "<leader>ldl", "<cmd>TroubleToggle loclist<CR>", desc = "Location list", icon = get_icon("lsp", "array") },
          })
        ''}

        -- Set up the actual keymaps
        local opts = { noremap = true, silent = true }
        vim.api.nvim_set_keymap("n", "<leader>ldt", "<cmd>TroubleToggle<CR>", opts)
        vim.api.nvim_set_keymap("n", "<leader>ldw", "<cmd>TroubleToggle workspace_diagnostics<CR>", opts)
        vim.api.nvim_set_keymap("n", "<leader>ldd", "<cmd>TroubleToggle document_diagnostics<CR>", opts)
        vim.api.nvim_set_keymap("n", "<leader>ldr", "<cmd>TroubleToggle lsp_references<CR>", opts)
        vim.api.nvim_set_keymap("n", "<leader>ldq", "<cmd>TroubleToggle quickfix<CR>", opts)
        vim.api.nvim_set_keymap("n", "<leader>ldl", "<cmd>TroubleToggle loclist<CR>", opts)
      '';
    vim.luaConfigRC.trouble = nvim.dag.entryAnywhere ''
      -- Enable trouble diagnostics viewer
      require("trouble").setup {}
    '';
  };
}
