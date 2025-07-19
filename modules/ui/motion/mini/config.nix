{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.vim.ui.motion.mini;
in {
  config = mkIf cfg.enable {
    vim.startPlugins = ["mini-nvim"];

    vim.nnoremap = {
    };

    vim.luaConfigRC.mini = nvim.dag.entryAnywhere ''
        require('mini.ai').setup()
      require('mini.surround').setup()
    '';
  };
}
