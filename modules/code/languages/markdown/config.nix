{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.languages.markdown;
in {
  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.treesitter.enable {
      vim.code.treesitter.enable = true;

      vim.code.treesitter.grammars = [cfg.treesitter.mdPackage cfg.treesitter.mdInlinePackage];
    })

    (mkIf cfg.render.enable {
      vim.startPlugins = ["render-markdown"];

      vim.nnoremap = {
        "<silent><leader>mp" = "<cmd>RenderMarkdown toggle<CR>";
        "<silent><leader>me" = "<cmd>RenderMarkdown enable<CR>";
        "<silent><leader>md" = "<cmd>RenderMarkdown disable<CR>";
      };

      vim.luaConfigRC.render-markdown = nvim.dag.entryAnywhere ''
        require('render-markdown').setup({
          file_types = { 'markdown' },
          completions = { lsp = { enabled = true } },
        })

        ${nvim.lua.writeIf config.vim.keys.whichKey.enable ''
          require("which-key").add({
            { "<leader>m",  group = "Markdown" },
            { "<leader>mp", "<cmd>RenderMarkdown toggle<CR>",  desc = "Toggle render" },
            { "<leader>me", "<cmd>RenderMarkdown enable<CR>",  desc = "Enable render" },
            { "<leader>md", "<cmd>RenderMarkdown disable<CR>", desc = "Disable render" },
          })
        ''}
      '';
    })
  ]);
}
