{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.explorer.neotree;
in {
  config = mkIf cfg.enable {
    vim.startPlugins = ["nui-nvim" "neotree"];

    vim.luaConfigRC.neotree = nvim.dag.entryAnywhere ''
        local opts = { silent = true, noremap = true }

        vim.api.nvim_set_keymap("n", "<leader>E", ":NeoTree<cr>", opts)
        vim.api.nvim_set_keymap("n", "<leader>eb", ":Neotree source=buffers position=left<cr>", opts)
        vim.api.nvim_set_keymap("n", "<leader>ef", ":Neotree filesystem reveal left<cr>", opts)
        vim.api.nvim_set_keymap("n", "<leader>eg", ":Neotree git_status<cr>", opts)
 
    '';
  };
}
