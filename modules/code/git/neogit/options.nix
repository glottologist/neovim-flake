{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.vim.code.git = {
    neogit = {
      enable = mkEnableOption "Enable neogit";
    };
  };
}
