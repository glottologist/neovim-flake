{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.actions;
in {
  config = mkIf (cfg.actionsPreview.enable) {
    vim.startPlugins = [
      "actions-preview"
    ];
    vim.nnoremap = {
      "<silent><leader>la" = "<cmd>lua require('actions-preview').code_actions()<CR>";
    };

    vim.luaConfigRC.actions-preview-keys = nvim.dag.entryAnywhere ''
      ${nvim.lua.writeIf config.vim.keys.whichKey.enable ''
                require('mini.icons').setup()
                  local mini_icons = require('mini.icons')
                  local get_icon = function(category, name)
                    local icon, hl = mini_icons.get(category, name)
                    return icon
                  end
                    require("which-key").add({
        { "<silent><leader>la", "<cmd>lua require('actions-preview').code_actions()<CR>", desc = "Show actions", icon = get_icon("lsp","event")}

                    })
      ''}
    '';
  };
}
