{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.vim.ui.motion.spider;
in {
  config = mkIf cfg.enable {
    vim.startPlugins = ["nvim-spider"];

    vim.nnoremap = {
    };

    vim.luaConfigRC.spider = nvim.dag.entryAnywhere ''
      require("spider").setup({
        skipInsignificantPunctuation = ${boolToString cfg.skipInsignificantPunctuation}
      })

      vim.keymap.set({"n", "o", "x"}, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
      vim.keymap.set({"n", "o", "x"}, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
      vim.keymap.set({"n", "o", "x"}, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
      vim.keymap.set({"n", "o", "x"}, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })
    '';
  };
}
