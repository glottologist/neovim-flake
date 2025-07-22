{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.find;
in {
  config = mkIf (cfg.spectre.enable) {
    vim.startPlugins = [
      "spectre-nvim"
    ];

    vim.luaConfigRC.spectre-keys = nvim.dag.entryAnywhere ''
      ${nvim.lua.writeIf config.vim.keys.whichKey.enable ''
        require('mini.icons').setup()
          local mini_icons = require('mini.icons')
          local get_icon = function(category, name)
            local icon, hl = mini_icons.get(category, name)
            return icon
          end
            require("which-key").add({
          { "<leader>f", group = "Search/Replace", icon = get_icon("filetype", "telescopeprompt") },
          { "<leader>st", "<cmd>lua require('spectre').toggle()<CR>", desc = "Toggle Spectre", icon = get_icon("default", "search") },
          { "<leader>sw", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", desc = "Search current word", icon = get_icon("default", "search") },
          { "<leader>sp", "<cmd>lua require('spectre').open_file_search({select_word=true})<CR>", desc = "Search on current file", icon = get_icon("default", "file") },

            })
      ''}
    '';

    vim.startLuaConfigRC.spectre-setup = ''
          vim.keymap.set('n', '<leader>st', '<cmd>lua require("spectre").toggle()<CR>', {
          desc = "Toggle Spectre"
      })
      vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
          desc = "Search current word"
      })
      vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
          desc = "Search on current file"
      })
    '';
  };
}
