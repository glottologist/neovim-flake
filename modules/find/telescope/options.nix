{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.vim.find.telescope = {
    enable = mkEnableOption "Enable multi-purpose telescope utility";
    manix = {
    enable = mkEnableOption "Enable manix support for telescope utility";
    };
  };
}
