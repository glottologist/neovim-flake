{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.keys.cheatsheet;
in {
  config = mkIf (cfg.enable) {
    vim.startPlugins = ["cheatsheet-nvim"];

    vim.luaConfigRC.cheatsheet-keys = nvim.dag.entryAnywhere ''
      ${nvim.lua.writeIf config.vim.keys.whichKey.enable ''
        require('mini.icons').setup()
        local mini_icons = require('mini.icons')
        local get_icon = function(category, name)
          local icon, hl = mini_icons.get(category, name)
          return icon
        end

        require("which-key").add({
          -- Help group
          { "<leader>h", group = "Help", icon = get_icon("lsp", "keyword") },

          -- Cheatsheet commands
          { "<leader>hc", "<cmd>Cheatsheet<CR>", desc = "Show cheatsheet", icon = get_icon("default", "file") },
          { "<leader>?", "<cmd>Cheatsheet<CR>", desc = "Show cheatsheet", icon = get_icon("lsp", "keyword") },
        })
      ''}
    '';

    vim.luaConfigRC.cheatsheet-nvim = nvim.dag.entryAnywhere ''
      require('cheatsheet').setup({})
      local opts = { noremap = true, silent = true }

       vim.keymap.set("n", "<leader>?", "", opts)
       vim.keymap.set("n", "<leader>hc", "<cmd>Cheatsheet<cr>", opts)
    '';
  };
}
