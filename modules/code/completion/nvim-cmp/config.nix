{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.completion.nvimCmp;
  lspkindEnabled = config.vim.code.lsp.enable && config.vim.code.lsp.lspkind.enable;
  lspEnabled = config.vim.code.lsp.enable or false;
  treesitterEnabled = config.vim.treesitter.enable or false;
  rustEnabled = config.vim.languages.rust.enable or false;
  windsurfEnabled = config.vim.code.ai.windsurf.enable or false;

  # Ensure we have a proper sources configuration
  defaultSources =
    {
      "vsnip" = "[VSnip]";
      "buffer" = "[Buffer]";
      "path" = "[Path]";
    }
    // optionalAttrs lspEnabled {"nvim_lsp" = "[LSP]";}
    // optionalAttrs treesitterEnabled {"treesitter" = "[Treesitter]";}
    // optionalAttrs rustEnabled {"crates" = "[Crates]";}
    // optionalAttrs windsurfEnabled {"codeium" = "[Codeium]";};

  dagPlacement =
    if lspkindEnabled
    then lib.nvim.dag.entryAfter ["lspkind"]
    else lib.nvim.dag.entryAnywhere;
in {
  config = mkIf cfg.enable {
    vim.startPlugins =
      [
        "nvim-cmp"
        "cmp-buffer"
        "cmp-vsnip"
        "cmp-path"
        "vim-vsnip"
      ]
      ++ optionals lspEnabled ["cmp-nvim-lsp"]
      ++ optionals treesitterEnabled ["cmp-treesitter"]
      ++ optionals rustEnabled ["cmp-crates"]
      ++ optionals windsurfEnabled ["windsurf-nvim" "plenary-nvim"];

    # Ensure sources are properly set
    vim.code.completion.sources = defaultSources;

    # Setup Windsurf/Codeium BEFORE nvim-cmp
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
        -- Vim version available, will register with nvim-cmp automatically
      end
    '');

    vim.luaConfigRC.completion = mkIf cfg.enable (dagPlacement ''
      local cmp = require'cmp'

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local feedkey = function(key, mode)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = 'buffer' },
          { name = 'path' },
          { name = 'vsnip' },
          ${optionalString lspEnabled "{ name = 'nvim_lsp' },"}
          ${optionalString treesitterEnabled "{ name = 'treesitter' },"}
          ${optionalString rustEnabled "{ name = 'crates' },"}
          ${optionalString windsurfEnabled "{ name = 'codeium' },"}
        }),
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({
            select = true,
          }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
              feedkey("<Plug>(vsnip-expand-or-jump)", "")
            else
              cmp.complete()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
              feedkey("<Plug>(vsnip-jump-prev)", "")
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        completion = {
          completeopt = 'menu,menuone,noselect',
        },
        formatting = {
          format = function(entry, vim_item)
            local menu_map = {
              buffer = '[Buffer]',
              path = '[Path]',
              vsnip = '[VSnip]',
              ${optionalString lspEnabled "nvim_lsp = '[LSP]',"}
              ${optionalString treesitterEnabled "treesitter = '[Treesitter]',"}
              ${optionalString rustEnabled "crates = '[Crates]',"}
              ${optionalString windsurfEnabled "codeium = '[Codeium]',"}
            }
            vim_item.menu = menu_map[entry.source.name] or '[Unknown]'
            return vim_item
          end,
        },
        experimental = {
          ghost_text = false,
        },
      })

      ${optionalString lspEnabled ''
        -- Setup lspconfig capabilities for nvim-cmp
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
      ''}
    '');

    vim.snippets.vsnip.enable = true;
  };
}
