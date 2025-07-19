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
  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.code.treesitter.enable = true;

      vim.code.treesitter.grammars = [cfg.treesitter.mdPackage cfg.treesitter.mdInlinePackage];
    })

  ]);
}
