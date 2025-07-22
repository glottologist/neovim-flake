{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.vim.code.diff = {
    diffview = {
      enable = mkEnableOption "Enable diffview";
    };
  };
}
