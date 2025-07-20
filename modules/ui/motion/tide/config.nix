{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.vim.ui.motion.tide;
in {
  config = mkIf cfg.enable {
    vim.startPlugins = ["tide"];

    vim.nnoremap = {
    };

    vim.luaConfigRC.mini = nvim.dag.entryAnywhere ''
      require('tide').setup({
        keys = {
          leader = "${cfg.keys.leader}",
          panel = "${cfg.keys.panel}",
          add_item = "${cfg.keys.addItem}",
          delete = "${cfg.keys.deleteItem}",
          clear_all = "${cfg.keys.clearAll}",
          horizontal = "${cfg.keys.splits.horizonal}",
          vertical = "${cfg.keys.splits.vertical}",
        },
        animation_duration = 300,  -- Animation duration in milliseconds
        animation_fps = 30,        -- Frames per second for animations
      })
    '';
  };
}
