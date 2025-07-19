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
  options.vim.code.lsp = {
    lspsaga = {
      enable = mkEnableOption "vscode-like pictograms for lsp [lspkind]";
    };
  };
}
