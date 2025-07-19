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
  config = mkIf cfg.lspconfig.enable (mkMerge [
    {
      vim.code.lsp.enable = true;

      vim.startPlugins = ["nvim-lspconfig"];

      vim.luaConfigRC.lspconfig = nvim.dag.entryAfter ["lsp-setup"] ''
        local lspconfig = require('lspconfig')
      '';
    }
    {
      vim.luaConfigRC = mapAttrs (_: v: (nvim.dag.entryAfter ["lspconfig"] v)) cfg.lspconfig.sources;
    }
  ]);
}
