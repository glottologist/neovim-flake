{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.vim.status.tabline.nvimBufferline = {
    enable = mkEnableOption "Enable nvim-bufferline-lua as a bufferline";
  };
}
