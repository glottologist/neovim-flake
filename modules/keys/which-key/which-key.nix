{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.vim.keys.whichKey = {
    enable = mkEnableOption "Enable which-key keybind menu";
  };
}
