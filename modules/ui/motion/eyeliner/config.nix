{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.vim.ui.motion.eyeliner;
in {
  config = mkIf cfg.enable {
    vim.startPlugins = ["eyeliner"];

    vim.nnoremap = {
      "<leader>ue" = "<cmd> EyelinerToggle<CR>";
    };

    vim.luaConfigRC.eyeliner = nvim.dag.entryAnywhere ''
       require'eyeliner'.setup {
        highlight_on_key = true,
        default_keymaps = true,
        dim = false           
      }
      
    '';

      vim.luaConfigRC.eyeliner-keys = nvim.dag.entryAnywhere ''
        ${nvim.lua.writeIf config.vim.keys.whichKey.enable ''
          require('mini.icons').setup()
          local mini_icons = require('mini.icons')
          local get_icon = function(category, name)
            local icon, hl = mini_icons.get(category, name)
            return icon
          end

          require("which-key").add({
            -- Motion/UI group (if not already defined)
            { "<leader>u", group = "UI/Motion", icon = get_icon("lsp", "interface") },
            
            -- Eyeliner toggle
            { "<leader>ue", "<cmd>EyelinerToggle<CR>", desc = "Toggle Eyeliner", icon = get_icon("lsp", "event") },
          })
        ''}
      '';
  };
}
