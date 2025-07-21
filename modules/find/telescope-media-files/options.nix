{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.vim.find.telescope.media-files;
in {
  options.vim.find.telescope.media-files = {
    enable = mkEnableOption "Enable media files telescope plugin";
  };
}
