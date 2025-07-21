{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.vim.ui.motion.eyeliner;
in {
  options.vim.ui.motion.eyeliner = {
    enable = mkEnableOption "Enable eyeliner plugin";
  };
}
