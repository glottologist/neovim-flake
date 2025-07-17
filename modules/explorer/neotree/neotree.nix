{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.vim.explorer.neotree = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable neotree";
    };
  };

}
