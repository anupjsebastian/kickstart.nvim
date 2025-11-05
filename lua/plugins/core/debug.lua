-- ========================================================================
-- DEBUG CONFIGURATION - Global DAP keymaps
-- ========================================================================
-- These keymaps are available whenever nvim-dap is loaded
-- Works for all languages: Flutter, Rust, Python, etc.
-- ========================================================================

return {
  -- nvim-dap: Debug Adapter Protocol client
  {
    'mfussenegger/nvim-dap',
    optional = true,
    keys = {
      -- Function key shortcuts (standard debugging across all editors)
      { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
      { '<F10>', function() require('dap').step_over() end, desc = 'Debug: Step over' },
      { '<F11>', function() require('dap').step_into() end, desc = 'Debug: Step into' },
      { '<F12>', function() require('dap').step_out() end, desc = 'Debug: Step out' },

      -- Leader-based debug commands (more discoverable)
      { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle breakpoint' },
      { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'Conditional breakpoint' },
      { '<leader>dc', function() require('dap').continue() end, desc = 'Continue' },
      { '<leader>di', function() require('dap').step_into() end, desc = 'Step into' },
      { '<leader>do', function() require('dap').step_out() end, desc = 'Step out' },
      { '<leader>dO', function() require('dap').step_over() end, desc = 'Step over' },
      { '<leader>dt', function() require('dap').terminate() end, desc = 'Terminate' },
      { '<leader>dr', function() require('dap').repl.toggle() end, desc = 'Toggle REPL' },
      { '<leader>dl', function() require('dap').run_last() end, desc = 'Run last' },
      { '<leader>dC', function() require('dap').run_to_cursor() end, desc = 'Run to cursor' },
    },
    config = function()
      -- Custom debug signs - more visible breakpoints
      vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointRejected', { text = '○', texthl = 'DiagnosticHint', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '→', texthl = 'DiagnosticInfo', linehl = 'DapStoppedLine', numhl = '' })
      vim.fn.sign_define('DapLogPoint', { text = '◎', texthl = 'DiagnosticInfo', linehl = '', numhl = '' })
    end,
  },

  -- nvim-dap-ui: UI for nvim-dap
  {
    'rcarriga/nvim-dap-ui',
    optional = true,
    keys = {
      { '<leader>du', function() require('dapui').toggle() end, desc = 'Toggle UI' },
      { '<leader>de', function() require('dapui').eval() end, desc = 'Eval', mode = { 'n', 'v' } },
    },
  },
}
