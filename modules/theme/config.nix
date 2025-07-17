{
  config,
  lib,
  ...
}:
with lib; {
  config = {
    vim.theme = {
      enable = mkDefault false;
      name = mkDefault "zenbones";
      style = mkDefault "light";
      transparent = mkDefault false;
      extraConfig = mkDefault "";
    };
  };
}
