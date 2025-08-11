{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.vim.explorer.oil = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable oil";
    };
  };
}
