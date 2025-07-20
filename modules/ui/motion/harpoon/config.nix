{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.vim.ui.motion.harpoon;
in {
  config = mkIf cfg.enable {
    vim.startPlugins = ["harpoon"];

    vim.nnoremap = {
    };

    vim.luaConfigRC.harpoon = nvim.dag.entryAnywhere ''
      require('harpoon'):setup()
    '';
  };
}
