{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.vim.find = {
    spectre = {
      enable = mkEnableOption "Enable spectre find and replace";
    };
  };
}
