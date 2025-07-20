{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.vim.ui.motion.harpoon;
in {
  options.vim.ui.motion.harpoon = {
    enable = mkEnableOption "Enable mini plugins";
  };
}
