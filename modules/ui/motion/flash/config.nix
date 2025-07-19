{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.vim.ui.motion.flash;
in {
  config = mkIf cfg.enable {
    vim.startPlugins = ["flash-nvim"];

    vim.nnoremap = {
    };

    vim.luaConfigRC.flash-nvim = nvim.dag.entryAnywhere ''
      require('flash').setup()
    '';
  };
}
