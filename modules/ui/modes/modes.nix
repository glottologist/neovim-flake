{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.vim.ui.modes = {
    enable = mkEnableOption "Enable modes.nvim UI elements";
  };
}
