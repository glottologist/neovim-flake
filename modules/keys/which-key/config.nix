{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.keys.whichKey;
in {
  config = mkIf (cfg.enable) {
    vim.startPlugins = ["which-key" "mini-icons" "nvim-web-devicons"];

    vim.startLuaConfigRC.whichkey = ''
      local wk = require("which-key")

      wk.setup({
        preset = "modern",
      })
    '';
  };
}
