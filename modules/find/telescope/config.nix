{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.find.telescope;
in {
  config = mkIf (cfg.enable) {
    vim.startPlugins = [
      "telescope"
      "search"
      "telescope-fzf-native"
      "dressing-nvim"
    ];

    vim.nnoremap = {
      # Buffer and file navigation
      "<leader>," = "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>";
      "<leader><space>" = "<cmd>Telescope live_grep<cr>";
      "<leader>:" = "<cmd>Telescope command_history<cr>";
      "<leader>/" = "<cmd>Telescope find_files<cr>";

      # Find commands
      "<leader>fb" = "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>";
      "<leader>ff" = "<cmd>Telescope find_files<cr>";
      "<leader>Ff" = "<cmd>Telescope find_files cwd=%:p:h<cr>";
      "<leader>fg" = "<cmd>Telescope git_files<cr>";
      "<leader>fr" = "<cmd>Telescope oldfiles<cr>";
      "<leader>Fr" = "<cmd>Telescope oldfiles cwd_only=true<cr>";

      # Git commands
      "<leader>gc" = "<cmd>Telescope git_commits<cr>";
      "<leader>gs" = "<cmd>Telescope git_status<cr>";

      # Search commands
      "<leader>s\"" = "<cmd>Telescope registers<cr>";
      "<leader>sa" = "<cmd>Telescope autocommands<cr>";
      "<leader>sb" = "<cmd>Telescope current_buffer_fuzzy_find<cr>";
      "<leader>sc" = "<cmd>Telescope command_history<cr>";
      "<leader>sC" = "<cmd>Telescope commands<cr>";
      "<leader>sd" = "<cmd>Telescope diagnostics bufnr=0<cr>";
      "<leader>sD" = "<cmd>Telescope diagnostics<cr>";
      "<leader>sg" = "<cmd>Telescope live_grep<cr>";
      "<leader>sG" = "<cmd>Telescope live_grep search_dirs={'.'}<cr>";
      "<leader>sh" = "<cmd>Telescope help_tags<cr>";
      "<leader>sH" = "<cmd>Telescope highlights<cr>";
      "<leader>sj" = "<cmd>Telescope jumplist<cr>";
      "<leader>sk" = "<cmd>Telescope keymaps<cr>";
      "<leader>sl" = "<cmd>Telescope loclist<cr>";
      "<leader>sM" = "<cmd>Telescope man_pages<cr>";
      "<leader>sm" = "<cmd>Telescope marks<cr>";
      "<leader>so" = "<cmd>Telescope vim_options<cr>";
      "<leader>sR" = "<cmd>Telescope resume<cr>";
      "<leader>sq" = "<cmd>Telescope quickfix<cr>";
      "<leader>sw" = "<cmd>Telescope grep_string<cr>";
      "<leader>sW" = "<cmd>Telescope grep_string search_dirs={'.'}<cr>";
      "<leader>uC" = "<cmd>Telescope colorscheme enable_preview=true<cr>";

      # LSP commands (if LSP is enabled)
      "gd" = "<cmd>Telescope lsp_definitions reuse_win=true<cr>";
      "gr" = "<cmd>Telescope lsp_references<cr>";
      "gI" = "<cmd>Telescope lsp_implementations reuse_win=true<cr>";
      "gy" = "<cmd>Telescope lsp_type_definitions reuse_win=true<cr>";
    };

    vim.vnoremap = {
      "<leader>sw" = "<cmd>Telescope grep_string<cr>";
      "<leader>sW" = "<cmd>Telescope grep_string search_dirs={'.'}<cr>";
    };

    vim.luaConfigRC.telescope-keys = nvim.dag.entryAnywhere ''
      ${nvim.lua.writeIf config.vim.keys.whichKey.enable ''
        require('mini.icons').setup()
          local mini_icons = require('mini.icons')
          local get_icon = function(category, name)
            local icon, hl = mini_icons.get(category, name)
            return icon
          end
            require("which-key").add({

        { "<leader>b", group = "buffer", icon = get_icon("default", "file") },
        { "<leader>l", group = "lsp", icon = get_icon("lsp", "method") },
        { "<leader>w", group = "window", icon = get_icon("default", "directory") },
        { "<leader>s", group = "search", icon = get_icon("filetype", "query") },
        { "<leader>t", group = "toggle", icon = get_icon("lsp", "boolean") },
        { "<leader>c", group = "code", icon = get_icon("lsp", "class") },
        { "<leader>d", group = "debug", icon = get_icon("filetype", "dapui_breakpoints") },
        { "<leader>n", group = "notes", icon = get_icon("filetype", "markdown") },

        -- You can also use other categories
        { "<leader>o", group = "open", icon = get_icon("directory", "nvim") },
        { "<leader>r", group = "run", icon = get_icon("extension", "exe") },
        { "<leader>p", group = "packages", icon = get_icon("filetype", "mason") },
        { "<leader>h", group = "help", icon = get_icon("filetype", "help") },

              -- Top-level leader mappings
              { "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
              { "<leader><space>", "<cmd>Telescope live_grep<cr>", desc = "Grep (Root Dir)" },
              { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
              { "<leader>/", "<cmd>Telescope find_files<cr>", desc = "Find Files (Root Dir)" },

              -- Find
        { "<leader>f", group = "Find", icon = get_icon("filetype", "telescopeprompt") },
              { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>", desc = "Buffers" },
              { "<leader>fc", desc = "Find Config File" },
              { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files (Root Dir)" },
              { "<leader>fF", "<cmd>Telescope find_files cwd=%:p:h<cr>", desc = "Find Files (cwd)" },
              { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
              { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
              { "<leader>fR", "<cmd>Telescope oldfiles cwd_only=true<cr>", desc = "Recent (cwd)" },


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
            })
      ''}
    '';
    vim.luaConfigRC.telescope = nvim.dag.entryAnywhere ''
      local telescope = require('telescope')
      local actions = require('telescope.actions')

      -- Helper functions for find command
      local function find_command()
        if vim.fn.executable("${pkgs.ripgrep}/bin/rg") == 1 then
          return { "${pkgs.ripgrep}/bin/rg", "--files", "--color", "never", "-g", "!.git" }
        elseif vim.fn.executable("${pkgs.fd}/bin/fd") == 1 then
          return { "${pkgs.fd}/bin/fd", "--type", "f", "--color", "never", "-E", ".git" }
        elseif vim.fn.executable("find") == 1 and vim.fn.has("win32") == 0 then
          return { "find", ".", "-type", "f" }
        end
      end

      -- Trouble integration functions
      local function open_with_trouble(...)
        local trouble_ok, trouble = pcall(require, "trouble.sources.telescope")
        if trouble_ok then
          return trouble.open(...)
        end
        return actions.send_to_qflist(...)
      end

      -- Dynamic file finding functions
      local function find_files_no_ignore()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        require("telescope.builtin").find_files({
          no_ignore = true,
          default_text = line
        })
      end

      local function find_files_with_hidden()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        require("telescope.builtin").find_files({
          hidden = true,
          default_text = line
        })
      end

      -- Flash integration (if available)
      local function flash(prompt_bufnr)
        local flash_ok, flash = pcall(require, "flash")
        if not flash_ok then return end

        flash.jump({
          pattern = "^",
          label = { after = { 0, 0 } },
          search = {
            mode = "search",
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
              end,
            },
          },
          action = function(match)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            picker:set_selection(match.pos[1] - 1)
          end,
        })
      end

      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          vimgrep_arguments = {
            "${pkgs.ripgrep}/bin/rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--no-ignore",
          },
          -- Open files in the first window that is an actual file
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            -- If no suitable window found, return current window
            return vim.api.nvim_get_current_win()
          end,
          mappings = {
            i = {
              ["<c-t>"] = open_with_trouble,
              ["<a-t>"] = open_with_trouble,
              ["<a-i>"] = find_files_no_ignore,
              ["<a-h>"] = find_files_with_hidden,
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-b>"] = actions.preview_scrolling_up,
              ["<c-s>"] = flash,
            },
            n = {
              ["q"] = actions.close,
              ["s"] = flash,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = find_command,
            hidden = true,
          },
        },
      })

      -- Load fzf extension if available
      pcall(telescope.load_extension, "fzf")

      -- Setup search plugin
      local search_ok, search = pcall(require, "search")
      if search_ok then
        search.setup({
          mappings = { -- optional: configure the mappings for switching tabs (will be set in normal and insert mode(!))
            next = "<Tab>",
            prev = "<S-Tab>"
          },
        })
      end

      -- LSP document symbols function
      vim.keymap.set("n", "<leader>ss", function()
        require("telescope.builtin").lsp_document_symbols({
          symbols = {
            "Class", "Function", "Method", "Constructor", "Interface",
            "Module", "Struct", "Trait", "Field", "Property"
          }
        })
      end, { desc = "Goto Symbol" })

      -- LSP workspace symbols function
      vim.keymap.set("n", "<leader>sS", function()
        require("telescope.builtin").lsp_dynamic_workspace_symbols({
          symbols = {
            "Class", "Function", "Method", "Constructor", "Interface",
            "Module", "Struct", "Trait", "Field", "Property"
          }
        })
      end, { desc = "Goto Symbol (Workspace)" })

      -- Dressing.nvim setup for better vim.ui
      local dressing_ok, dressing = pcall(require, "dressing")
      if dressing_ok then
        dressing.setup({
          input = {
            enabled = true,
            default_prompt = "Input: ",
            insert_only = true,
            start_in_insert = true,
            border = "rounded",
            relative = "cursor",
            prefer_width = 40,
            width = nil,
            max_width = { 140, 0.9 },
            min_width = { 20, 0.2 },
          },
          select = {
            enabled = true,
            backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
            trim_prompt = true,
            telescope = require("telescope.themes").get_dropdown({
              borderchars = {
                { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
                prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
                results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
                preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
              },
            }),
          },
        })
      end

      local builtin = require('telescope.builtin')

    '';
  };
}
