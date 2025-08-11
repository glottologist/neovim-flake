{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.explorer.oil;
in {
  config = mkIf cfg.enable {
    vim.startPlugins = ["oil"];

    vim.luaConfigRC.oil = nvim.dag.entryAnywhere ''
            require('oil').setup({
      default_file_explorer = false,
            })
    '';

    vim.luaConfigRC.oil-keys = nvim.dag.entryAnywhere ''
      ${nvim.lua.writeIf config.vim.keys.whichKey.enable ''
        require('mini.icons').setup()
        local mini_icons = require('mini.icons')
        local get_icon = function(category, name)
          local icon, hl = mini_icons.get(category, name)
          return icon
        end

        require("which-key").add({
          -- Main Explorer group

          -- Explorer commands
          { "<leader>-", "<cmd>Oil<CR>", desc = "Toggle Oil", icon = get_icon("default", "directory") },
          { "<leader>eo", "<cmd>Oil<CR>", desc = "Toggle Oil", icon = get_icon("default", "directory") },
        })
      ''}

      -- Set up the actual keymaps
      local opts = { silent = true, noremap = true }
      vim.api.nvim_set_keymap("n", "<leader>-", ":Oil<cr>", opts)
      vim.api.nvim_set_keymap("n", "<leader>eo", ":Oil<cr>", opts)
    '';
  };
}
