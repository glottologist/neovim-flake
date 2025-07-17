{inputs, ...}: {
  perSystem = {
    system,
    config,
    pkgs,
    ...
  }:
  {
    packages =
      {

        # nvim configs
        editor = config.legacyPackages.neovim-editor;
        developer = config.legacyPackages.neovim-developer;
        default = config.legacyPackages.neovim-editor;
      };
  };
}
