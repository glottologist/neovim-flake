{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.vim.ui.motion.tide;
in {
  options.vim.ui.motion.tide = {
    enable = mkOption {
      type = types.bool;
      description = "Enable the Tide plugin (better marks-based navigation)";
    };

    keys = {
      leader = mkOption {
        type = types.str;
        default = ";";
        description = "Leader key to prefix all Tide commands";
      };
      panel = mkOption {
        type = types.str;
        default = ";";
        description = "Open the panel (uses leader key as prefix)";
      };
      addItem = mkOption {
        type = types.str;
        default = "a";
        description = "Add new tiem to the list";
      };
      deleteItem = mkOption {
        type = types.str;
        default = "d";
        description = "Remove an tiem from the list";
      };
      clearAll = mkOption {
        type = types.str;
        default = "x";
        description = "Clear all items";
      };
      splits = {
        horizonal = mkOption {
          type = types.str;
          default = "-";
          description = "Split window horizontally";
        };
        vertical = mkOption {
          type = types.str;
          default = "|";
          description = "Split window vertically";
        };
      };
    };
  };
}
