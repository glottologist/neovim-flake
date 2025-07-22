{
  description = "A neovim flake with a modular configuration";
  outputs = {
    nixpkgs,
    flake-parts,
    self,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        # add lib to module args
        {_module.args = {inherit (nixpkgs) lib inputs;};}
        #   inputs.blink-cmp.packages.${pkgs.system}.default
        ./flake/apps.nix
        ./flake/legacyPackages.nix
        ./flake/overlays.nix
        ./flake/packages.nix
      ];

      flake = {
        lib = {
          inherit (import ./lib/stdlib-extended.nix nixpkgs.lib) nvim;
          inherit (import ./configuration.nix inputs) neovimConfiguration;
        };

        homeManagerModules = {
          neovim-flake = {
            imports = [
              (import ./lib/module self.packages)
            ];
          };

          default = self.homeManagerModules.neovim-flake;
        };
      };

      perSystem = {
        config,
        pkgs,
        ...
      }: {
        devShells.default = pkgs.mkShell {nativeBuildInputs = [config.packages.editor];};
      };
    };

  # Flake inputs
  inputs = {
    nixpkgs.url = "github:glottologist/nixpkgs/release-25.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";

    # BASIC
    plenary-nvim = {
      # (required by crates-nvim)
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    # EXPLORER
    nui-nvim = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };

    neotree = {
      url = "github:nvim-neo-tree/neo-tree.nvim";
      flake = false;
    };
    nvimtree = {
      url = "github:nvim-tree/nvim-tree.lua";
      flake = false;
    };

    # TABLINE
    bufferline-nvim = {
      url = "github:akinsho/bufferline.nvim";
      flake = false;
    };
    bufdelete-nvim = {
      url = "github:famiu/bufdelete.nvim";
      flake = false;
    };

    # STATUSLINE
    lualine = {
      url = "github:hoob3rt/lualine.nvim";
      flake = false;
    };

    # THEME
    tokyonight = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };

    onedark = {
      url = "github:navarasu/onedark.nvim";
      flake = false;
    };

    catppuccin = {
      url = "github:catppuccin/nvim";
      flake = false;
    };

    dracula = {
      url = "github:Mofiqul/dracula.nvim";
      flake = false;
    };

    zenbones = {
      url = "github:mcchrish/zenbones.nvim";
      flake = false;
    };

    papercolor = {
      url = "github:vim-scripts/PaperColor.vim";
      flake = false;
    };
    lush = {
      url = "github:rktjmp/lush.nvim";
      flake = false;
    };

    # FIND
    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    telescope-fzf-native = {
      url = "github:nvim-telescope/telescope-fzf-native.nvim";
      flake = false;
    };
    dressing-nvim = {
      url = "github:stevearc/dressing.nvim";
      flake = false;
    };
    telescope-media-files = {
      url = github:nvim-telescope/telescope-media-files.nvim;
      flake = false;
    };
    search = {
      url = github:FabianWirth/search.nvim;
      flake = false;
    };
    telescope-manix = {
      url = github:mrcjkb/telescope-manix;
      flake = false;
    };

    # KEYS
    nvim-web-devicons = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };

    mini-icons = {
      url = "github:echasnovski/mini.icons";
      flake = false;
    };

    which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };

    cheatsheet-nvim = {
      url = "github:sudormrfbin/cheatsheet.nvim";
      flake = false;
    };

    # CODE

    ## ACTIONS
    actions-preview = {
      url = "github:aznhe21/actions-preview.nvim";
      flake = false;
    };

    ## AI
    windsurf-nvim = {
      url = "github:Exafunction/windsurf.vim";
      flake = false;
    };

    ## DEBUG
    dap = {
      url = "github:mfussenegger/nvim-dap";
      flake = false;
    };
    dap-ui = {
      url = "github:rcarriga/nvim-dap-ui";
      flake = false;
    };
    dap-virtual-text = {
      url = "github:theHamsta/nvim-dap-virtual-text";
      flake = false;
    };
    nvim-nio = {
      url = "github:nvim-neotest/nvim-nio";
      flake = false;
    };

    ## FOLDS
    nvim-ufo = {
      url = github:kevinhwang91/nvim-ufo;
      flake = false;
    };
    promise-async = {
      url = github:kevinhwang91/promise-async; # required by nvim-ufo
      flake = false;
    };

    ## LSP
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };

    lspkind = {
      url = "github:onsails/lspkind-nvim";
      flake = false;
    };
    null-ls = {
      url = "github:jose-elias-alvarez/null-ls.nvim";
      flake = false;
    };
    lsp-signature = {
      url = "github:ray-x/lsp_signature.nvim";
      flake = false;
    };
    nvim-lightbulb = {
      url = "github:kosayoda/nvim-lightbulb";
      flake = false;
    };
    trouble = {
      url = "github:folke/trouble.nvim";
      flake = false;
    };

    ## TREESITTER
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    nvim-treesitter-context = {
      url = "github:nvim-treesitter/nvim-treesitter-context";
      flake = false;
    };

    ## COMPLETION
    blink-cmp = {
      url = "github:Saghen/blink.cmp";
    };
    blink-compat = {
      url = "github:Saghen/blink.compat";
      flake = false;
    };
    friendly-snippets = {
      url = "github:rafamadriz/friendly-snippets";
      flake = false;
    };

    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-vsnip = {
      url = "github:hrsh7th/cmp-vsnip";
      flake = false;
    };
    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    cmp-treesitter = {
      url = "github:ray-x/cmp-treesitter";
      flake = false;
    };

    vim-vsnip = {
      url = "github:hrsh7th/vim-vsnip";
      flake = false;
    };

    ## Diff
    diffview = {
      url = "github:sindrets/diffview.nvim";
      flake = false;
    };

    ## Languages

    ### Rust
    rust-tools = {
      url = "github:simrat39/rust-tools.nvim";
      flake = false;
    };
    crates-nvim = {
      url = "github:Saecki/crates.nvim";
      flake = false;
    };

    ### Nix
    rnix-lsp.url = "github:nix-community/rnix-lsp";
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ## Git
    git-worktrees = {
      url = "github:ThePrimeagen/git-worktree.nvim";
      flake = false;
    };
    gitsigns-nvim = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };

    # UI
    noice-nvim = {
      url = "github:folke/noice.nvim";
      flake = false;
    };
    modes-nvim = {
      url = "github:mvllow/modes.nvim";
      flake = false;
    };
    nvim-notify = {
      url = "github:rcarriga/nvim-notify";
      flake = false;
    };
    ## Motion
    flash-nvim = {
      url = "github:folke/flash.nvim";
      flake = false;
    };
    eyeliner = {
      url = "github:jinh0/eyeliner.nvim";
      flake = false;
    };
    mini-nvim = {
      url = "github:echasnovski/mini.nvim";
      flake = false;
    };
    nvim-spider = {
      url = "github:chrisgrieser/nvim-spider";
      flake = false;
    };
    harpoon = {
      url = "github:ThePrimeagen/harpoon?ref=harpoon2";
      flake = false;
    };
    tide = {
      url = github:jackMort/tide.nvim;
      flake = false;
    };

    ## Visuals

    ### Colour picker
    ccc-nvim = {
      url = "github:uga-rosa/ccc.nvim";
      flake = false;
    };

    ### Smooth scrolling
    cinnamon-nvim = {
      url = "github:declancm/cinnamon.nvim";
      flake = false;
    };

    ### Unobtrusive status messages
    fidget-nvim = {
      url = "github:j-hui/fidget.nvim";
      flake = false;
    };

    ### Indent markings
    indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };

    ### Dimmed focus
    twilight = {
      url = github:folke/twilight.nvim;
      flake = false;
    };

    ### Focus mode
    zenmode = {
      url = github:folke/zen-mode.nvim;
      flake = false;
    };
  };
}
