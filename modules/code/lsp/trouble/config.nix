{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.lsp;
in {
  config = mkIf (cfg.enable && cfg.trouble.enable) {
    vim.startPlugins = ["trouble"];

    vim.nnoremap = {
      "<leader>ldt" = "<cmd>TroubleToggle<CR>";
      "<leader>ldw" = "<cmd>TroubleToggle workspace_diagnostics<CR>";
      "<leader>ldd" = "<cmd>TroubleToggle document_diagnostics<CR>";
      "<leader>ldr" = "<cmd>TroubleToggle lsp_references<CR>";
      "<leader>ldq" = "<cmd>TroubleToggle quickfix<CR>";
      "<leader>ldl" = "<cmd>TroubleToggle loclist<CR>";
    };

    vim.luaConfigRC.trouble = nvim.dag.entryAnywhere ''
      -- Enable trouble diagnostics viewer
      require("trouble").setup {}
    '';
  };
}
