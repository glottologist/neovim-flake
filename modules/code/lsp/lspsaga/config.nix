{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.lsp;
in {
  config = mkIf (cfg.enable && cfg.lspsaga.enable) {
    vim.startPlugins = ["lspsaga"];

    vim.vnoremap = {
      "<silent><leader>ca" = ":<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>";
    };

    vim.nnoremap =
      {
        "<silent><leader>lf" = "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>";
        "<silent><leader>lh" = "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>";
        "<silent><leader>lr" = "<cmd>lua require'lspsaga.rename'.rename()<CR>";
        "<silent><leader>lpd" = "<cmd>lua require'lspsaga.provider'.preview_definition()<CR>";
        "<silent><leader>ldl" = "<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>";
        "<silent><leader>ldc" = "<cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>";
        "<silent><leader>ldp" = "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>";
        "<silent><leader>ldn" = "<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>";
        "<silent><C-f>" = "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>";
        "<silent><C-b>" = "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>";
      }
      # // (
      #   if (!cfg.nvimCodeActionMenu.enable)
      #   then {
      #     "<silent><leader>la" = "<cmd>lua require('lspsaga.codeaction').code_action()<CR>";
      #   }
      #   else {}
      # )
      // (
        if (!cfg.lspSignature.enable)
        then {
          "<silent><leader>ls" = "<cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>";
        }
        else {}
      );

    vim.luaConfigRC.lspsage = nvim.dag.entryAnywhere ''
      -- Enable lspsaga
      local saga = require 'lspsaga'
      saga.init_lsp_saga({})
    '';
  };
}
