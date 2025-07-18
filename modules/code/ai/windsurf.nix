{
  config,
  lib,
  ...
}:
with lib;
with builtins; {
  options.vim.code.ai = {
    windsurf = {
      enable = mkEnableOption "Enable windsurf agentic editor";
    };
  };
}
