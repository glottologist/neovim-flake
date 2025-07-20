{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.completion.blinkCmp;
  lspkindEnabled = config.vim.code.lsp.enable && config.vim.code.lsp.lspkind.enable;
  windsurfEnabled = config.vim.code.ai.windsurf.enable or false;

  # Only include sources that are actually enabled
  actualSources =
    filterAttrs (
      n: v:
        !(n == "codeium" && !windsurfEnabled)
    )
    cfg.sources;

  builtSources =
    concatMapStringsSep
    ", "
    (n: "'${n}'")
    (attrNames actualSources);
  builtMaps =
    concatStringsSep
    "\n"
    (mapAttrsToList
      (n: v:
        if v == null
        then ""
        else "${n} = '${v}',")
      actualSources);
  dagPlacement =
    if lspkindEnabled
    then lib.nvim.dag.entryAfter ["lspkind"]
    else lib.nvim.dag.entryAnywhere;
in {
  config = mkIf cfg.enable {
    vim.startPlugins =
      [
        "blink-cmp"
        "blink-compat"
        "friendly-snippets"
      ]
      ++ optionals windsurfEnabled [
        "windsurf-nvim"
        "plenary-nvim"
      ];

    vim.code.completion.sources =
      {
        "lsp" = "[LSP]";
        "path" = "[Path]";
        "snippets" = "[Snippets]";
        "buffer" = "[Buffer]";
        "treesitter" = "[Treesitter]";
        "blink-cmp" = null;
      }
      // optionalAttrs windsurfEnabled {
        "codeium" = "[Codeium]";
      };

    # Setup Windsurf/Codeium BEFORE blink.cmp
    vim.luaConfigRC.windsurf-setup = mkIf windsurfEnabled (lib.nvim.dag.entryBefore ["completion"] ''
      -- Check if codeium module is available
      local codeium_ok, codeium = pcall(require, 'codeium')
      if codeium_ok then
        codeium.setup({
          enable_cmp_source = true,
          virtual_text = { enabled = false },
          detect_proxy = true,
          enable_chat = true,
          workspace_root = {
            use_lsp = true,
            paths = { ".git", ".hg", ".svn", "package.json", "Cargo.toml", "go.mod" }
          }
        })
      elseif vim.fn.exists(':Codeium') == 2 then
        -- Vim version available, will register with blink.cmp automatically
        print("Codeium vim commands available - run :Codeium Auth to authenticate")
      end
    '');

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
            ${
        if cfg ? snippets && cfg.snippets ? expand
        then cfg.snippets.expand
        else "vim.snippet.expand(snippet)"
      }
          end,
        },

        appearance = {
          use_nvim_cmp_as_default = false,
          nerd_font_variant = "${
        if cfg ? appearance && cfg.appearance ? nerd_font_variant
        then cfg.appearance.nerd_font_variant
        else "mono"
      }",
          ${optionalString lspkindEnabled ''
        kind_icons = kind_icons,
      ''}
        },

        fuzzy = { implementation = "prefer_rust_with_warning" },

        completion = {
          accept = {
            auto_brackets = {
              enabled = ${boolToString (
        if cfg ? completion && cfg.completion ? auto_brackets
        then cfg.completion.auto_brackets
        else true
      )},
            },
          },
          menu = {
            draw = {
              treesitter = { "lsp" },
            },
          },
          documentation = {
            auto_show = ${boolToString (
        if cfg ? completion && cfg.completion ? documentation && cfg.completion.documentation ? auto_show
        then cfg.completion.documentation.auto_show
        else true
      )},
            auto_show_delay_ms = ${toString (
        if cfg ? completion && cfg.completion ? documentation && cfg.completion.documentation ? auto_show_delay_ms
        then cfg.completion.documentation.auto_show_delay_ms
        else 200
      )},
          },
          ghost_text = {
            enabled = ${boolToString (
        if cfg ? completion && cfg.completion ? ghost_text && cfg.completion.ghost_text ? enabled
        then cfg.completion.ghost_text.enabled
        else false
      )},
          },
        },

        sources = {
          compat = {},
          default = { ${builtSources} },
          providers = {
            ${optionalString windsurfEnabled ''
        -- Windsurf/Codeium provider configuration
        codeium = {
          name = 'Codeium',
          module = 'codeium.blink',
          async = true,
        },
      ''}
          },
        },

        cmdline = {
          enabled = ${boolToString (
        if cfg ? cmdline && cfg.cmdline ? enabled
        then cfg.cmdline.enabled
        else false
      )},
        },

        keymap = {
          preset = "${
        if cfg ? keymap && cfg.keymap ? preset
        then cfg.keymap.preset
        else "enter"
      }",
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
      ${optionalString (cfg ? compat_sources && cfg.compat_sources != []) ''
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
      enable = true; # Always enable snippets when blink.cmp is enabled
      sources = ["friendly-snippets"];
    };
  };
}
