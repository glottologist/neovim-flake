{inputs, ...}: {
  perSystem = {
    system,
    inputs',
    ...
  }: {
    legacyPackages = import inputs.nixpkgs {
      inherit system;
      overlays = [
         inputs.self.overlays.default
      ];
    };
  };
}
