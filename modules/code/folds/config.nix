{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.folds;
in {
  config = mkIf (cfg.ufo.enable) {
    vim.startPlugins = [
      "promise-async"
      "nvim-ufo"
    ];

    vim.luaConfigRC.ufo-keys = nvim.dag.entryAnywhere ''
      ${nvim.lua.writeIf config.vim.keys.whichKey.enable ''
        require('mini.icons').setup()
          local mini_icons = require('mini.icons')
          local get_icon = function(category, name)
            local icon, hl = mini_icons.get(category, name)
            return icon
          end
            require("which-key").add({
          { "<leader>z", group = "Folds", icon = get_icon("lsp", "class") },

          -- Normal mode keybindings (if you want leader-based alternatives)
          { "<leader>zR", require('ufo').openAllFolds, desc = "Open All Folds", icon = get_icon("lsp", "event") },
          { "<leader>zM", require('ufo').closeAllFolds, desc = "Close All Folds", icon = get_icon("lsp", "event") },
          { "<leader>zr", require('ufo').openFoldsExceptKinds, desc = "Open Folds (except Kinds)", icon = get_icon("lsp", "event") },
          { "<leader>zm", require('ufo').closeFoldsWith, desc = "Close Folds (with)", icon = get_icon("lsp", "event") },

            })
      ''}
    '';

    vim.startLuaConfigRC.ufo-setup = ''
                      vim.o.foldcolumn = '1' -- '0' is not bad
                vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
                vim.o.foldlevelstart = 99
                vim.o.foldenable = true

                -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
                vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
                vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
                vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
                vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith)


      local capabilities = vim.lsp.protocol.make_client_capabilities()

            capabilities.textDocument.foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true
            }

            -- Display number of folded lines
            local ufo_handler = function(virtText, lnum, endLnum, width, truncate)
              local newVirtText = {}
              local suffix = ('  %d '):format(endLnum - lnum)
              local sufWidth = vim.fn.strdisplaywidth(suffix)
              local targetWidth = width - sufWidth
              local curWidth = 0
              for _, chunk in ipairs(virtText) do
                local chunkText = chunk[1]
                local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if targetWidth > curWidth + chunkWidth then
                  table.insert(newVirtText, chunk)
                else
                    chunkText = truncate(chunkText, targetWidth - curWidth)
                    local hlGroup = chunk[2]
                    table.insert(newVirtText, {chunkText, hlGroup})
                    chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    -- str width returned from truncate() may less than 2nd argument, need padding
                    if curWidth + chunkWidth < targetWidth then
                      suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                    end
                    break
                end
                curWidth = curWidth + chunkWidth
              end
              table.insert(newVirtText, {suffix, 'MoreMsg'})
              return newVirtText
            end

            require('ufo').setup({
               fold_virt_text_handler = ufo_handler
            })

    '';
  };
}
