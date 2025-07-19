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

    vim.luaConfigRC.lsp-setup = ''
      vim.g.formatsave = ${boolToString cfg.formatOnSave};

      local attach_keymaps = function(client, bufnr)
        local opts = { noremap=true, silent=true }

        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgc', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>lgd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
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
        if not vim.g.formatsave then
          return
        end
        
        local augroup = vim.api.nvim_create_augroup("LspFormatting_" .. bufnr, { clear = true })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ 
              async = false,
              bufnr = bufnr,
              filter = function(c)
                return c.id == client.id
              end
            })
          end
        })
      end

      default_on_attach = function(client, bufnr)
        attach_keymaps(client, bufnr)
        -- Temporarily disable format callback to debug buffer clearing issue
        -- format_callback(client, bufnr)
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      ${optionalString usingCmp "capabilities = require('cmp_nvim_lsp').default_capabilities()"}
    '';
  };
}
