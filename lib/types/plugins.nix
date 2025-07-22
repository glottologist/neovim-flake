{lib}:
with lib; let
  # Plugin must be same as input name from flake.nix
  availablePlugins = [
    # BASIC
    "plenary-nvim"

    # EXPLORER
    "neotree"
    "nvimtree"
    "nui-nvim"

    # FIND
    "dressing-nvim"
    "telescope"
    "telescope-fzf-native"
    "search"
    "telescope-media-files"
    "telescope-manix"

    # KEYS
    "cheatsheet-nvim"
    "mini-icons"
    "nvim-web-devicons"
    "which-key"

    # STATUS
    "lualine"
    "bufdelete-nvim"
    "bufferline-nvim"

    # THEME
    "catppuccin"
    "onedark"
    "papercolor"
    "tokyonight"
    "zenbones"
    "lush"

    # CODE

    ## ACTIONS
    "actions-preview"

    ## AI
    "windsurf-nvim"

    ## DEBUG
    "dap"
    "dap-ui"
    "dap-virtual-text"
    "nvim-nio"

    ## DIFF
    "diffview"

    ## FOLDS
    "nvim-ufo"
    "promise-async"

    ## LSP
    "nvim-lspconfig"
    "nvim-lightbulb"
    "lspkind"
    "null-ls"
    "lsp-signature"
    "trouble"

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

    ## Git
    "git-worktrees"
    "gitsigns-nvim"

    # UI
    "modes-nvim"
    "noice-nvim"
    "nui-nvim"
    "nvim-notify"

    ## Motion
    "flash-nvim"
    "eyeliner"
    "mini-nvim"
    "nvim-spider"
    "harpoon"
    "tide"

    ## Visuals
    "ccc-nvim"
    "cinnamon-nvim"
    "fidget-nvim"
    "indent-blankline"
    "twilight"
    "zenmode"
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
