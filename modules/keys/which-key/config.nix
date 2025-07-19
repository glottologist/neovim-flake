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
        if config.vim.code.ai.windsurf.enable
        then ''
                    -- AI Completion keybindings (Windsurf/Codeium - Insert Mode)
                    { "<C-a>", desc = "Accept AI Completion", mode = "i" },
                    { "<C-n>", desc = "Cycle/Complete AI Suggestions", mode = "i" },
                    { "<C-p>", desc = "Cycle AI Completions Backward", mode = "i" },
                    { "<C-c>", desc = "Clear AI Completions", mode = "i" },

                    -- AI group for reference and controls
                    { "<leader>a", group = "AI (Windsurf/Codeium)" },
                    { "<leader>ah", desc = "Show AI Help", callback = function()
                      vim.notify([[
          Windsurf/Codeium AI Keybindings (Insert Mode):
            <C-a>     - Accept AI completion
            <C-n>     - Cycle or complete AI suggestions
            <C-p>     - Cycle AI completions backward
            <C-c>     - Clear AI completions

          AI is enabled for: rust, python, bash, lua, dart, nix,
          javascript, typescript, java, c, cpp, go, php, ruby,
          html, css, json, yaml, markdown, and many more...
                      ]], vim.log.levels.INFO, { title = "Windsurf/Codeium Help" })
                    end },

                    -- Manual AI trigger functions
                    { "<leader>at", "<cmd>lua vim.fn['codeium#CycleOrComplete']()", desc = "Trigger AI Completion", mode = "i" },
                    { "<leader>ac", "<cmd>lua vim.fn['codeium#Clear']()", desc = "Clear AI Completions", mode = "i" },

                    -- Check AI status
                    { "<leader>as", desc = "Check AI Status", callback = function()
                      local status = vim.fn["codeium#GetStatusString"]()
                      if status and status ~= "" then
                        vim.notify("Codeium Status: " .. status, vim.log.levels.INFO)
                      else
                        vim.notify("Codeium is active", vim.log.levels.INFO)
                      end
                    end },
        ''
        else ""
      }


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
        if config.vim.status.tabline.nvimBufferline.enable
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



              ${
        if config.vim.find.telescope.enable && config.vim.code.treesitter.enable
        then ''
          { "<leader>fs", "<cmd> Telescope treesitter<CR>", desc = "Find in Treesitter" },
        ''
        else ""
      }


              ${
        if config.vim.find.telescope.enable
        then ''
          -- Top-level leader mappings
          { "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
          { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep (Root Dir)" },
          { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
          { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files (Root Dir)" },

          -- Find
          { "<leader>f", group = "Find" },
          { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>", desc = "Buffers" },
          { "<leader>fc", desc = "Find Config File" },
          { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files (Root Dir)" },
          { "<leader>fF", "<cmd>Telescope find_files cwd=%:p:h<cr>", desc = "Find Files (cwd)" },
          { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
          { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
          { "<leader>fR", "<cmd>Telescope oldfiles cwd_only=true<cr>", desc = "Recent (cwd)" },

          -- Git
          { "<leader>g", group = "Git" },
          { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
          { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },

          -- Search
          { "<leader>s", group = "Search" },
          { "<leader>s\"", "<cmd>Telescope registers<cr>", desc = "Registers" },
          { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
          { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
          { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
          { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
          { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics" },
          { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics" },
          { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep (Root Dir)" },
          { "<leader>sG", "<cmd>Telescope live_grep search_dirs={'.'}<cr>", desc = "Grep (cwd)" },
          { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
          { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
          { "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
          { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
          { "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
          { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
          { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
          { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
          { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
          { "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
          { "<leader>ss", desc = "Goto Symbol" },
          { "<leader>sS", desc = "Goto Symbol (Workspace)" },
          { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Word (Root Dir)" },
          { "<leader>sW", "<cmd>Telescope grep_string search_dirs={'.'}<cr>", desc = "Word (cwd)" },
          { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Selection (Root Dir)", mode = "v" },
          { "<leader>sW", "<cmd>Telescope grep_string search_dirs={'.'}<cr>", desc = "Selection (cwd)", mode = "v" },

          -- UI
          { "<leader>u", group = "UI" },
          { "<leader>uC", "<cmd>Telescope colorscheme enable_preview=true<cr>", desc = "Colorscheme with Preview" },

          -- LSP Goto mappings
          { "g", group = "Goto" },
          { "gd", "<cmd>Telescope lsp_definitions reuse_win=true<cr>", desc = "Goto Definition" },
          { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
          { "gI", "<cmd>Telescope lsp_implementations reuse_win=true<cr>", desc = "Goto Implementation" },
          { "gy", "<cmd>Telescope lsp_type_definitions reuse_win=true<cr>", desc = "Goto T[y]pe Definition" },

        ''
        else ""
      }



            ${
        if config.vim.code.completion.nvimCmp.enable
        then ''
                    -- Completion (nvim-cmp)
                    { "<leader>c", group = "Completion" },
                    { "<leader>ch", desc = "Completion Help", callback = function()
                      vim.notify([[
          Completion Keybindings (Insert Mode):
            <C-Space> - Trigger completion
            <C-d>     - Scroll docs up
            <C-f>     - Scroll docs down
            <C-e>     - Close completion
            <CR>      - Confirm selection
            <Tab>     - Next item / Expand snippet
            <S-Tab>   - Previous item / Jump back in snippet
                      ]], vim.log.levels.INFO, { title = "nvim-cmp Help" })
                    end },

                    -- These work in normal mode for completion-related actions
                    { "<leader>cc", "<cmd>lua require('cmp').complete()<cr>", desc = "Trigger Completion", mode = "i" },
                    { "<leader>ca", "<cmd>lua require('cmp').abort()<cr>", desc = "Abort Completion", mode = "i" },
        ''
        else ""
      }

            ${
        if config.vim.code.completion.blinkCmp.enable
        then ''
                    -- Completion keybindings (blink.cmp - Insert Mode)
                    { "<C-Space>", desc = "Show/Hide Completion & Docs", mode = "i" },
                    { "<C-y>", desc = "Select and Accept", mode = "i" },
                    { "<C-d>", desc = "Scroll Docs Up", mode = "i" },
                    { "<C-f>", desc = "Scroll Docs Down", mode = "i" },
                    { "<C-e>", desc = "Hide Completion", mode = "i" },
                    { "<CR>", desc = "Accept Completion", mode = "i" },
                    { "<Tab>", desc = "Next Item / Snippet Forward", mode = "i" },
                    { "<S-Tab>", desc = "Previous Item / Snippet Backward", mode = "i" },

                    -- Completion group for reference
                    { "<leader>c", group = "Completion (blink.cmp)" },
                    { "<leader>ch", desc = "Show Completion Help", callback = function()
                      vim.notify([[
          blink.cmp Keybindings (Insert Mode):
            <C-Space> - Show/Hide completion & docs
            <C-y>     - Select and accept
            <C-d>     - Scroll documentation up
            <C-f>     - Scroll documentation down
            <C-e>     - Hide completion
            <CR>      - Accept completion
            <Tab>     - Next item / Snippet forward
            <S-Tab>   - Previous item / Snippet backward
                      ]], vim.log.levels.INFO, { title = "blink.cmp Help" })
                    end },

                    -- Toggle functions for normal mode
                    { "<leader>ct", "<cmd>lua require('blink.cmp').show()<cr>", desc = "Trigger Completion", mode = "i" },
                    { "<leader>ca", "<cmd>lua require('blink.cmp').hide()<cr>", desc = "Hide Completion", mode = "i" },
        ''
        else ""
      }

            })
    '';
  };
}
