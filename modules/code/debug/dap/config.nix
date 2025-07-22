{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.code.debug;
in {
  config = mkIf (cfg.dap.enable) {
    vim.startPlugins = [
      "dap"
      "dap-ui"
      "dap-virtual-text"
      "nvim-nio"
    ];

    # Key mappings for DAP
    vim.nnoremap = {
      "<leader>dB" = ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>";
      "<leader>db" = ":lua require('dap').toggle_breakpoint()<CR>";
      "<leader>dc" = ":lua require('dap').continue()<CR>";
      "<leader>dC" = ":lua require('dap').run_to_cursor()<CR>";
      "<leader>dg" = ":lua require('dap').goto_()<CR>";
      "<leader>di" = ":lua require('dap').step_into()<CR>";
      "<leader>dj" = ":lua require('dap').down()<CR>";
      "<leader>dk" = ":lua require('dap').up()<CR>";
      "<leader>dl" = ":lua require('dap').run_last()<CR>";
      "<leader>do" = ":lua require('dap').step_out()<CR>";
      "<leader>dO" = ":lua require('dap').step_over()<CR>";
      "<leader>dP" = ":lua require('dap').pause()<CR>";
      "<leader>dr" = ":lua require('dap').repl.toggle()<CR>";
      "<leader>ds" = ":lua require('dap').session()<CR>";
      "<leader>dt" = ":lua require('dap').terminate()<CR>";
      "<leader>dw" = ":lua require('dap.ui.widgets').hover()<CR>";
      "<leader>du" = ":lua require('dapui').toggle({})<CR>";
      "<leader>de" = ":lua require('dapui').eval()<CR>";
    };

    # Visual mode mappings for eval
    vim.vnoremap = {
      "<leader>de" = ":lua require('dapui').eval()<CR>";
    };

    # Main DAP configuration
    vim.luaConfigRC.dap = nvim.dag.entryAnywhere ''

      -- Key mapping for "Run with Args" that uses the get_args function
      vim.keymap.set('n', '<leader>da', function()
        require('dap').continue({ before = get_args })
      end, { desc = "Run with Args" })

      -- Set up highlight for stopped line
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      -- Define debug signs
      local signs = {
        Stopped = { "󰁕", "DiagnosticWarn", "DapStoppedLine" },
        Breakpoint = { "●", "DiagnosticError" },
        BreakpointCondition = { "●", "DiagnosticError" },
        BreakpointRejected = { "●", "DiagnosticError" },
        LogPoint = { ".>", "DiagnosticError" },
      }

      for name, sign in pairs(signs) do
        vim.fn.sign_define(
          "Dap" .. name,
          {
            text = sign[1],
            texthl = sign[2] or "DiagnosticInfo",
            linehl = sign[3],
            numhl = sign[3]
          }
        )
      end

      -- Setup VsCode launch.json support
      local vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end
    '';

    # DAP Virtual Text configuration
    vim.luaConfigRC.dap-virtual-text = nvim.dag.entryAfter ["dap"] ''
      require("nvim-dap-virtual-text").setup({})
    '';

    # DAP UI configuration
    vim.luaConfigRC.dap-ui = nvim.dag.entryAfter ["dap"] ''
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup({})

      -- Automatically open/close dapui
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    '';

    # Which-key integration (if enabled)
    vim.luaConfigRC.dap-which-key = nvim.dag.entryAfter ["dap" "which-key"] ''
      ${nvim.lua.writeIf config.vim.keys.whichKey.enable ''
        local wk = require("which-key")
        wk.add({
          { "<leader>d", group = "Debug" },
          { "<leader>dB", desc = "Breakpoint Condition" },
          { "<leader>da", desc = "Run with Args" },
          { "<leader>db", desc = "Toggle Breakpoint" },
          { "<leader>dc", desc = "Continue" },
          { "<leader>dC", desc = "Run to Cursor" },
          { "<leader>dg", desc = "Go to line (no execute)" },
          { "<leader>di", desc = "Step Into" },
          { "<leader>dj", desc = "Down" },
          { "<leader>dk", desc = "Up" },
          { "<leader>dl", desc = "Run Last" },
          { "<leader>do", desc = "Step Out" },
          { "<leader>dO", desc = "Step Over" },
          { "<leader>dP", desc = "Pause" },
          { "<leader>dr", desc = "Toggle REPL" },
          { "<leader>ds", desc = "Session" },
          { "<leader>dt", desc = "Terminate" },
          { "<leader>dw", desc = "Widgets" },
          { "<leader>du", desc = "Dap UI" },
          { "<leader>de", desc = "Eval", mode = { "n", "v" } },
        })
      ''}
    '';
  };
}
