{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.vim.status.statusline.lualine;
  blinkEnabled = config.vim.code.completion.blinkCmp.enable or false;
  nvimEnabled = config.vim.code.completion.nvimCmp.enable or false;
  noCmpEnabled = !blinkEnabled && !nvimEnabled;
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
                lualine_c = {
                  'filename',
                  {
                    function()
                      require('codeium.virtual_text').set_statusbar_refresh(function()
                        require('lualine').refresh()
                      end)
                      -- Windsurf virtual text status
                      local status_ok, status = pcall(function()
                        return require('codeium.virtual_text').status()
                      end)

                      if not status_ok then
                        return "🤖 NO AI"
                      end

                      if status.state == 'idle' then
                        -- Output was cleared, for example when leaving insert mode
                        return "🤖 IDLE "
                      end

                      if status.state == 'waiting' then
                        -- Waiting for response
                        return "🤖 Waiting..."
                      end

                      if status.state == 'completions' and status.total > 0 then
                        return string.format('🤖 %d/%d', status.current, status.total)
                      end

                      return ""
                    end,
                    color = { fg = '#ff6c6b' }
                  },
                  {
                    function()
        ${optionalString blinkEnabled ''
                      local blink_ok, blink_cmp = pcall(require, 'blink.cmp')
                      if not blink_ok then
                        return "NO CMP"
                      end
                      if not blink_cmp.is_visible() then
                        return "CMP NOT VISIBLE"
                      end
                      if blink_ok and blink_cmp.is_visible() then
                        local selected = blink_cmp.get_selected_item()
                        local items = blink_cmp.get_completion_items() or {}
                        if #items == 0 then
                          return "󰘦 CMP 0"
                        end
                        if selected and #items > 0 then
                          for i, item in ipairs(items) do
                            if item == selected then
                              return string.format("󰘦 CMP %d/%d", i, #items)
                            end
                          end
                        end

                        return string.format("󰘦 CMP %d", #items)
                      end
                      return "NO CMP"
        ''}

        ${optionalString nvimEnabled ''
                      local cmp_ok, cmp = pcall(require, 'cmp')
                      if not cmp_ok then
                        return "NO CMP"
                      end
                      if not cmp.visible() then
                        return "CMP NOT VISIBLE"
                      end
                      if cmp_ok and cmp.visible() then
                        local selected = cmp.get_selected_entry()
                        local entries = cmp.get_entries()

                        if selected and entries and #entries > 0 then
                          for i, entry in ipairs(entries) do
                            if entry == selected then
                              return string.format("󰘦 CMP %d/%d", i, #entries)
                            end
                          end
                        end

                        return "󰘦 CMP"
                      end
                      return "NO CMP"
        ''}
        ${optionalString noCmpEnabled ''
                      return "No CMP enabled"
        ''}
                    end,
                    color = { fg = '#98be65' }
                  }
                },
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
