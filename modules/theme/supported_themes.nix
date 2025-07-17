{lib}: {
  zenbones = {
    setup = {
      style ? "light",
      transparent,
    }: ''
      vim.cmd[[let g:zenbones_compat = 1]]
      vim.cmd[[set background=${style}]]
      vim.cmd[[colorscheme zenbones]]
      vim.cmd[[set cursorcolumn]]
      vim.cmd[[highlight CursorColumn guibg=lightblue ctermbg=lightgray ]]
    '';
    styles = ["dark" "light"];
  };

  papercolor = {
    setup = {
      style ? "light",
      transparent,
    }: ''
      vim.cmd[[set background=${style}]]
      vim.cmd[[colorscheme PaperColor]]
    '';
    styles = ["dark" "light"];
  };

  onedark = {
    setup = {
      style ? "dark",
      transparent,
    }: ''
      -- OneDark theme
      require('onedark').setup {
        style = "${style}"
      }
      require('onedark').load()
    '';
    styles = ["dark" "darker" "cool" "deep" "warm" "warmer"];
  };

  tokyonight = {
    setup = {
      style ? "night",
      transparent,
    }: ''
      vim.cmd[[colorscheme tokyonight-${style}]]
    '';
    styles = ["day" "night" "storm" "moon"];
  };

  dracula = {
    setup = ''
      require('dracula').setup({});
      require('dracula').load();
    '';
  };

  catppuccin = {
    setup = {
      style ? "mocha",
      transparent ? false,
    }: ''
      -- Catppuccin theme
      require('catppuccin').setup {
        flavour = "${style}",
        transparent_background = ${lib.boolToString transparent},
        integrations = {
      	  nvimtree = {
      		  enabled = true,
      		  transparent_panel = false,
      		  show_root = true,
      	  },

          hop = true,
      	  gitsigns = true,
      	  telescope = true,
      	  treesitter = true,
      	  ts_rainbow = true,
        },
      }
      -- setup must be called before loading
      vim.cmd.colorscheme "catppuccin"
    '';
    styles = ["latte" "frappe" "macchiato" "mocha"];
  };
}
