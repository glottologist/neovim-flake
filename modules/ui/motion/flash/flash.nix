{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.vim.ui.motion.flash;
in {
  options.vim.ui.motion.flash = {
    enable = mkEnableOption "Enable flash.nvim plugin";
  };
}
