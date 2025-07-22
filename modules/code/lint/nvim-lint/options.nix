{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.vim.code.lint = {
    nvim-lint = {
      enable = mkEnableOption "Enable nvim lint";
    };
  };
}
