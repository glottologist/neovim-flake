{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.vim.find.telescope.media-files;
in {
  config =
    mkIf (cfg.enable && config.vim.find.telescope.enable) {
      vim.startPlugins = ["telescope-media-files"];

      vim.nnoremap = {
        "<leader>fi" = "<cmd> Telescope media_files<CR>";
      };

      vim.luaConfigRC.telescope-media-files = nvim.dag.entryAnywhere ''
        require("telescope").load_extension("media_files")
      '';
    };
}
