{lib}:
with lib; let
  # Plugin must be same as input name from flake.nix
  availablePlugins = [
  
    # BASIC
    "plenary-nvim"

    # EXPLORER
    "nui-nvim"
    "neotree"

    # KEYS
    "which-key"
    "cheatsheet-nvim"
    "nvim-web-devicons"
    "mini-icons"

    # STATUSLINE
    "lualine"

    # TABLINE
    "bufdelete-nvim"
    "bufferline-nvim"

    # THEME
    "catppuccin"
    "tokyonight"
    "onedark"
    "papercolor"
    "zenbones"

  ];
  # You can either use the name of the plugin or a package.
  pluginsType = with types;
    listOf (
      nullOr (
        either
        (enum availablePlugins)
        package
      )
    );
in {
  pluginsOpt = {
    description,
    default ? [],
  }:
    mkOption {
      inherit description default;
      type = pluginsType;
    };
}
