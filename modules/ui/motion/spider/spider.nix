{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.vim.ui.motion.spider;
in {
  options.vim.ui.motion.spider = {
    enable = mkEnableOption "Enable spider plugin";

    skipInsignificantPunctuation = mkOption {
      type = types.bool;
      default = true;
      description = "Skip insignificant punctuation when jumping";
    };
  };
}
