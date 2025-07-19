{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.lsp;
in {
  options.vim.code.lsp.null-ls = {
    enable = mkEnableOption "null-ls, also enabled automatically";

    sources = mkOption {
      description = "null-ls sources";
      type = with types; attrsOf str;
      default = {};
    };
  };
}
