-- ========================================================================
-- RUST/CARGO GLOBAL KEYMAPS - Always available (not buffer-local)
-- ========================================================================
-- Loaded eagerly at startup to make commands available from any buffer
-- This allows you to control Cargo/Rust projects from terminals, logs, etc.
-- ========================================================================

local toolcheck = require 'utils.toolcheck'

-- Helper function to run terminal commands with "Press ENTER to close" prompt
local function run_terminal_cmd(cmd)
  vim.cmd 'tabnew'
  local bufnr = vim.api.nvim_get_current_buf()

  -- Wrap command to show exit status and wait for Enter, then close buffer
  local wrapped_cmd = string.format(
    '%s; echo "\n---"; if [ $? -eq 0 ]; then echo "✓ Command completed successfully"; else echo "✗ Command failed with exit code $?"; fi; echo "Press ENTER to close"; read; exit',
    cmd
  )
  local job_id = vim.fn.termopen { 'zsh', '-c', wrapped_cmd }

  -- Auto-close terminal when job finishes (user pressed ENTER)
  vim.api.nvim_create_autocmd('TermClose', {
    buffer = bufnr,
    once = true,
    callback = function()
      vim.cmd 'bdelete!'
    end,
  })

  -- Start in insert mode after a delay (let command run first)
  vim.defer_fn(function()
    if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_get_current_buf() == bufnr then
      vim.cmd 'startinsert'
    end
  end, 100)
end

-- NOTE: The <leader>lr group is registered globally in editor.lua
-- NOTE: The <leader>lr group is registered globally in editor.lua
-- NOTE: Rustaceanvim-specific buffer-local commands are in the on_attach above

-- Build project
vim.keymap.set('n', '<leader>lrb', function()
  if not toolcheck.check_cargo() then
    return
  end
  run_terminal_cmd 'cargo build'
  vim.notify('📦 Building with cargo...', vim.log.levels.INFO)
end, { desc = 'Cargo: Build' })

-- Run project
vim.keymap.set('n', '<leader>lrr', function()
  if not toolcheck.check_cargo() then
    return
  end
  run_terminal_cmd 'cargo run'
  vim.notify('🚀 Running with cargo...', vim.log.levels.INFO)
end, { desc = 'Cargo: Run' })

-- Test project
vim.keymap.set('n', '<leader>lrt', function()
  if not toolcheck.check_cargo() then
    return
  end
  run_terminal_cmd 'cargo test'
  vim.notify('🧪 Running tests...', vim.log.levels.INFO)
end, { desc = 'Cargo: Test' })

-- Check project (faster than build)
vim.keymap.set('n', '<leader>lrk', function()
  if not toolcheck.check_cargo() then
    return
  end
  run_terminal_cmd 'cargo check'
  vim.notify('🔍 Checking project...', vim.log.levels.INFO)
end, { desc = 'Cargo: Check' })

-- Clippy (linter)
vim.keymap.set('n', '<leader>lrl', function()
  if not toolcheck.check_cargo() then
    return
  end
  run_terminal_cmd 'cargo clippy'
  vim.notify('📎 Running clippy...', vim.log.levels.INFO)
end, { desc = 'Cargo: Clippy' })

-- Format with rustfmt
vim.keymap.set('n', '<leader>lrf', function()
  if not toolcheck.check_cargo() then
    return
  end
  run_terminal_cmd 'cargo fmt'
  vim.notify('✨ Formatting with rustfmt...', vim.log.levels.INFO)
end, { desc = 'Cargo: Format' })

-- Clean build artifacts
vim.keymap.set('n', '<leader>lrx', function()
  if not toolcheck.check_cargo() then
    return
  end
  run_terminal_cmd 'cargo clean'
  vim.notify('🧹 Cleaning build artifacts...', vim.log.levels.INFO)
end, { desc = 'Cargo: Clean' })

-- Add dependency
vim.keymap.set('n', '<leader>lrA', function()
  if not toolcheck.check_cargo() then
    return
  end
  vim.ui.input({ prompt = 'Crate name (e.g., serde): ' }, function(crate_name)
    if not crate_name or crate_name == '' then
      return
    end
    run_terminal_cmd('cargo add ' .. crate_name)
    vim.notify('📦 Adding crate: ' .. crate_name, vim.log.levels.INFO)
  end)
end, { desc = 'Cargo: Add dependency' })

-- Remove dependency
vim.keymap.set('n', '<leader>lrX', function()
  if not toolcheck.check_cargo() then
    return
  end
  vim.ui.input({ prompt = 'Crate name to remove: ' }, function(crate_name)
    if not crate_name or crate_name == '' then
      return
    end
    run_terminal_cmd('cargo remove ' .. crate_name)
    vim.notify('🗑️  Removing crate: ' .. crate_name, vim.log.levels.INFO)
  end)
end, { desc = 'Cargo: Remove dependency' })

-- Update dependencies
vim.keymap.set('n', '<leader>lrU', function()
  if not toolcheck.check_cargo() then
    return
  end
  run_terminal_cmd 'cargo update'
  vim.notify('🔄 Updating dependencies...', vim.log.levels.INFO)
end, { desc = 'Cargo: Update deps' })

-- Build documentation
vim.keymap.set('n', '<leader>lrD', function()
  if not toolcheck.check_cargo() then
    return
  end
  run_terminal_cmd 'cargo doc --open'
  vim.notify('📚 Building and opening docs...', vim.log.levels.INFO)
end, { desc = 'Cargo: Doc' })
