{
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.ai;
in {
  config = mkIf (cfg.windsurf.enable) {
    vim.startPlugins = ["windsurf"];
    vim.luaConfigRC.windsurf = ''
      vim.g.codeium_filetypes_disabled_by_default = 1;

        vim.g.codeium_filetypes = {
          -- Already in your config
          rust = true,
          python = true,
          bash = true,
          lua = true,
          dart = true,
          nix = true,

          -- Common programming languages
          javascript = true,
          typescript = true,
          java = true,
          c = true,
          cpp = true,
          csharp = true,
          go = true,
          php = true,
          ruby = true,
          kotlin = true,
          swift = true,

          -- Web development
          html = true,
          css = true,
          scss = true,
          less = true,
          json = true,
          xml = true,
          yaml = true,
          markdown = true,

          -- Shell scripting
          sh = true,
          zsh = true,
          fish = true,

          -- Database
          sql = true,
          plsql = true,

          -- Configuration
          toml = true,
          ini = true,

          -- Mobile
          objectivec = true,

          -- JVM languages
          scala = true,
          groovy = true,
          clojure = true,

          -- Microsoft
          powershell = true,
          fsharp = true,
          vb = true,

          -- Systems programming
          assembly = true,
          fortran = true,
          cobol = true,
          perl = true,

          -- Functional
          haskell = true,
          elixir = true,
          erlang = true,

          -- Other common languages
          r = true,
          julia = true,
          matlab = true,
          lisp = true,
          scheme = true,

          -- Modern languages
          zig = true,
          crystal = true,
          nim = true,

          -- Domain specific
          graphql = true,
          terraform = true,
          dockerfile = true,

          -- Other scripting languages
          applescript = true,
          vimscript = true,

          -- Templating
          handlebars = true,
          ejs = true,
          jinja = true,

          -- Other config formats
          jsonc = true,
          conf = true,

          -- Front-end frameworks
          vue = true,
          svelte = true,
          jsx = true,
          tsx = true,

          -- Other
          protobuf = true,
          solidity = true,
          commonlisp = true,
        }


        vim.keymap.set("i", "<C-a>", function()
          return vim.fn["codeium#Accept"]()
        end, { expr = true, silent = true })
        vim.keymap.set("i", "<C-n>", function()
          return vim.fn["codeium#CycleOrComplete"]()
        end, { expr = true, silent = true })
        vim.keymap.set("i", "<C-p>", function()
          return vim.fn["codeium#CycleCompletions"](-1)
        end, { expr = true, silent = true })
        vim.keymap.set("i", "<C-c>", function()
          return vim.fn["codeium#Clear"]()
        end, { expr = true, silent = true })
    '';
  };
}
