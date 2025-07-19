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

    vim.luaConfigRC.eyeliner = nvim.dag.entryAnywhere ''
       require'eyeliner'.setup {
        highlight_on_key = true,
        default_keymaps = true,
        dim = false           
      }
      
    '';
  };
}
