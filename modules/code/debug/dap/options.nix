{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.vim.code.debug = {
    dap = {
      enable = mkEnableOption "Enable debug adapter";
    };
  };
}
