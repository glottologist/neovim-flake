{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.languages.rust;
in {
  options.vim.code.languages.rust = {
    enable = mkEnableOption "Rust language support";

    treesitter = {
      enable = mkOption {
        description = "Enable Rust treesitter";
        type = types.bool;
        default = config.vim.code.languages.enableTreesitter;
      };
      package = nvim.types.mkGrammarOption pkgs "rust";
    };

    crates = {
      enable = mkEnableOption "crates-nvim, tools for managing dependencies";
      codeActions = mkOption {
        description = "Enable code actions through the crates.nvim in-process language server";
        type = types.bool;
        default = true;
      };
    };

    lsp = {
      enable = mkOption {
        description = "Rust LSP support (rust-analyzer with extra tools)";
        type = types.bool;
        default = config.vim.code.languages.enableLSP;
      };
      package = mkOption {
        description = "rust-analyzer package";
        type = types.package;
        default = pkgs.rust-analyzer;
      };
      opts = mkOption {
        description = "Options to pass to rust analyzer";
        type = types.str;
        default = "";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.crates.enable {
      vim.startPlugins = ["crates-nvim"];

      vim.autocomplete.sources = {"crates" = "[Crates]";};

      # crates.nvim has retired its null-ls source in favour of an in-process
      # language server, which serves the same code actions without the
      # null-ls detour.
      vim.luaConfigRC.rust-crates = nvim.dag.entryAnywhere ''
        require('crates').setup {
          lsp = {
            enabled = ${boolToString cfg.crates.codeActions},
            actions = ${boolToString cfg.crates.codeActions},
            name = "crates.nvim",
          }
        }
      '';
    })
    (mkIf cfg.treesitter.enable {
      vim.code.treesitter.enable = true;
      vim.code.treesitter.grammars = [cfg.treesitter.package];
    })
    (mkIf cfg.lsp.enable {
      vim.startPlugins = ["rustaceanvim"];

      vim.code.lsp.enable = true;

      # rustaceanvim succeeds the archived rust-tools.nvim and speaks to
      # Neovim's LSP client directly, so nothing here touches the deprecated
      # `require('lspconfig')` framework. It is configured by a global rather
      # than a setup call, which must be in place before the plugin loads.
      vim.luaConfigRC.rust-lsp = nvim.dag.entryAfter ["lsp-setup"] ''
        rust_on_attach = function(client, bufnr)
          default_on_attach(client, bufnr)
          local opts = { noremap=true, silent=true, buffer = bufnr }
          vim.keymap.set("n", "<leader>ris", function() vim.lsp.inlay_hint.enable(true, { bufnr = bufnr }) end, opts)
          vim.keymap.set("n", "<leader>riu", function() vim.lsp.inlay_hint.enable(false, { bufnr = bufnr }) end, opts)
          vim.keymap.set("n", "<leader>rr", function() vim.cmd.RustLsp("runnables") end, opts)
          vim.keymap.set("n", "<leader>rp", function() vim.cmd.RustLsp("parentModule") end, opts)
          vim.keymap.set("n", "<leader>rm", function() vim.cmd.RustLsp("expandMacro") end, opts)
          vim.keymap.set("n", "<leader>rc", function() vim.cmd.RustLsp("openCargo") end, opts)
          vim.keymap.set("n", "<leader>rg", function() vim.cmd.RustLsp({"crateGraph", "x11"}) end, opts)
          -- Replaces rust-tools' hover_with_actions, which it retired in favour of a keybind.
          vim.keymap.set("n", "<leader>rh", function() vim.cmd.RustLsp({"hover", "actions"}) end, opts)
        end

        vim.g.rustaceanvim = {
          server = {
            capabilities = capabilities,
            on_attach = rust_on_attach,
            cmd = {"${cfg.lsp.package}/bin/rust-analyzer"},
            default_settings = {
              ${cfg.lsp.opts}
            },
          },
        }
      '';
    })
  ]);
}
