{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.git;
in {
  config = mkIf cfg.enable (mkMerge [
    (mkIf config.vim.find.telescope.enable (mkMerge [
      {
        vim.luaConfigRC.git-keys = nvim.dag.entryAnywhere ''
          ${nvim.lua.writeIf config.vim.keys.whichKey.enable ''
                       require('mini.icons').setup()
                         local mini_icons = require('mini.icons')
                         local get_icon = function(category, name)
                           local icon, hl = mini_icons.get(category, name)
                           return icon
                         end
                           require("which-key").add({
            -- Main Git group
                         { "<leader>g", group = "Git", icon = get_icon("filetype", "git") },

                         -- Git commands
                         { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits", icon = get_icon("filetype", "gitcommit") },
                         { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status", icon = get_icon("filetype", "git") },
                         { "<leader>gl", desc = "Blame line", icon = get_icon("filetype", "git") },

                         -- Git hunk operations
                         { "<leader>gh", group = "Hunk", icon = get_icon("filetype", "diff") },
                         { "<leader>ghn", desc = "Next hunk", icon = get_icon("lsp", "reference") },
                         { "<leader>ghp", desc = "Previous hunk", icon = get_icon("lsp", "reference") },
                         { "<leader>ghs", desc = "Stage hunk", icon = get_icon("lsp", "snippet") },
                         { "<leader>ghu", desc = "Undo stage hunk", icon = get_icon("lsp", "reference") },
                         { "<leader>ghr", desc = "Reset hunk", icon = get_icon("lsp", "reference") },
                         { "<leader>ghv", desc = "Preview hunk", icon = get_icon("filetype", "git") },

                         -- Git buffer operations
                         { "<leader>gb", group = "Buffer", icon = get_icon("default", "file") },
                         { "<leader>gbr", desc = "Reset buffer", icon = get_icon("lsp", "reference") },
                         { "<leader>gbs", desc = "Stage buffer", icon = get_icon("lsp", "snippet") },
                         { "<leader>gbi", desc = "Reset buffer index", icon = get_icon("lsp", "reference") },

                         -- Git toggles
                         { "<leader>gt", group = "Toggle", icon = get_icon("lsp", "boolean") },
                         { "<leader>gts", desc = "Toggle signs", icon = get_icon("lsp", "boolean") },
                         { "<leader>gtn", desc = "Toggle number highlight", icon = get_icon("lsp", "boolean") },
                         { "<leader>gtl", desc = "Toggle line highlight", icon = get_icon("lsp", "boolean") },
                         { "<leader>gtw", desc = "Toggle word diff", icon = get_icon("lsp", "boolean") },

                         -- Visual mode mappings
                         { "<leader>ghs", mode = "v", desc = "Stage hunk", icon = get_icon("lsp", "snippet") },
                         { "<leader>ghr", mode = "v", desc = "Reset hunk", icon = get_icon("lsp", "reference") },

                         -- Text objects
                         { "ih", mode = { "o", "x" }, desc = "Git hunk", icon = get_icon("filetype", "diff") },



                           })

          ''};
        '';
      }
    ]))

    (mkIf cfg.gitworktrees.enable (mkMerge [
      {
        vim.startPlugins = ["git-worktrees"];
        vim.luaConfigRC.gitworktree = nvim.dag.entryAnywhere ''
          require('git-worktree').setup {}
        '';
      }
    ]))
    (mkIf cfg.gitsigns.enable (mkMerge [
      {
        vim.startPlugins = ["gitsigns-nvim"];
        vim.luaConfigRC.gitsigns = nvim.dag.entryAnywhere ''
              require('gitsigns').setup {
                on_attach = function(bufnr)
                  local gs = package.loaded.gitsigns

                  local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    opts.noremap = true
                    vim.keymap.set(mode, l, r, opts)
                  end

                  -- Navigation
                  map('n', '<leader>ghn', function()
                    if vim.wo.diff then return nil end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                  end, {expr=true})

                  map('n', '<leader>ghp', function()
                    if vim.wo.diff then return nil end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                  end, {expr=true})

                  -- Actions
                  map('n', '<leader>gc', '<cmd>Telescope git_commits<cr>')
                  map('n', '<leader>gs', '<cmd>Telescope git_status<cr>')
                  map('n', '<leader>ghs', gs.stage_hunk)
                  map('v', '<leader>ghs', function()
                    gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')}
                  end)
                  map('n', '<leader>ghu', gs.undo_stage_hunk)
                  map('n', '<leader>ghr', gs.reset_hunk)
                  map('v', '<leader>ghr', function()
                    gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')}
                  end)
                  map('n', '<leader>gbr', gs.reset_buffer)
                  map('n', '<leader>ghv', gs.preview_hunk)
                  map('n', '<leader>gl', function() gs.blame_line{full=true} end)
                  map('n', '<leader>gbs', gs.stage_buffer)
                  map('n', '<leader>gbi', gs.reset_buffer_index)

                  -- Toggles
                  map('n', '<leader>gts', gs.toggle_signs)
                  map('n', '<leader>gtn', gs.toggle_numhl)
                  map('n', '<leader>gtl', gs.toggle_linehl)
                  map('n', '<leader>gtw', gs.toggle_word_diff)

                  -- Text object
                  map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
                end,
              }
        '';
      }
      (mkIf cfg.gitsigns.codeActions {
        vim.code.lsp.null-ls.enable = true;
        vim.code.lsp.null-ls.sources.gitsigns-ca = ''
          table.insert(
            ls_sources,
            null_ls.builtins.code_actions.gitsigns
          )
        '';
      })
    ]))
  ]);
}
