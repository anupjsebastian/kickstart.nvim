-- [[ Basic Keymaps ]]
-- See `:help vim.keymap.set()`

-- ========================================================================
-- BUFFER UTILITY COMMANDS
-- ========================================================================
-- Commands for managing unnamed/temporary buffers

-- List all no-name buffers (useful for debugging)
vim.api.nvim_create_user_command('ListNoNameBuffers', function()
  local no_name_bufs = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      local bufname = vim.api.nvim_buf_get_name(buf)
      if bufname == '' then
        local buftype = vim.bo[buf].buftype
        local loaded = vim.api.nvim_buf_is_loaded(buf)
        table.insert(no_name_bufs, {
          bufnr = buf,
          buftype = buftype ~= '' and buftype or 'normal',
          loaded = loaded,
        })
      end
    end
  end
  
  if #no_name_bufs == 0 then
    vim.notify('No unnamed buffers found', vim.log.levels.INFO)
  else
    print('\nUnnamed Buffers:')
    print(string.format('%-8s %-12s %-8s', 'Buffer', 'Type', 'Loaded'))
    print(string.rep('-', 30))
    for _, buf_info in ipairs(no_name_bufs) do
      print(string.format('%-8d %-12s %-8s', 
        buf_info.bufnr, 
        buf_info.buftype, 
        buf_info.loaded and 'yes' or 'no'))
    end
    print(string.format('\nTotal: %d unnamed buffer(s)', #no_name_bufs))
  end
end, { desc = 'List all unnamed buffers' })

-- Manually delete all no-name buffers
vim.api.nvim_create_user_command('DeleteNoNameBuffers', function(opts)
  local deleted = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      local bufname = vim.api.nvim_buf_get_name(buf)
      if bufname == '' then
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
        deleted = deleted + 1
      end
    end
  end
  -- Only notify if called manually with bang (!): :DeleteNoNameBuffers!
  if opts.bang then
    vim.notify(string.format('Deleted %d unnamed buffer(s)', deleted), vim.log.levels.INFO)
  end
end, { desc = 'Delete all unnamed buffers (use ! to show notification)', bang = true })

-- Auto-delete no-name buffers when hidden/unloaded
-- This keeps your buffer list clean from temporary buffers
vim.api.nvim_create_autocmd({ 'BufHidden', 'BufUnload' }, {
  pattern = '*',
  callback = function(args)
    local bufname = vim.api.nvim_buf_get_name(args.buf)
    
    -- Delete if buffer has no name (empty string)
    if bufname == '' and vim.api.nvim_buf_is_valid(args.buf) then
      vim.schedule(function()
        pcall(vim.api.nvim_buf_delete, args.buf, { force = true })
      end)
    end
  end,
})

-- ========================================================================
-- GENERAL KEYMAPS
-- ========================================================================

-- Close floating windows with Escape from anywhere
vim.keymap.set('n', '<Esc>', function()
  -- Get current window and check if it's floating
  local current_win = vim.api.nvim_get_current_win()
  local current_config = vim.api.nvim_win_get_config(current_win)
  
  -- If we're in a floating window, close it
  if current_config.relative ~= '' then
    vim.api.nvim_win_close(current_win, false)
    return
  end
  
  -- Otherwise, close ALL floating windows except notifications
  local closed_any = false
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if win ~= current_win then
      local success, config = pcall(vim.api.nvim_win_get_config, win)
      if success and config.relative and config.relative ~= '' then
        -- Don't close notification windows (they have title with "Notify")
        local is_notification = config.title and type(config.title) == 'table' and 
                                vim.tbl_contains(vim.tbl_flatten(config.title), ' Notify ')
        if not is_notification then
          pcall(vim.api.nvim_win_close, win, false)
          closed_any = true
        end
      end
    end
  end
  
  -- If we didn't close any floating windows, do normal escape behavior
  if not closed_any then
    vim.cmd('nohlsearch')
  end
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

-- Flutter outline toggle (only show for Dart files or when outline exists)
vim.keymap.set('n', '<leader>fo', function()
  -- Check if current buffer is a Dart file or Flutter outline exists
  local current_ft = vim.bo.filetype
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
  elseif current_ft == 'dart' then
    vim.cmd('FlutterOutlineToggle')
  else
    vim.notify('Flutter outline only available for Dart files', vim.log.levels.INFO)
  end
end, { desc = 'Toggle outline (Dart only)' })

-- ========================================================================
-- GLOBAL FLUTTER COMMANDS (available in any buffer when app is running)
-- ========================================================================
-- These work from anywhere - log buffers, other files, etc.
vim.keymap.set('n', '<leader>fh', '<cmd>FlutterReload<cr>', { desc = 'Flutter: Hot reload', silent = true })
vim.keymap.set('n', '<leader>fR', '<cmd>FlutterRestart<cr>', { desc = 'Flutter: Hot restart', silent = true })
vim.keymap.set('n', '<leader>fq', '<cmd>FlutterQuit<cr>', { desc = 'Flutter: Quit app', silent = true })
vim.keymap.set('n', '<leader>fL', '<cmd>FlutterLogToggle<cr>', { desc = 'Flutter: Toggle logs', silent = true })
vim.keymap.set('n', '<leader>ft', '<cmd>FlutterDevTools<cr>', { desc = 'Flutter: Start DevTools', silent = true })
vim.keymap.set('n', '<leader>fd', '<cmd>FlutterDevices<cr>', { desc = 'Flutter: Select device', silent = true })
vim.keymap.set('n', '<leader>fe', '<cmd>FlutterEmulators<cr>', { desc = 'Flutter: Launch emulator', silent = true })


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
-- Quit keymaps - easier ways to close Neovim (using capital Q to avoid conflict with diagnostic quickfix)
-- Session management auto-saves on exit but doesn't auto-restore on startup
-- Use dashboard 's' or <leader>Sr to restore sessions manually
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
-- Smart buffer delete - closes window if it's the only buffer in the window
vim.keymap.set('n', '<leader>bd', function()
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  
  -- Get all windows showing this buffer
  local wins_with_buf = vim.fn.win_findbuf(buf)
  
  -- If only one window shows this buffer, close the window too
  if #wins_with_buf == 1 then
    vim.cmd('close')
  else
    vim.cmd('bd')
  end
end, { desc = 'Delete buffer (& window if last)' })
vim.keymap.set('n', '<leader>bD', '<cmd>bd!<CR>', { desc = 'Delete buffer (force)' })
vim.keymap.set('n', '<leader>bu', '<cmd>bunload<CR>', { desc = 'Unload buffer' })
vim.keymap.set('n', '<leader>bn', '<cmd>bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>bo', '<cmd>%bd|e#|bd#<CR>', { desc = 'Delete other buffers' })

-- ========================================================================
-- WINDOW/TAB OPERATIONS (<leader>w, <leader>t)
-- ========================================================================
-- Window operations
vim.keymap.set('n', '<leader>ww', '<C-w>w', { desc = 'Other window' })
vim.keymap.set('n', '<leader>wc', '<C-w>c', { desc = 'Close window' })
vim.keymap.set('n', '<leader>ws', '<C-w>s', { desc = 'Split window below' })
vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = 'Split window right' })
vim.keymap.set('n', '<leader>wm', '<C-w>_<C-w>|', { desc = 'Maximize window' })
vim.keymap.set('n', '<leader>wn', '<cmd>tabnew<CR>', { desc = 'New window (tab)' })

-- Tab operations
vim.keymap.set('n', '<leader>tn', '<cmd>tabnew<CR>', { desc = 'New tab' })
vim.keymap.set('n', '<leader>tc', '<cmd>tabclose<CR>', { desc = 'Close tab' })
vim.keymap.set('n', '<leader>to', '<cmd>tabonly<CR>', { desc = 'Close other tabs' })
vim.keymap.set('n', '<leader>t]', '<cmd>tabnext<CR>', { desc = 'Next tab' })
vim.keymap.set('n', '<leader>t[', '<cmd>tabprevious<CR>', { desc = 'Previous tab' })
vim.keymap.set('n', '<leader>tf', '<cmd>tabfirst<CR>', { desc = 'First tab' })
vim.keymap.set('n', '<leader>tl', '<cmd>tablast<CR>', { desc = 'Last tab' })
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
