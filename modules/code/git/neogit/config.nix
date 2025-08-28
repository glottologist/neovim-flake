{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.git;
in {
  config = mkIf (cfg.neogit.enable) {
    vim.startPlugins = [
      "neogit"
    ];

    vim.luaConfigRC.neogit-keys = nvim.dag.entryAnywhere ''
      ${nvim.lua.writeIf config.vim.keys.whichKey.enable ''
        require('mini.icons').setup()
          local mini_icons = require('mini.icons')
          local get_icon = function(category, name)
            local icon, hl = mini_icons.get(category, name)
            return icon
          end
            require("which-key").add({
            })
      ''}
    '';

    vim.startLuaConfigRC.neogit-setup = ''
          local neogit = require("neogit")

      neogit.setup {}
    '';
  };
}
