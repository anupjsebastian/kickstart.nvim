-- [[ Basic Keymaps ]]
-- See `:help vim.keymap.set()`

-- Close floating windows with Escape from anywhere
vim.keymap.set('n', '<Esc>', function()
  -- Try to close any floating windows
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= '' then
      vim.api.nvim_win_close(win, false)
      return -- Found and closed a floating window
    end
  end
  -- No floating window found, do normal escape behavior
  vim.cmd('nohlsearch')
end, { silent = true, desc = 'Close floating window or clear highlight' })

-- Diagnostic keymaps - Toggle quickfix list (works in normal buffers and quickfix itself)
vim.keymap.set('n', '<leader>q', function()
  -- Don't work in special buffers except quickfix/loclist and terminal
  local buftype = vim.bo.buftype
  if buftype ~= "" and buftype ~= "terminal" and buftype ~= "quickfix" then
    vim.notify("Quickfix toggle only works in regular buffers", vim.log.levels.WARN)
    return
  end
  
  local qf_winid = nil
  for _, win in pairs(vim.fn.getwininfo()) do
    if win['loclist'] == 1 then
      qf_winid = win.winid
      break
    end
  end
  if qf_winid then
    vim.api.nvim_win_close(qf_winid, true)
  else
    vim.diagnostic.setloclist()
  end
end, { desc = 'Toggle diagnostic quickfix list' })

-- Flutter outline toggle (global, works from any window including the outline itself)
vim.keymap.set('n', '<leader>fo', function()
  local outline_winnr = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name:match('FlutterOutline') then
      outline_winnr = win
      break
    end
  end
  
  if outline_winnr then
    vim.api.nvim_win_close(outline_winnr, true)
  else
    vim.cmd('FlutterOutlineToggle')
  end
end, { desc = 'Toggle outline' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- ========================================================================
-- KEYBINDS TO IMPROVE DEFAULT EXPERIENCE
-- ========================================================================
-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
-- Use CTRL+<hjkl> to switch between windows
-- See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- ========================================================================
-- QUIT OPERATIONS (<leader>Q)
-- ========================================================================
vim.keymap.set('n', '<leader>Q', '<cmd>qa<CR>', { desc = 'Quit all' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
-- Use CTRL+<hjkl> to switch between windows
-- See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Quit keymaps - easier ways to close Neovim (using capital Q to avoid conflict with diagnostic quickfix)
-- Session management is automatic via auto-session plugin (saves on exit, restores on startup)
vim.keymap.set('n', '<leader>Q', '<cmd>qa<CR>', { desc = '[Q]uit [A]ll' })

-- Alternative quit options (commented out, uncomment if needed):
-- vim.keymap.set('n', '<leader>Qq', '<cmd>qa!<CR>', { desc = '[Q]uit all without saving (force)' })
-- vim.keymap.set('n', '<leader>Qw', function()
--   vim.cmd 'wa' -- Write all buffers
--   vim.cmd 'qa'
-- end, { desc = '[Q]uit all and [W]rite files' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- ========================================================================
-- BUFFER OPERATIONS (<leader>b)
-- ========================================================================
vim.keymap.set('n', '<leader>bd', '<cmd>bd<CR>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>bD', '<cmd>bd!<CR>', { desc = 'Delete buffer (force)' })
vim.keymap.set('n', '<leader>bn', '<cmd>bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>bo', '<cmd>%bd|e#|bd#<CR>', { desc = 'Delete other buffers' })

-- ========================================================================
-- WINDOW OPERATIONS (<leader>w)
-- ========================================================================
vim.keymap.set('n', '<leader>ww', '<C-w>w', { desc = 'Other window' })
vim.keymap.set('n', '<leader>wd', '<C-w>c', { desc = 'Delete window' })
vim.keymap.set('n', '<leader>ws', '<C-w>s', { desc = 'Split window below' })
vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = 'Split window right' })
vim.keymap.set('n', '<leader>wm', '<C-w>_<C-w>|', { desc = 'Maximize window' })
vim.keymap.set('n', '<leader>w=', '<C-w>=', { desc = 'Balance windows' })
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = 'Go to left window' })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = 'Go to lower window' })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = 'Go to upper window' })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = 'Go to right window' })

-- ========================================================================
-- UI OPERATIONS (<leader>u)
-- ========================================================================
vim.keymap.set('n', '<leader>ul', '<cmd>Lazy<CR>', { desc = 'Open Lazy' })
vim.keymap.set('n', '<leader>um', '<cmd>Mason<CR>', { desc = 'Open Mason' })
vim.keymap.set('n', '<leader>ui', vim.show_pos, { desc = 'Inspect position' })
vim.keymap.set('n', '<leader>uI', '<cmd>InspectTree<CR>', { desc = 'Inspect tree' })
vim.keymap.set('n', '<leader>un', function()
  require('noice').cmd 'dismiss'
end, { desc = 'Dismiss notifications' })
