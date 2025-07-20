{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.ai;
in {
  config = mkIf (cfg.windsurf.enable) {
    vim.startPlugins = [
      "windsurf-nvim"
      "plenary-nvim"
      "nvim-cmp"
    ];

    # vim.luaConfigRC.windsurf-keys = nvim.dag.entryAnywhere ''
    #   ${nvim.lua.writeIf config.vim.keys.whichKey.enable ''
    #     require('mini.icons').setup()
    #       local mini_icons = require('mini.icons')
    #       local get_icon = function(category, name)
    #         local icon, hl = mini_icons.get(category, name)
    #         return icon
    #       end
    #         require("which-key").add({
    #
    #})
    #   ''}
    # '';
    vim.luaConfigRC.windsurf-keys = nvim.dag.entryAnywhere ''
      ${nvim.lua.writeIf config.vim.keys.whichKey.enable ''
               require('mini.icons').setup()
                 local mini_icons = require('mini.icons')
                 local get_icon = function(category, name)
                   local icon, hl = mini_icons.get(category, name)
                   return icon
                 end
                   require("which-key").add({
        -- AI/Codeium group
                 { "<leader>a", group = "AI", icon = get_icon("lsp", "class") },

                 -- Normal mode keybindings (if you want leader-based alternatives)
                 { "<leader>aa", "<cmd>Codeium Auth<CR>", desc = "Windsurf Authentication", icon = get_icon("lsp", "event") },
                 { "<leader>ac", "<cmd>Codeium Chat<CR>", desc = "Windsurf Chat", icon = get_icon("lsp", "boolean") },
                 { "<leader>at", "<cmd>Codeium Toggle<CR>", desc = "Windsurf Toggle", icon = get_icon("lsp", "boolean") },

                   })
      ''}
    '';

    vim.startLuaConfigRC.windsuf-setup = ''
      -- Setup Windsurf/Codeium first
      require("codeium").setup({
        -- Enable the completion source for blink.cmp
        enable_cmp_source = true,

        -- Disable virtual text to avoid conflicts with blink.cmp
        virtual_text = {
          enabled = false,
        },

      })

    '';
  };
}
