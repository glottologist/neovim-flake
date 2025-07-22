{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.vim.code.format = {
    conform = {
      enable = mkEnableOption "Enable conform formatter";
    };
  };
}
