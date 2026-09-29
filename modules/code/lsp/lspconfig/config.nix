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

      # The `require('lspconfig')` framework is deprecated and due for removal
      # in nvim-lspconfig v3.0.0. We now drive servers through `vim.lsp.config`
      # instead, leaving the plugin to supply the `lsp/<server>.lua` definitions
      # that Neovim reads from the runtimepath. This entry remains solely as the
      # ordering anchor that the per-language sources attach themselves to.
      vim.luaConfigRC.lspconfig = nvim.dag.entryAfter ["lsp-setup"] "";
    }
    {
      vim.luaConfigRC = mapAttrs (_: v: (nvim.dag.entryAfter ["lspconfig"] v)) cfg.lspconfig.sources;
    }
  ]);
}
