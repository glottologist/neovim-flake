{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.treesitter;
  usingCmp = config.vim.code.completion.nvimCmp.enable || config.vim.code.completion.blinkCmp.enable;
in {
  config = mkIf cfg.enable {
    vim.startPlugins =
      ["nvim-treesitter"]
      ++ optional usingCmp "cmp-treesitter";

    vim.code.completion.sources = {"treesitter" = "[Treesitter]";};

    # For some reason treesitter highlighting does not work on start if this is set before syntax on
    vim.configRC.treesitter-fold = mkIf cfg.fold (nvim.dag.entryBefore ["basic"] ''
      set foldmethod=expr
      set foldexpr=v:lua.vim.treesitter.foldexpr()
      set nofoldenable
    '');

    # nvim-treesitter's rewritten branch no longer owns highlighting: it ships
    # parsers and queries only, leaving activation to Neovim's own treesitter
    # API. We therefore start a parser per buffer, guarding on whether the
    # grammar for that filetype was actually built into this configuration.
    vim.luaConfigRC.treesitter = nvim.dag.entryAnywhere ''
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("nvim_treesitter_start", {clear = true}),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if lang and vim.treesitter.language.add(lang) then
            vim.treesitter.start(args.buf, lang)
          end
        end,
      })
    '';
  };
}
