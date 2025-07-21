{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.git;
in {
  options.vim.code.git = {
    enable = mkEnableOption "Git support";

    gitworktrees = {
      enable = mkEnableOption "gitworktrees";
    };
    
    gitsigns = {
      enable = mkEnableOption "gitsigns";

      codeActions = mkEnableOption "gitsigns codeactions through null-ls";
    };
  };
}
