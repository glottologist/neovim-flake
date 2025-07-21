{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.vim.code.folds = {
    ufo = {
      enable = mkEnableOption "Enable UFO folds plugin";
    };
  };
}
