{inputs, ...}: {
  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    legacyPackages = import inputs.nixpkgs {
      system = pkgs.stdenv.hostPlatform.system;
      overlays = [
         inputs.self.overlays.default
      ];
    };
  };
}
