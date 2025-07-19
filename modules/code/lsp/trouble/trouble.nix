{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.vim.code.lsp = {
    trouble = {
      enable = mkEnableOption "Enable trouble diagnostics viewer";
    };
  };
}
