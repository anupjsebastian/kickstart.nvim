-- ========================================================================
-- WEB DEV GLOBAL KEYMAPS - Always available (not buffer-local)
-- ========================================================================
-- Loaded eagerly at startup for Svelte/JS/TS workflow commands
-- Available from any buffer (terminals, logs) for bun workflow
-- ========================================================================

local toolcheck = require 'utils.toolcheck'

-- Helper function to run terminal commands with "Press ENTER to close" prompt
local function run_terminal_cmd(cmd)
  vim.cmd 'split'
  vim.cmd 'wincmd J' -- Move split to bottom
  vim.cmd 'resize 15' -- Set height to 15 lines
  vim.cmd 'enew' -- Create empty buffer
  local bufnr = vim.api.nvim_get_current_buf()

  -- Set buffer options to make it unlisted and scratch
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = bufnr })
  vim.api.nvim_set_option_value('buflisted', false, { buf = bufnr })
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = bufnr })

  -- Wrap command to show exit status
  local wrapped_cmd = string.format(
    '%s; echo "\n---"; if [ $? -eq 0 ]; then echo "✓ Command completed successfully"; else echo "✗ Command failed with exit code $?"; fi',
    cmd
  )

  -- Collect output and display in buffer
  local output = {}
  vim.fn.jobstart({ 'zsh', '-c', wrapped_cmd }, {
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= '' then
            table.insert(output, line)
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= '' then
            table.insert(output, line)
          end
        end
      end
    end,
    on_exit = function()
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, output)
          vim.api.nvim_set_option_value('modifiable', false, { buf = bufnr })
          -- Stay in normal mode - user can close with :q or <C-w>q
        end
      end)
    end,
  })
end

-- NOTE: The <leader>ls group is registered globally in editor.lua
-- NOTE: The <leader>ls group is registered globally in editor.lua

-- Run dev server (bun run dev) - Don't auto-close for long-running servers
vim.keymap.set('n', '<leader>lsr', function()
  if not toolcheck.check_bun() then
    return
  end
  -- Don't use helper for dev server - it's long-running
  vim.cmd 'tabnew'
  vim.fn.jobstart('bun run dev', { pty = true })
  vim.notify('🚀 Starting dev server...', vim.log.levels.INFO)
end, { desc = 'Run dev server (bun run dev)' })

-- Build project (bun run build)
vim.keymap.set('n', '<leader>lsb', function()
  if not toolcheck.check_bun() then
    return
  end
  run_terminal_cmd 'bun run build'
  vim.notify('📦 Building project...', vim.log.levels.INFO)
end, { desc = 'Build (bun run build)' })

-- Preview build (bun run preview) - Don't auto-close for preview server
vim.keymap.set('n', '<leader>lsp', function()
  if not toolcheck.check_bun() then
    return
  end
  vim.cmd 'tabnew'
  vim.fn.jobstart('bun run preview', { pty = true })
  vim.notify('👀 Preview production build...', vim.log.levels.INFO)
end, { desc = 'Preview build' })

-- Type check (bun run check)
vim.keymap.set('n', '<leader>lsc', function()
  if not toolcheck.check_bun() then
    return
  end
  run_terminal_cmd 'bun run check'
  vim.notify('🔍 Type checking...', vim.log.levels.INFO)
end, { desc = 'Type check' })

-- Lint (bun run lint)
vim.keymap.set('n', '<leader>lse', function()
  if not toolcheck.check_bun() then
    return
  end
  run_terminal_cmd 'bun run lint'
  vim.notify('📋 Running ESLint...', vim.log.levels.INFO)
end, { desc = 'Lint (ESLint)' })

-- Run tests (bun test)
vim.keymap.set('n', '<leader>lsT', function()
  if not toolcheck.check_bun() then
    return
  end
  run_terminal_cmd 'bun test'
  vim.notify('🧪 Running tests...', vim.log.levels.INFO)
end, { desc = 'Run tests' })

-- Install dependencies (bun install)
vim.keymap.set('n', '<leader>lsi', function()
  if not toolcheck.check_bun() then
    return
  end
  run_terminal_cmd 'bun install'
  vim.notify('📥 Installing dependencies...', vim.log.levels.INFO)
end, { desc = 'Install deps' })

-- Install dependencies (bun install)
vim.keymap.set('n', '<leader>lsi', function()
  if not toolcheck.check_bun() then
    return
  end
  run_terminal_cmd 'bun install'
  vim.notify('📦 Installing dependencies...', vim.log.levels.INFO)
end, { desc = 'Install deps' })

-- Add package (bun add)
vim.keymap.set('n', '<leader>lsa', function()
  if not toolcheck.check_bun() then
    return
  end
  local pkg = vim.fn.input 'Package name (e.g., @sveltejs/kit): '
  if pkg ~= '' then
    run_terminal_cmd('bun add ' .. pkg)
    vim.notify('📦 Adding package: ' .. pkg, vim.log.levels.INFO)
  end
end, { desc = 'Add package' })

-- Add dev package (bun add -d)
vim.keymap.set('n', '<leader>lsA', function()
  if not toolcheck.check_bun() then
    return
  end
  local pkg = vim.fn.input 'Dev package name (e.g., vite): '
  if pkg ~= '' then
    run_terminal_cmd('bun add -d ' .. pkg)
    vim.notify('📦 Adding dev package: ' .. pkg, vim.log.levels.INFO)
  end
end, { desc = 'Add dev package' })

-- Remove package (bun remove)
vim.keymap.set('n', '<leader>lsx', function()
  if not toolcheck.check_bun() then
    return
  end
  local pkg = vim.fn.input 'Package to remove: '
  if pkg ~= '' then
    run_terminal_cmd('bun remove ' .. pkg)
    vim.notify('🗑️  Removing package: ' .. pkg, vim.log.levels.INFO)
  end
end, { desc = 'Remove package' })

-- Update dependencies (bun update)
vim.keymap.set('n', '<leader>lsu', function()
  if not toolcheck.check_bun() then
    return
  end
  run_terminal_cmd 'bun update'
  vim.notify('🔄 Updating dependencies...', vim.log.levels.INFO)
end, { desc = 'Update deps' })

-- Restart TypeScript LSP
vim.keymap.set('n', '<leader>lst', function()
  vim.cmd 'LspRestart ts_ls'
  vim.notify('󰛦 Restarting TypeScript LSP...', vim.log.levels.INFO)
end, { desc = 'Restart TypeScript LSP' })
