{
  inputs,
  pkgs,
  ...
}: let
  inherit (import ../configuration.nix inputs) neovimConfiguration mainConfig;

  buildPkg = pkgs: modules:
    (neovimConfiguration {inherit pkgs modules; check = false;})
    .neovim;

  editorConfig = mainConfig false;
  developerConfig = mainConfig true;
in {
  flake.overlays.default = _final: prev: {
    inherit neovimConfiguration;
    neovim-editor = buildPkg prev [editorConfig];
    neovim-developer = buildPkg prev [developerConfig];
    devPkg = buildPkg pkgs [editorConfig {}];
  };
}
