{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.vim.code.lsp = {
    lspSignature = {
      enable = mkEnableOption "lsp signature viewer";
    };
  };
}
