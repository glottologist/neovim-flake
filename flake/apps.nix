{lib, ...}: {
  perSystem = {
    system,
    config,
    ...
  }: {
    apps =
      {
        editor.program = lib.getExe config.packages.editor;
        developer.program = lib.getExe config.packages.developer;
        default = config.apps.editor;
      };
  };
}
