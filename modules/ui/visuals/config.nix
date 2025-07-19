{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.vim.ui.visuals;
in {
  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.indentBlankline.enable {
      vim.startPlugins = ["indent-blankline"];
      vim.luaConfigRC.indent-blankline = nvim.dag.entryAnywhere ''
        -- highlight error: https://github.com/lukas-reineke/indent-blankline.nvim/issues/59
        vim.wo.colorcolumn = "99999"
        vim.opt.list = true

        ${optionalString (cfg.indentBlankline.eolChar != null) ''
          vim.opt.listchars:append({ eol = "${cfg.indentBlankline.eolChar}" })
        ''}
        ${optionalString (cfg.indentBlankline.fillChar != null) ''
          vim.opt.listchars:append({ space = "${cfg.indentBlankline.fillChar}" })
        ''}

        require("indent_blankline").setup {
          enabled = true,
          char = "${cfg.indentBlankline.listChar}",
          show_current_context = ${boolToString cfg.indentBlankline.showCurrContext},
          show_end_of_line = ${boolToString cfg.indentBlankline.showEndOfLine},
          use_treesitter = ${boolToString cfg.indentBlankline.useTreesitter},
        }
      '';
    })

    (mkIf cfg.fidget.enable {
      vim.startPlugins = ["fidget-nvim"];
      vim.luaConfigRC.fidget-nvim = nvim.dag.entryAnywhere ''
        require"fidget".setup{
          align = {
            bottom = ${boolToString cfg.fidget-nvim.align.bottom},
            right = ${boolToString cfg.fidget-nvim.align.right},
          }
        }
      '';
    })
  ]);
}
