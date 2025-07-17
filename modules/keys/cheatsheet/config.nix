{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.keys.cheatsheet;
in {
  config = mkIf (cfg.enable) {
    vim.startPlugins = ["cheatsheet-nvim"];

    vim.luaConfigRC.cheaetsheet-nvim = nvim.dag.entryAnywhere ''
      require('cheatsheet').setup({})
      local opts = { noremap = true, silent = true }

       vim.keymap.set("n", "<leader>?", "", opts)
       vim.keymap.set("n", "<leader>hc", "<cmd>Cheatsheet<cr>", opts)
    '';
  };
}
