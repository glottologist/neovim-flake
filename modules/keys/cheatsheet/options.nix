{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.vim.keys.cheatsheet = {
    enable = mkEnableOption "Enable cheatsheet-nvim: searchable cheatsheet for nvim using telescope";
  };
}
