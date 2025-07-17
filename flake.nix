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
        {_module.args = {inherit (nixpkgs) lib;};}
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

    # BASOC
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

  };
}
