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
        !(n == "codeium" && !windsurfEnabled) && v != null
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
        "friendly-snippets"
      ]
      ++ optionals windsurfEnabled [
        "windsurf-nvim"
        "plenary-nvim"
      ];

    vim.code.completion.sources = {
      "lsp" = "[LSP]";
      "path" = "[Path]";
      "snippets" = "[Snippets]";
      "buffer" = "[Buffer]";
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
        -- Debug: Check blink.cmp status
        print("Setting up blink.cmp...")

        -- Check if blink.cmp is available
        local blink_ok, blink = pcall(require, 'blink.cmp')
        if not blink_ok then
          print("ERROR: blink.cmp not found!")
          return
        end

        print("blink.cmp module loaded successfully")

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
        local setup_ok, setup_err = pcall(function()
          require('blink.cmp').setup({
            sources = {
              default = { 'lsp', 'path', 'snippets', 'buffer' },
              ${optionalString (length cfg.compat_sources > 0 || windsurfEnabled) ''
        compat = { ${concatMapStringsSep ", " (s: "'${s}'") (cfg.compat_sources ++ optional windsurfEnabled "codeium")} },
      ''}
            },

            keymap = {
              preset = "${cfg.keymap.preset}",
              ['<Tab>'] = { "select_next", "show", "fallback" },
              ['<S-Tab>'] = { "select_prev", "fallback" },
              ['<CR>'] = { "accept", "fallback" },
              ['<C-Space>'] = { "show" },
            },

            completion = {
              accept = {
        expand_snippet = vim.snippet.expand,
      },
              documentation = {
                auto_show = ${boolToString cfg.completion.documentation.auto_show},
                auto_show_delay_ms = ${toString cfg.completion.documentation.auto_show_delay_ms},
              },
              ghost_text = {
                enabled = ${boolToString cfg.completion.ghost_text.enabled},
              },
            },

            appearance = {
              nerd_font_variant = "${cfg.appearance.nerd_font_variant}",
              use_nvim_cmp_as_default = ${boolToString cfg.appearance.use_nvim_cmp_as_default},
              ${optionalString lspkindEnabled "kind_icons = kind_icons,"}
            },

            ${optionalString cfg.cmdline.enabled ''
        cmdline = {
          enabled = true,
        },
      ''}

            snippets = {
              expand = function(snippet, _)
                ${cfg.snippets.expand}
              end,
            },

            signature = {
              enabled = true,
            },
          })
        end)

        if not setup_ok then
          print("ERROR: blink.cmp setup failed:", setup_err)
          return
        end

        print("blink.cmp setup completed successfully")

        -- Setup LSP capabilities for blink.cmp
        local cap_ok, capabilities = pcall(function()
          return require('blink.cmp').get_lsp_capabilities()
        end)

        if cap_ok then
          print("LSP capabilities configured successfully")
        else
          print("Warning: Could not get LSP capabilities:", capabilities)
        end

        -- Debug: Check what got configured
        vim.defer_fn(function()
          print("=== BLINK.CMP DEBUG ===")
          local config_ok, config = pcall(function()
            return require('blink.cmp').get_config()
          end)

          if config_ok and config then
            if config.sources then
              print("Sources configured:", vim.inspect(config.sources.default))
              print("Providers available:", vim.inspect(vim.tbl_keys(config.sources.providers or {})))
            else
              print("Config found but no sources:", vim.inspect(config))
            end
          else
            print("Failed to get config:", config)
          end
          print("======================")
        end, 1000)

    '');

    # Enable friendly-snippets and configure snippet support
    vim.snippets = {
      enable = true; # Always enable snippets when blink.cmp is enabled
      sources = ["friendly-snippets"];
    };
  };
}
