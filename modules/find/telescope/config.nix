{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.find.telescope;
  manixEnabled = config.vim.find.telescope.manix.enable;
in {
  config = mkIf (cfg.enable) {
    vim.startPlugins =
      [
        "telescope"
        "search"
        "telescope-fzf-native"
        "dressing-nvim"
      ]
      ++ optionals manixEnabled [
        "telescope-manix"
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
      "<leader>fF" = "<cmd>Telescope find_files cwd=%:p:h<cr>";
      "<leader>fg" = "<cmd>Telescope git_files<cr>";
      "<leader>fo" = "<cmd>Telescope oldfiles<cr>";
      "<leader>fO" = "<cmd>Telescope oldfiles cwd_only=true<cr>";

      "<leader>f\"" = "<cmd>Telescope registers<cr>";
      "<leader>fa" = "<cmd>Telescope autocommands<cr>";
      "<leader>fB" = "<cmd>Telescope current_buffer_fuzzy_find<cr>";
      "<leader>fc" = "<cmd>Telescope command_history<cr>";
      "<leader>fC" = "<cmd>Telescope commands<cr>";
      "<leader>fd" = "<cmd>Telescope diagnostics bufnr=0<cr>";
      "<leader>fD" = "<cmd>Telescope diagnostics<cr>";
      "<leader>fr" = "<cmd>Telescope live_grep<cr>";
      "<leader>fG" = "<cmd>Telescope live_grep search_dirs={'.'}<cr>";
      "<leader>fh" = "<cmd>Telescope help_tags<cr>";
      "<leader>fH" = "<cmd>Telescope highlights<cr>";
      "<leader>fj" = "<cmd>Telescope jumplist<cr>";
      "<leader>fk" = "<cmd>Telescope keymaps<cr>";
      "<leader>fl" = "<cmd>Telescope loclist<cr>";
      "<leader>fM" = "<cmd>Telescope man_pages<cr>";
      "<leader>fm" = "<cmd>Telescope marks<cr>";
      "<leader>fv" = "<cmd>Telescope vim_options<cr>";
      "<leader>fR" = "<cmd>Telescope resume<cr>";
      "<leader>fq" = "<cmd>Telescope quickfix<cr>";
      "<leader>fw" = "<cmd>Telescope grep_string<cr>";
      "<leader>fW" = "<cmd>Telescope grep_string search_dirs={'.'}<cr>";
      # UI
      "<leader>uC" = "<cmd>Telescope colorscheme enable_preview=true<cr>";

      # LSP commands (if LSP is enabled)
      "gd" = "<cmd>Telescope lsp_definitions reuse_win=true<cr>";
      "gr" = "<cmd>Telescope lsp_references<cr>";
      "gI" = "<cmd>Telescope lsp_implementations reuse_win=true<cr>";
      "gy" = "<cmd>Telescope lsp_type_definitions reuse_win=true<cr>";
    };

    vim.vnoremap = {
      "<leader>fw" = "<cmd>Telescope grep_string<cr>";
      "<leader>fW" = "<cmd>Telescope grep_string search_dirs={'.'}<cr>";
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
          -- Top-level leader mappings
          { "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer", icon = get_icon("default", "file") },
          { "<leader><space>", "<cmd>Telescope live_grep<cr>", desc = "Grep (Root Dir)", icon = get_icon("filetype", "query") },
          { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History", icon = get_icon("lsp", "method") },
          { "<leader>/", "<cmd>Telescope find_files<cr>", desc = "Find Files (Root Dir)", icon = get_icon("filetype", "telescopeprompt") },

          -- Find group
          { "<leader>f", group = "Find", icon = get_icon("filetype", "telescopeprompt") },
          { "<leader>f\"", "<cmd>Telescope registers<cr>", desc = "Registers", icon = get_icon("lsp", "string") },
          { "<leader>fB", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer (Fuzzy)", icon = get_icon("default", "file") },
          { "<leader>fC", "<cmd>Telescope commands<cr>", desc = "Commands", icon = get_icon("lsp", "method") },
          { "<leader>fD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace Diagnostics", icon = get_icon("lsp", "event") },
          { "<leader>fF", "<cmd>Telescope find_files cwd=%:p:h<cr>", desc = "Find Files (cwd)", icon = get_icon("default", "file") },
          { "<leader>fG", "<cmd>Telescope live_grep search_dirs={'.'}<cr>", desc = "Grep (cwd)", icon = get_icon("filetype", "query") },
          { "<leader>fH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups", icon = get_icon("lsp", "color") },
          { "<leader>fM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages", icon = get_icon("filetype", "man") },
          { "<leader>fO", "<cmd>Telescope oldfiles cwd_only=true<cr>", desc = "Recent (cwd)", icon = get_icon("lsp", "file") },
          { "<leader>fR", "<cmd>Telescope resume<cr>", desc = "Resume", icon = get_icon("lsp", "reference") },
          { "<leader>fS", desc = "Goto Symbol (Workspace)", icon = get_icon("lsp", "class") },
          { "<leader>fW", "<cmd>Telescope grep_string search_dirs={'.'}<cr>", desc = "Word (cwd)", icon = get_icon("lsp", "string") },
          { "<leader>fa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands", icon = get_icon("lsp", "event") },
          { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>", desc = "Buffers", icon = get_icon("default", "file") },
          { "<leader>fc", "<cmd>Telescope command_history<cr>", desc = "Command History", icon = get_icon("lsp", "method") },
          { "<leader>fd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document Diagnostics", icon = get_icon("lsp", "event") },
          { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files (Root Dir)", icon = get_icon("default", "file") },
          { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)", icon = get_icon("filetype", "git") },
          { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages", icon = get_icon("filetype", "help") },
          { "<leader>fj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist", icon = get_icon("lsp", "reference") },
          { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps", icon = get_icon("lsp", "keyword") },
          { "<leader>fl", "<cmd>Telescope loclist<cr>", desc = "Location List", icon = get_icon("lsp", "reference") },
          { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark", icon = get_icon("lsp", "reference") },
          { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Recent", icon = get_icon("lsp", "file") },
          { "<leader>fq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List", icon = get_icon("lsp", "reference") },
          { "<leader>fr", "<cmd>Telescope live_grep<cr>", desc = "Grep (Root Dir)", icon = get_icon("filetype", "query") },
          { "<leader>fs", desc = "Goto Symbol", icon = get_icon("lsp", "class") },
          { "<leader>fv", "<cmd>Telescope vim_options<cr>", desc = "Options", icon = get_icon("lsp", "property") },
          { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Word (Root Dir)", icon = get_icon("lsp", "string") },

          -- Visual mode find mappings
          { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Selection (Root Dir)", mode = "v", icon = get_icon("lsp", "string") },
          { "<leader>fW", "<cmd>Telescope grep_string search_dirs={'.'}<cr>", desc = "Selection (cwd)", mode = "v", icon = get_icon("lsp", "string") },


          -- UI group
          { "<leader>u", group = "UI", icon = get_icon("lsp", "color") },
          { "<leader>uC", "<cmd>Telescope colorscheme enable_preview=true<cr>", desc = "Colorscheme with Preview", icon = get_icon("lsp", "color") },

          -- LSP Goto mappings
          { "g", group = "Goto", icon = get_icon("lsp", "reference") },
          { "gd", "<cmd>Telescope lsp_definitions reuse_win=true<cr>", desc = "Goto Definition", icon = get_icon("lsp", "method") },
          { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References", icon = get_icon("lsp", "reference") },
          { "gI", "<cmd>Telescope lsp_implementations reuse_win=true<cr>", desc = "Goto Implementation", icon = get_icon("lsp", "interface") },
          { "gy", "<cmd>Telescope lsp_type_definitions reuse_win=true<cr>", desc = "Goto T[y]pe Definition", icon = get_icon("lsp", "class") },
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
      ${nvim.lua.writeIf manixEnabled ''
        pcall(telescope.load_extension, "manix")
      ''};

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
      vim.keymap.set("n", "<leader>fs", function()
        require("telescope.builtin").lsp_document_symbols({
          symbols = {
            "Class", "Function", "Method", "Constructor", "Interface",
            "Module", "Struct", "Trait", "Field", "Property"
          }
        })
      end, { desc = "Goto Symbol" })

      -- LSP workspace symbols function
      vim.keymap.set("n", "<leader>fS", function()
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
