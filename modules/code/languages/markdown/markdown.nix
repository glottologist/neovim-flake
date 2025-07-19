{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.languages.markdown;
in {
  options.vim.code.languages.markdown = {
    enable = mkEnableOption "Markdown language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Markdown treesitter";
        type = types.bool;
        default = config.vim.code.languages.enableTreesitter;
      };
      mdPackage = nvim.types.mkGrammarOption pkgs "markdown";
      mdInlinePackage = nvim.types.mkGrammarOption pkgs "markdown-inline";
    };
  };
}
