{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.format;
in {
  config = mkIf (cfg.conform.enable) {
    vim.startPlugins = [
      "conform"
    ];

    # Key mappings for DAP
    vim.nnoremap = {
    };

    # Visual mode mappings for eval
    vim.vnoremap = {
    };

    vim.luaConfigRC.conform =
      nvim.dag.entryAnywhere ''
      require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
  },
})
      '';

    # Which-key integration (if enabled)
    vim.luaConfigRC.conform-key = nvim.dag.entryAnywhere ''
      ${nvim.lua.writeIf config.vim.keys.whichKey.enable ''
        ''}
    '';
  };
}
