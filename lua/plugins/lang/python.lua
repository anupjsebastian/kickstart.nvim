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
  -- Python-specific keymaps that are available globally (not buffer-local)
  -- This allows access to Python commands from logs, debuggers, etc.
  -- NOTE: The <leader>lp group is registered globally in editor.lua
  -- ========================================================================
  {
    'nvim-lua/plenary.nvim', -- Dummy dependency to create a lazy spec
    ft = 'python',
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'python',
        callback = function(event)
          local bufnr = event.buf

          -- ====================================================================
          -- RUNNING & EXECUTION
          -- ====================================================================
          -- Run current file with python
          vim.keymap.set('n', '<leader>lpr', function()
            vim.cmd('!python3 %')
          end, { buffer = bufnr, desc = 'Run file' })

          -- Run with uv
          vim.keymap.set('n', '<leader>lpR', function()
            vim.cmd('!uv run %')
          end, { buffer = bufnr, desc = 'Run file (uv run)' })

          -- Run with arguments
          vim.keymap.set('n', '<leader>lpx', function()
            local args = vim.fn.input 'Arguments: '
            vim.cmd('!python3 % ' .. args)
          end, { buffer = bufnr, desc = 'Run with args' })

          -- ====================================================================
          -- PACKAGE MANAGEMENT (UV)
          -- ====================================================================
          -- Add package
          vim.keymap.set('n', '<leader>lpa', function()
            local pkg = vim.fn.input 'Package to add: '
            if pkg ~= '' then
              vim.cmd('!uv add ' .. pkg)
            end
          end, { buffer = bufnr, desc = 'Add package (uv)' })

          -- Add dev package
          vim.keymap.set('n', '<leader>lpA', function()
            local pkg = vim.fn.input 'Dev package to add: '
            if pkg ~= '' then
              vim.cmd('!uv add --dev ' .. pkg)
            end
          end, { buffer = bufnr, desc = 'Add dev package (uv)' })

          -- Remove package
          vim.keymap.set('n', '<leader>lpd', function()
            local pkg = vim.fn.input 'Package to remove: '
            if pkg ~= '' then
              vim.cmd('!uv remove ' .. pkg)
            end
          end, { buffer = bufnr, desc = 'Remove package (uv)' })

          -- Update/sync packages
          vim.keymap.set('n', '<leader>lpu', function()
            vim.cmd('!uv sync')
          end, { buffer = bufnr, desc = 'Sync packages (uv)' })

          -- ====================================================================
          -- VIRTUAL ENVIRONMENT
          -- ====================================================================
          -- Select/activate virtual environment
          vim.keymap.set('n', '<leader>lpe', function()
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

          -- Show virtual environment info
          vim.keymap.set('n', '<leader>lpv', function()
            local venv = vim.env.VIRTUAL_ENV or 'No venv active'
            local python = vim.fn.system('which python3'):gsub('\n', '')
            vim.notify(string.format('Venv: %s\nPython: %s', venv, python), vim.log.levels.INFO)
          end, { buffer = bufnr, desc = 'Show venv info' })

          -- ====================================================================
          -- TESTING
          -- ====================================================================
          -- Run all tests with pytest
          vim.keymap.set('n', '<leader>lpt', function()
            vim.cmd('!uv run pytest')
          end, { buffer = bufnr, desc = 'Run tests (pytest)' })

          -- Run current test file
          vim.keymap.set('n', '<leader>lpT', function()
            vim.cmd('!uv run pytest %')
          end, { buffer = bufnr, desc = 'Run current test file' })

          -- Run tests with coverage
          vim.keymap.set('n', '<leader>lpc', function()
            vim.cmd('!uv run pytest --cov')
          end, { buffer = bufnr, desc = 'Run tests with coverage' })

          -- ====================================================================
          -- LSP & FORMATTING
          -- ====================================================================
          -- Restart Python LSP
          vim.keymap.set('n', '<leader>lpl', function()
            vim.cmd 'LspRestart pyright'
          end, { buffer = bufnr, desc = 'Restart LSP' })

          -- Import organization (via Ruff)
          vim.keymap.set('n', '<leader>lpi', function()
            require('conform').format { formatters = { 'ruff_organize_imports' } }
          end, { buffer = bufnr, desc = 'Organize imports' })

          -- Format with Ruff
          vim.keymap.set('n', '<leader>lpf', function()
            require('conform').format { formatters = { 'ruff_format' } }
          end, { buffer = bufnr, desc = 'Format code' })
        end,
      })
    end,
  },
}
