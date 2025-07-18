{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.completion.blinkCmp;
  lspkindEnabled = config.vim.code.lsp.enable && config.vim.code.lsp.lspkind.enable;
  builtSources =
    concatMapStringsSep
    ", "
    (n: "'${n}'")
    (attrNames cfg.sources);
  builtMaps =
    concatStringsSep
    "\n"
    (mapAttrsToList
      (n: v:
        if v == null
        then ""
        else "${n} = '${v}',")
      cfg.sources);
  dagPlacement =
    if lspkindEnabled
    then nvim.dag.entryAfter ["lspkind"]
    else nvim.dag.entryAnywhere;
in {
  config = mkIf cfg.enable {
    vim.startPlugins = [
      "blink-cmp"
      "blink-compat"
      "friendly-snippets"
    ];
    
    vim.autocomplete.sources = {
      "lsp" = "[LSP]";
      "path" = "[Path]";
      "snippets" = "[Snippets]";
      "buffer" = "[Buffer]";
      "treesitter" = "[Treesitter]";
      "lazydev" = "[LazyDev]";
      "blink-cmp" = null;
    };

    vim.luaConfigRC.completion = mkIf cfg.enable (dagPlacement ''
      local blink_cmp_menu_map = function(entry, vim_item)
        -- name for each source
        vim_item.menu = ({
          ${builtMaps}
        })[entry.source.name]
        return vim_item
      end

      ${optionalString lspkindEnabled ''
        local kind_icons = lspkind.presets.default
      ''}

      -- Setup blink.cmp
      require('blink.cmp').setup({
        snippets = {
          expand = function(snippet, _)
            ${cfg.snippets.expand or "vim.snippet.expand(snippet)"}
          end,
        },
        
        appearance = {
          use_nvim_cmp_as_default = false,
          nerd_font_variant = "${cfg.appearance.nerd_font_variant or "mono"}",
          ${optionalString lspkindEnabled ''
            kind_icons = kind_icons,
          ''}
        },
        
        completion = {
          accept = {
            auto_brackets = {
              enabled = ${boolToString (cfg.completion.auto_brackets or true)},
            },
          },
          menu = {
            draw = {
              treesitter = { "lsp" },
            },
          },
          documentation = {
            auto_show = ${boolToString (cfg.completion.documentation.auto_show or true)},
            auto_show_delay_ms = ${toString (cfg.completion.documentation.auto_show_delay_ms or 200)},
          },
          ghost_text = {
            enabled = ${boolToString (cfg.completion.ghost_text.enabled or false)},
          },
        },

        sources = {
          compat = {},
          default = { ${builtSources} },
          providers = {
            ${optionalString (hasAttr "lazydev" cfg.sources) ''
              lazydev = {
                name = "LazyDev",
                module = "lazydev.integrations.blink",
                score_offset = 100,
              },
            ''}
          },
        },

        cmdline = {
          enabled = ${boolToString (cfg.cmdline.enabled or false)},
        },

        keymap = {
          preset = "${cfg.keymap.preset or "enter"}",
          ['<C-y>'] = { "select_and_accept" },
          ['<C-d>'] = { "scroll_documentation_up" },
          ['<C-f>'] = { "scroll_documentation_down" },
          ['<C-Space>'] = { "show", "show_documentation", "hide_documentation" },
          ['<C-e>'] = { "hide" },
          ['<CR>'] = { "accept", "fallback" },
          ['<Tab>'] = { 
            "snippet_forward", 
            "select_next", 
            "show", 
            "fallback" 
          },
          ['<S-Tab>'] = { 
            "snippet_backward", 
            "select_prev", 
            "fallback" 
          },
        },
      })

      -- Setup compat sources if any nvim-cmp sources are configured
      ${optionalString (cfg.compat_sources != []) ''
        local blink_opts = require('blink.cmp').config
        local enabled = blink_opts.sources.default
        local compat_sources = { ${concatMapStringsSep ", " (s: "'${s}'") cfg.compat_sources} }
        
        for _, source in ipairs(compat_sources) do
          blink_opts.sources.providers[source] = vim.tbl_deep_extend(
            "force",
            { name = source, module = "blink.compat.source" },
            blink_opts.sources.providers[source] or {}
          )
          if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
            table.insert(enabled, source)
          end
        end
      ''}

    '');

    # Enable friendly-snippets and configure snippet support
    vim.snippets = {
      enable = if (cfg.type == "blink-cmp") then true else config.vim.snippets.enable;
      sources = ["friendly-snippets"];
    };
  };
}
