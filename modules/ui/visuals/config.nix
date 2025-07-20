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

        require("ibl").setup {
            indent = { highlight = highlight, char = "" },
            whitespace = {
                highlight = highlight,
                remove_blankline_trail = false,
            },
            scope = { enabled = false },
        }
      '';
    })

    (mkIf cfg.fidget.enable {
      vim.startPlugins = ["fidget-nvim"];
      vim.luaConfigRC.fidget-nvim = nvim.dag.entryAnywhere ''
        require"fidget".setup{
          align = {
            bottom = ${boolToString cfg.fidget.align.bottom},
            right = ${boolToString cfg.fidget.align.right},
          }
        }
      '';
    })
    (mkIf cfg.twilight.enable {
      vim.startPlugins = ["twilight"];
      vim.nnoremap = {
        "<leader>ut" = "<cmd> Twilight<CR>";
      };
      vim.luaConfigRC.twilight = nvim.dag.entryAnywhere ''
              require"twilight".setup{
               dimming = {
                  alpha = 0.25, -- amount of dimming
          color = { "Normal", "#ffffff" },
          term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
          inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
        },
        context = 10, -- amount of lines we will try to show around the current line
        treesitter = true, -- use treesitter when available for the filetype
        expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
          "function",
          "method",
          "table",
          "if_statement",
        },
        exclude = {}, -- exclude these filetypes
              }
      '';
    })
    (mkIf cfg.zenmode.enable {
      vim.startPlugins = ["zenmode"];
      vim.nnoremap = {
        "<leader>uz" = "<cmd> ZenMode<CR>";
      };
      vim.luaConfigRC.zenmode = nvim.dag.entryAnywhere ''
        require"zen-mode".setup{
        }
      '';
    })
  ]);
}
