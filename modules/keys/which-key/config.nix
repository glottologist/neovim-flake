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
          ["<space>"] = "SPC",
          ["<cr>"] = "RET",
          ["<tab>"] = "TAB",
        },
        delay = 500,
      })
      
      -- Use the new wk.add() format instead of wk.register()
      wk.add({
        ${
        if config.vim.keys.cheatsheet.enable
        then ''
          -- Help
          { "<leader>h", group = "Help" },
          { "<leader>hc", "<cmd>Cheatsheet<cr>", desc = "Show cheatsheet" },
        ''
        else ""
      }
       
        ${
        if config.vim.tabline.nvimBufferline.enable
        then ''
          -- Buffer
          { "<leader>b", group = "Buffer" },
          { "<leader>bp", "<cmd> BufferLinePick<CR>", desc = "Pick Buffer" },
          { "<leader>br", "<cmd> BufferLineTabRename<CR>", desc = "Rename Buffer" },
          
          -- Cycle
          { "<leader>bc", group = "Cycle" },
          { "<leader>bcn", "<cmd> BufferLineCycleNext<CR>", desc = "Next Buffer" },
          { "<leader>bcp", "<cmd> BufferLineCyclePrev<CR>", desc = "Prev Buffer" },
          
          -- Close
          { "<leader>bx", group = "Close" },
          { "<leader>bxl", "<cmd> BufferLineCloseLeft<CR>", desc = "Close All to the Left" },
          { "<leader>bxr", "<cmd> BufferLineCloseRight<CR>", desc = "Close All to the Right" },
          { "<leader>bxo", "<cmd> BufferLineCloseOthers<CR>", desc = "Close All Others" },
          
          -- Sort
          { "<leader>bs", group = "Sort" },
          { "<leader>bse", "<cmd> BufferLineSortByExtension<CR>", desc = "Sort By Extension" },
          { "<leader>bsd", "<cmd> BufferLineSortByDirectory<CR>", desc = "Sort By Directory" },
          { "<leader>bst", "<cmd> BufferLineSortByTabs<CR>", desc = "Sort By Tabs" },
          
          -- Move
          { "<leader>bm", group = "Move" },
          { "<leader>bmn", "<cmd> BufferLineMoveNext<CR>", desc = "Move to Next" },
          { "<leader>bmp", "<cmd> BufferLineMovePrev<CR>", desc = "Move to Previous" },
          
          -- Goto
          { "<leader>bg", group = "Goto" },
          { "<leader>bg1", "<cmd> BufferLineGoToBuffer 1<CR>", desc = "Move to Buffer 1" },
          { "<leader>bg2", "<cmd> BufferLineGoToBuffer 2<CR>", desc = "Move to Buffer 2" },
          { "<leader>bg3", "<cmd> BufferLineGoToBuffer 3<CR>", desc = "Move to Buffer 3" },
          { "<leader>bg4", "<cmd> BufferLineGoToBuffer 4<CR>", desc = "Move to Buffer 4" },
          { "<leader>bg5", "<cmd> BufferLineGoToBuffer 5<CR>", desc = "Move to Buffer 5" },
          { "<leader>bg6", "<cmd> BufferLineGoToBuffer 6<CR>", desc = "Move to Buffer 6" },
          { "<leader>bg7", "<cmd> BufferLineGoToBuffer 7<CR>", desc = "Move to Buffer 7" },
          { "<leader>bg8", "<cmd> BufferLineGoToBuffer 8<CR>", desc = "Move to Buffer 8" },
          { "<leader>bg9", "<cmd> BufferLineGoToBuffer 9<CR>", desc = "Move to Buffer 9" },
        ''
        else ""
      }

        ${
        if config.vim.explorer.neotree.enable
        then ''
          -- Explorer
          { "<leader>e", group = "Explorer" },
          { "<leader>E", "<cmd>Neotree<CR>", desc = "Open Explorer" },
          { "<leader>eb", "<cmd>Neotree source=buffers position=left<CR>", desc = "Explore buffers" },
          { "<leader>ef", "<cmd>Neotree filesystem reveal left<CR>", desc = "Explore files" },
          { "<leader>eg", "<cmd>Neotree source=git_status<CR>", desc = "Explore git status" },
        ''
        else ""
      }

      })
    '';
  };
}