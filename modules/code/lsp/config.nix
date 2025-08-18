{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.lsp;
  usingCmp = config.vim.code.completion.nvimCmp.enable || config.vim.code.completion.blinkCmp.enable;
in {
  config = mkIf cfg.enable {
    vim.startPlugins = optional usingCmp "cmp-nvim-lsp";

    vim.completion.sources = {"nvim_lsp" = "[LSP]";};

    vim.luaConfigRC.lsp-keys = nvim.dag.entryAnywhere ''
      ${nvim.lua.writeIf config.vim.keys.whichKey.enable ''
        require('mini.icons').setup()
        local mini_icons = require('mini.icons')
        local get_icon = function(category, name)
          local icon, hl = mini_icons.get(category, name)
          return icon
        end

        require("which-key").add({
          -- Main LSP group
          { "<leader>l", group = "LSP", icon = get_icon("lsp", "interface") },

          -- LSP go-to operations
          { "<leader>lg", group = "Go to", icon = get_icon("lsp", "reference") },
          { "<leader>lgr", desc = "Go to references", icon = get_icon("lsp", "reference") },
          { "<leader>lgc", desc = "Go to declaration", icon = get_icon("lsp", "reference") },
          { "<leader>lgd", desc = "Go to definition", icon = get_icon("lsp", "reference") },
          { "<leader>lgi", desc = "Go to implementation", icon = get_icon("lsp", "reference") },
          { "<leader>lgt", desc = "Go to type definition", icon = get_icon("lsp", "type") },

          -- LSP diagnostics
          { "<leader>ld", group = "Diagnostics", icon = get_icon("lsp", "error") },
          { "<leader>ldn", desc = "Next diagnostic", icon = get_icon("lsp", "error") },
          { "<leader>ldp", desc = "Previous diagnostic", icon = get_icon("lsp", "error") },

          -- LSP workspace operations
          { "<leader>lw", group = "Workspace", icon = get_icon("default", "directory") },
          { "<leader>lwa", desc = "Add workspace folder", icon = get_icon("lsp", "operator") },
          { "<leader>lwr", desc = "Remove workspace folder", icon = get_icon("lsp", "operator") },
          { "<leader>lwl", desc = "List workspace folders", icon = get_icon("lsp", "array") },

          -- LSP information and actions
          { "<leader>lh", desc = "Hover information", icon = get_icon("lsp", "keyword") },
          { "<leader>ls", desc = "Signature help", icon = get_icon("lsp", "function") },
          { "<leader>lr", desc = "Rename symbol", icon = get_icon("lsp", "text") },
        })
      ''}
    '';

    vim.luaConfigRC.lsp-setup = ''

         vim.g.formatsave = ${boolToString cfg.formatOnSave};

            local attach_keymaps = function(client, bufnr)
              local opts = { noremap=true, silent=true }

              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgc', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ldn', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ldp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)

              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lwl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)

              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ls', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
              vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
            end

      -- Enable formatting
            format_callback = function(client, bufnr)
              vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                  if vim.g.formatsave then
                    if client.supports_method("textDocument/formatting") then
                      local params = require'vim.lsp.util'.make_formatting_params({})
                      client.request('textDocument/formatting', params, nil, bufnr)

                    end
                  end
                end
              })
            end

            default_on_attach = function(client, bufnr)
              attach_keymaps(client, bufnr)
              format_callback(client, bufnr)
            end

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            ${optionalString usingCmp "capabilities = require('cmp_nvim_lsp').default_capabilities()"}
    '';
  };
}
