-- ========================================================================
-- PYTHON PROFILE - Language-specific plugins and LSP configuration
-- ========================================================================
--
-- This file contains all Python-specific plugins and configurations.
-- These plugins will ONLY load when you open a .py file, keeping your
-- startup time fast and avoiding conflicts with other languages.
--
-- Key features to configure here:
--   - Python LSP (pyright or pylsp)
--   - Python formatters (black, ruff, isort, etc.)
--   - Python linters and type checkers
--   - Debugger integration (debugpy)
--   - Testing tools (pytest)
--   - Virtual environment detection
--   - Python-specific keymaps
--
-- Usage: Just open a .py file and these plugins will automatically load!
-- ========================================================================

return {
  -- ========================================================================
  -- PYTHON TOOLS - Language Server and Linter
  -- ========================================================================
  -- Ensures pyright and ruff are installed via Mason
  -- NOTE: Venv detection is configured in lua/plugins/lsp/init.lua
  -- ========================================================================
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    ft = 'python',
    dependencies = { 'williamboman/mason.nvim' },
    opts = {
      ensure_installed = { 'pyright', 'ruff' },
    },
  },

  -- ========================================================================
  -- PYTHON FORMATTERS - Auto-format Python code
  -- ========================================================================
  -- Uses Ruff for fast formatting and import organization
  -- Ruff provides Black-compatible formatting + import sorting in one tool
  -- ========================================================================
  {
    'stevearc/conform.nvim',
    ft = 'python',
    opts = function(_, opts)
      -- Extend the existing formatters_by_ft table
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.python = {
        -- Ruff handles both formatting and import sorting (fast & modern)
        'ruff_organize_imports', -- First: organize imports
        'ruff_format', -- Then: format code (Black-compatible)
      }
      return opts
    end,
  },

  -- ========================================================================
  -- PYTHON-SPECIFIC KEYMAPS AND CONFIGURATION
  -- ========================================================================
  -- Additional Python-specific settings and keymaps
  -- ========================================================================
  {
    'nvim-treesitter/nvim-treesitter',
    ft = 'python',
    opts = function(_, opts)
      -- Ensure Python parser is installed
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'python' })
      return opts
    end,
  },

  -- ========================================================================
  -- PYTHON-SPECIFIC KEYMAPS
  -- ========================================================================
  -- Python-specific keymaps that are available only in Python files
  -- ========================================================================
  {
    'nvim-lua/plenary.nvim', -- Dummy dependency to create a lazy spec
    ft = 'python',
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'python',
        callback = function(event)
          local bufnr = event.buf

          -- Register which-key group for Python
          require('which-key').add {
            { '<leader>p', group = ' python', buffer = bufnr },
          }

          -- Run current file
          vim.keymap.set('n', '<leader>pr', function()
            vim.cmd('!python3 %')
          end, { buffer = bufnr, desc = 'Run file' })

          -- Run with arguments
          vim.keymap.set('n', '<leader>pR', function()
            local args = vim.fn.input 'Arguments: '
            vim.cmd('!python3 % ' .. args)
          end, { buffer = bufnr, desc = 'Run with args' })

          -- Select virtual environment (activate .venv)
          vim.keymap.set('n', '<leader>pe', function()
            local venv = vim.fn.getcwd() .. '/.venv/bin/python'
            if vim.loop.fs_stat(venv) then
              vim.env.VIRTUAL_ENV = vim.fn.getcwd() .. '/.venv'
              vim.env.PATH = vim.fn.getcwd() .. '/.venv/bin:' .. vim.env.PATH
              vim.notify('Activated venv: ' .. vim.env.VIRTUAL_ENV, vim.log.levels.INFO)
              vim.cmd 'LspRestart pyright'
            else
              vim.notify('No .venv found in project root', vim.log.levels.ERROR)
            end
          end, { buffer = bufnr, desc = 'Activate .venv' })

          -- Restart Python LSP
          vim.keymap.set('n', '<leader>pl', function()
            vim.cmd 'LspRestart pyright'
          end, { buffer = bufnr, desc = 'Restart LSP' })

          -- Import organization (via Ruff)
          vim.keymap.set('n', '<leader>pi', function()
            require('conform').format { formatters = { 'ruff_organize_imports' } }
          end, { buffer = bufnr, desc = 'Organize imports' })

          -- Format with Ruff
          vim.keymap.set('n', '<leader>pf', function()
            require('conform').format { formatters = { 'ruff_format' } }
          end, { buffer = bufnr, desc = 'Format code' })
        end,
      })
    end,
  },
}
