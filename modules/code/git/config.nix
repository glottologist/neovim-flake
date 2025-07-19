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
