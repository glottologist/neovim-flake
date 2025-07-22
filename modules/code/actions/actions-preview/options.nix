{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.vim.code.actions = {
    actionsPreview = {
      enable = mkEnableOption "Enable actions preview";
    };
  };
}
