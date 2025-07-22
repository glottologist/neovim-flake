{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.lint;
in {
  config = mkIf (cfg.nvim-lint.enable) {
    vim.startPlugins = [
      "nvim-lint"
    ];

    # Key mappings for DAP
    vim.nnoremap = {
    };

    # Visual mode mappings for eval
    vim.vnoremap = {
    };

    # Main DAP configuration
    vim.luaConfigRC.nvim-lint = nvim.dag.entryAnywhere ''
    require('lint').linters_by_ft = {
  rust = {'clippy'},
}

    '';

    # Which-key integration (if enabled)
    vim.luaConfigRC.nvim-lint-which-key = nvim.dag.entryAfter ["dap" "which-key"] ''
      ${nvim.lua.writeIf config.vim.keys.whichKey.enable ''
        local wk = require("which-key")
        wk.add({
        })
      ''}
    '';
  };
}
