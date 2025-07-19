{lib}:
with lib; let
  # Plugin must be same as input name from flake.nix
  availablePlugins = [
  
    # BASIC
    "plenary-nvim"

    # EXPLORER
    "neotree"
    "nui-nvim"

    # FIND
    "dressing-nvim"
    "telescope"
    "telescope-fzf-native"

    # KEYS
    "cheatsheet-nvim"
    "mini-icons"
    "nvim-web-devicons"
    "which-key"

    # STATUSLINE
    "lualine"

    # TABLINE
    "bufdelete-nvim"
    "bufferline-nvim"

    # THEME
    "catppuccin"
    "onedark"
    "papercolor"
    "tokyonight"
    "zenbones"

    # CODE

    ## AI
    "windsurf"

    ## LSP
    "nvim-lspconfig"
    "lspsaga"
    "lspkind"
    "null-ls"
    "lsp-signature"

    ## TREESITTER
    "nvim-treesitter"
    "nvim-treesitter-context"

    ## COMPLETION
    "blink-cmp"
    "blink-compat"
    "friendly-snippets"
    "cmp-buffer"
    "cmp-nvim-lsp"
    "cmp-path"
    "cmp-treesitter"
    "cmp-vsnip"
    "nvim-cmp"
    "vim-vsnip"

    ## Languages
    ### Rust
    "rust-tools"
    "crates-nvim"

    ### Nix
    "rnix-lsp"
    "nil"

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
