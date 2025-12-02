-- ========================================================================
-- STRUDEL KEYMAPS (<leader>m - Music/Media)
-- ========================================================================
-- These keymaps control Strudel live coding environment
-- Global keymaps - work from any buffer
-- ========================================================================

-- Helper to safely call strudel functions
local function call_strudel(func_name)
  local ok, strudel = pcall(require, 'strudel')
  if not ok then
    vim.notify('Strudel plugin not loaded yet', vim.log.levels.WARN)
    return
  end
  strudel[func_name]()
end

-- Launch Strudel browser
vim.keymap.set('n', '<leader>ml', function()
  call_strudel('launch')
end, { desc = 'Launch Strudel' })

-- Toggle Play/Stop
vim.keymap.set('n', '<leader>mp', function()
  call_strudel('toggle')
end, { desc = 'Play/Stop' })

-- Update (evaluate code)
vim.keymap.set('n', '<leader>mu', function()
  call_strudel('update')
end, { desc = 'Update' })

-- Stop playback
vim.keymap.set('n', '<leader>ms', function()
  call_strudel('stop')
end, { desc = 'Stop' })

-- Quit Strudel
vim.keymap.set('n', '<leader>mq', function()
  call_strudel('quit')
end, { desc = 'Quit' })

-- Set current buffer
vim.keymap.set('n', '<leader>mb', function()
  call_strudel('set_buffer')
end, { desc = 'Set Buffer' })

-- Execute (set buffer + update)
vim.keymap.set('n', '<leader>mx', function()
  call_strudel('execute')
end, { desc = 'Execute' })
