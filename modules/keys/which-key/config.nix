{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.keys.whichKey;
in {
  config = mkIf (cfg.enable) {
    vim.startPlugins = ["which-key" "mini-icons" "nvim-web-devicons"];

    vim.luaConfigRC.whichkey = nvim.dag.entryAnywhere ''
      local wk = require("which-key")
      wk.setup({
  replace = {

    key_labels = {
      ["<space>"] = "SPC",
      ["<cr>"] = "RET",
      ["<tab>"] = "TAB",
    },
  },
  delay = 500,  
  })
      wk.register({

        ${
        if config.vim.keys.cheatsheet.enable
        then ''
          -- Help
          ["<leader>h"] = {
             name = "+Help",
              c = { "<cmd>Cheatsheet<cr>", "Show cheatsheet" },
          },
        ''
        else ""
      }
       
        ${
        if config.vim.tabline.nvimBufferline.enable
        then ''
          -- Buffer
          ["<leader>b"] = {
            name = "+Buffer",
             p = { "<cmd> BufferLinePick<CR>", "Pick Buffer" },
             r = { "<cmd> BufferLineTabRename<CR>", "Rename Buffer" },
             c = {
              name = "+Cycle",
              n = { "<cmd> BufferLineCycleNext<CR>", "Next Buffer" },
              p = { "<cmd> BufferLineCyclePrev<CR>", "Prev Buffer" },
             },
             x = {
              name = "+Close",
              l = { "<cmd> BufferLineCloseLeft<CR>", "Close All to the Left" },
              r = { "<cmd> BufferLineCloseRight<CR>", "Close All to the Right" },
              o = { "<cmd> BufferLineCloseOthers<CR>", "Close All Others" },
             },
            s = {
              name = "+Sort",
              e = { "<cmd> BufferLineSortByExtension<CR>", "Sort By Extension" },
              d = { "<cmd> BufferLineSortByDirectory<CR>", "Sort By Directory" },
              t = { "<cmd> BufferLineSortByTabs<CR>", "Sort By Tabs" },
            },
            m = {
              name = "+Move",
              n = { "<cmd> BufferLineMoveNext<CR>", "Move to Next" },
              p = { "<cmd> BufferLineMovePrev<CR>", "Move to Previous" },
            },
            g = {
            name = "+Goto",
                1 = { "<cmd> BufferLineGoToBuffer 1<CR>", "Move to Buffer 1" },
                2 = { "<cmd> BufferLineGoToBuffer 2<CR>", "Move to Buffer 2" },
                3 = { "<cmd> BufferLineGoToBuffer 3<CR>", "Move to Buffer 3" },
                4 = { "<cmd> BufferLineGoToBuffer 4<CR>", "Move to Buffer 4" },
                5 = { "<cmd> BufferLineGoToBuffer 5<CR>", "Move to Buffer 5" },
                6 = { "<cmd> BufferLineGoToBuffer 6<CR>", "Move to Buffer 6" },
                7 = { "<cmd> BufferLineGoToBuffer 7<CR>", "Move to Buffer 7" },
                8 = { "<cmd> BufferLineGoToBuffer 8<CR>", "Move to Buffer 8" },
                9 = { "<cmd> BufferLineGoToBuffer 9<CR>", "Move to Buffer 9" },
            },
          },

        ''
        else ""
      }

       

        ${
        if config.vim.explorer.neotree.enable
        then ''
          -- NvimTree
          ["<leader>e"] = { name = "+Explorer" },
          ["<leader>E"] = { "<cmd>Neotree<CR>", "Open Explorer" },
        
         ["<leader>eb"] = { "<cmd>Neotree source=buffers position=left<CR>", "Explore buffers" },
         ["<leader>ef"] = { "<cmd>Neotree filesystem reveal left<CR>", "Explore files" },
         ["<leader>eg"] = { "<cmd>Neotree source=git_status<CR>", "Explore git status" },
  
        ''
        else ""
      }

      })
    '';
  };
}
