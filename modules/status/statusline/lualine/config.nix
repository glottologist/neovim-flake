{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.vim.status.statusline.lualine;
in {
  config = (mkIf cfg.enable) {
    vim.startPlugins = [
      "lualine"
    ];

    vim.luaConfigRC.lualine = nvim.dag.entryAnywhere ''
    require('lualine').setup {
    tabline = {},
    sections = {
  lualine_a = {'mode'},
  lualine_b = {'branch', 'diff', 'diagnostics'},
  lualine_c = {'filename'},
  lualine_x = {'encoding', 'fileformat', 'filetype'},
  lualine_y = {'progress'},
  lualine_z = {'location'}
},
inactive_sections = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = {'filename'},
  lualine_x = {'location'},
  lualine_y = {},
  lualine_z = {}
},
  options = {
icons_enabled = ${boolToString cfg.icons.enable},
      theme = "${cfg.theme}",
      component_separators = {"${cfg.componentSeparator.left}","${cfg.componentSeparator.right}"},
      section_separators = {"${cfg.sectionSeparator.left}","${cfg.sectionSeparator.right}"},
      disabled_filetypes = { 'alpha' },
      always_divide_middle = true,
      globalstatus = ${boolToString cfg.globalStatus},
      ignore_focus = {'NvimTree'},
      extensions = {${
        if config.vim.explorer.neotree.enable
        then "\"neo-tree\""
        else if config.vim.explorer.nvimtree.enable
        then "\"nvim-tree\""
        else ""
      }},
      refresh = {
        statusline = ${toString cfg.refresh.statusline},
        tabline = ${toString cfg.refresh.tabline},
        winbar = ${toString cfg.refresh.winbar},
      },
  }
}
    '';
  };
}
