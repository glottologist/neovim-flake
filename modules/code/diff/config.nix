{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.diff;
in {
  config = mkIf (cfg.diffview.enable) {
    vim.startPlugins = [
      "diffview"
      "plenary-nvim"
    ];

  };
}
