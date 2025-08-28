{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.git;
in {
  config = mkIf (cfg.neogit.enable) {
    vim.startPlugins = [
      "neogit"
    ];

    vim.luaConfigRC.neogit-keys = nvim.dag.entryAnywhere ''
      ${nvim.lua.writeIf config.vim.keys.whichKey.enable ''
        require('mini.icons').setup()
          local mini_icons = require('mini.icons')
          local get_icon = function(category, name)
            local icon, hl = mini_icons.get(category, name)
            return icon
          end
            require("which-key").add({
            -- Replace the empty which-key configuration in modules/code/git/neogit/config.nix
-- with these mappings inside the require("which-key").add({ }) block:

-- NeoGit main interface
{ "<leader>gg", "<cmd>Neogit<CR>", desc = "Open NeoGit", icon = get_icon("filetype", "git") },
{ "<leader>gG", "<cmd>Neogit kind=split<CR>", desc = "Open NeoGit (split)", icon = get_icon("filetype", "git") },

-- NeoGit specific operations (avoiding conflicts with existing gitsigns mappings)
{ "<leader>gn", group = "NeoGit", icon = get_icon("filetype", "git") },
{ "<leader>gnc", "<cmd>Neogit commit<CR>", desc = "Commit", icon = get_icon("filetype", "gitcommit") },
{ "<leader>gnp", "<cmd>Neogit pull<CR>", desc = "Pull", icon = get_icon("lsp", "method") },
{ "<leader>gnP", "<cmd>Neogit push<CR>", desc = "Push", icon = get_icon("lsp", "method") },
{ "<leader>gnb", "<cmd>Neogit branch<CR>", desc = "Branch", icon = get_icon("lsp", "reference") },
{ "<leader>gnl", "<cmd>Neogit log<CR>", desc = "Log", icon = get_icon("default", "file") },
{ "<leader>gnr", "<cmd>Neogit rebase<CR>", desc = "Rebase", icon = get_icon("lsp", "operator") },
{ "<leader>gnm", "<cmd>Neogit merge<CR>", desc = "Merge", icon = get_icon("lsp", "operator") },
{ "<leader>gnf", "<cmd>Neogit fetch<CR>", desc = "Fetch", icon = get_icon("lsp", "method") },
{ "<leader>gns", "<cmd>Neogit stash<CR>", desc = "Stash", icon = get_icon("lsp", "snippet") },
{ "<leader>gnw", "<cmd>Neogit worktree<CR>", desc = "Worktree", icon = get_icon("default", "directory") },
{ "<leader>gnt", "<cmd>Neogit tag<CR>", desc = "Tag", icon = get_icon("lsp", "text") },

-- Quick access to common NeoGit views
{ "<leader>gv", group = "Git Views", icon = get_icon("lsp", "interface") },
{ "<leader>gvc", "<cmd>Neogit kind=split commit<CR>", desc = "Commit view", icon = get_icon("filetype", "gitcommit") },
{ "<leader>gvl", "<cmd>Neogit kind=split log<CR>", desc = "Log view", icon = get_icon("default", "file") },
{ "<leader>gvr", "<cmd>Neogit kind=split refs<CR>", desc = "Refs view", icon = get_icon("lsp", "reference") },

-- Alternative mappings for quick access (optional)
{ "<leader>N", "<cmd>Neogit<CR>", desc = "NeoGit", icon = get_icon("filetype", "git") },
            })
      ''}
    '';

    vim.startLuaConfigRC.neogit-setup = ''
          local neogit = require("neogit")

      neogit.setup {}
    '';
  };
}
