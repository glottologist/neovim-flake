{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.vim.ui.motion.mini;
in {
  options.vim.ui.motion.mini = {
    enable = mkEnableOption "Enable mini plugins";
  };
}
