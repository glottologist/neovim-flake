{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; {
  options.vim.code.lsp = {
    enable = mkEnableOption "Enable Language server";
    formatOnSave = mkEnableOption "format on save";
  };
}
