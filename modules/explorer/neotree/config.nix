{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.explorer.neotree;
in {
  config = mkIf cfg.enable {
    vim.startPlugins = ["nui-nvim" "neotree"];
vim.luaConfigRC.neotree-keys = nvim.dag.entryAnywhere ''
        ${nvim.lua.writeIf config.vim.keys.whichKey.enable ''
          require('mini.icons').setup()
          local mini_icons = require('mini.icons')
          local get_icon = function(category, name)
            local icon, hl = mini_icons.get(category, name)
            return icon
          end

          require("which-key").add({
            -- Main Explorer group
            { "<leader>e", group = "Explorer", icon = get_icon("default", "directory") },
            
            -- Explorer commands
            { "<leader>E", "<cmd>NeoTree<CR>", desc = "Toggle NeoTree", icon = get_icon("default", "directory") },
            { "<leader>eb", "<cmd>Neotree source=buffers position=left<CR>", desc = "Buffer explorer", icon = get_icon("default", "file") },
            { "<leader>ef", "<cmd>Neotree filesystem reveal left<CR>", desc = "File explorer (reveal)", icon = get_icon("default", "directory") },
            { "<leader>eg", "<cmd>Neotree git_status<CR>", desc = "Git status explorer", icon = get_icon("filetype", "git") },
          })
        ''}

        -- Set up the actual keymaps
        local opts = { silent = true, noremap = true }
        vim.api.nvim_set_keymap("n", "<leader>E", ":NeoTree<cr>", opts)
        vim.api.nvim_set_keymap("n", "<leader>eb", ":Neotree source=buffers position=left<cr>", opts)
        vim.api.nvim_set_keymap("n", "<leader>ef", ":Neotree filesystem reveal left<cr>", opts)
        vim.api.nvim_set_keymap("n", "<leader>eg", ":Neotree git_status<cr>", opts)
      '';
  };
}
