{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.vim.ui.motion.eyeliner;
in {
  config = mkIf cfg.enable {
    vim.startPlugins = ["eyeliner"];

    vim.nnoremap = {
      "<leader>ue" = "<cmd> EyelinerToggle<CR>";
    };

    vim.luaConfigRC.flash-nvim = nvim.dag.entryAnywhere ''
      require('eyeliner').setup({
        highlight_on_key = true,
        dim = false           
      })
    '';
  };
}
