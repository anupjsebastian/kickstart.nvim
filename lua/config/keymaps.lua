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

-- Smart cleanup of unnamed buffers - only when they're truly abandoned
-- This runs periodically instead of aggressively on every BufHidden
vim.api.nvim_create_autocmd('FocusGained', {
  desc = 'Clean up abandoned unnamed buffers',
  group = vim.api.nvim_create_augroup('cleanup-unnamed-buffers', { clear = true }),
  callback = function()
    vim.schedule(function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) then
          local bufname = vim.api.nvim_buf_get_name(buf)
          local buftype = vim.bo[buf].buftype
          local modified = vim.bo[buf].modified
          local loaded = vim.api.nvim_buf_is_loaded(buf)
          
          -- Only delete if: unnamed, normal buffer, not modified, not loaded in any window
          if bufname == '' and buftype == '' and not modified and not loaded then
            -- Check if buffer is visible in any window
            local is_visible = false
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_win_get_buf(win) == buf then
                is_visible = true
                break
              end
            end
            
            if not is_visible then
              pcall(vim.api.nvim_buf_delete, buf, { force = false })
            end
          end
        end
      end
    end)
  end,
})

-- Handle the initial [No Name] buffer when opening a real file
-- This ensures clean buffer replacement when starting with `nvim .`
vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Replace initial [No Name] buffer with opened file',
  group = vim.api.nvim_create_augroup('replace-initial-buffer', { clear = true }),
  callback = function(event)
    local new_buf = event.buf
    
    -- Only proceed if this is a real file
    if vim.bo[new_buf].buftype ~= '' or vim.api.nvim_buf_get_name(new_buf) == '' then
      return
    end
    
    -- Look for unnamed buffers that are empty and not visible
    vim.schedule(function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if buf ~= new_buf and vim.api.nvim_buf_is_valid(buf) then
          local bufname = vim.api.nvim_buf_get_name(buf)
          local buftype = vim.bo[buf].buftype
          local modified = vim.bo[buf].modified
          
          if bufname == '' and buftype == '' and not modified then
            -- Check if truly empty
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            local is_empty = #lines == 0 or (#lines == 1 and lines[1] == '')
            
            if is_empty then
              -- Find if this buffer is in a window, and switch it to the new buffer
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_get_buf(win) == buf then
                  pcall(vim.api.nvim_win_set_buf, win, new_buf)
                end
              end
              
              -- Now delete the old buffer
              pcall(vim.api.nvim_buf_delete, buf, { force = true })
            end
          end
        end
      end
    end)
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

-- ========================================================================
-- CODE OPERATIONS (<leader>c)
-- ========================================================================
-- Diagnostic quickfix toggle (works in normal buffers and quickfix itself)
vim.keymap.set('n', '<leader>cq', function()
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

-- Flutter outline toggle (works from any window)
vim.keymap.set('n', '<leader>lfo', function()
  -- First, check if Flutter outline window exists
  local outline_winnr = nil
  
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name:match('FlutterOutline') then
      outline_winnr = win
      break
    end
  end
  
  -- If outline exists, close it
  if outline_winnr then
    vim.api.nvim_win_close(outline_winnr, true)
    return
  end
  
  -- Otherwise, check if we have any Dart buffers open
  local has_dart_buffer = false
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local ft = vim.bo[buf].filetype
      if ft == 'dart' then
        has_dart_buffer = true
        break
      end
    end
  end
  
  -- If we have a Dart buffer, toggle outline
  if has_dart_buffer then
    vim.cmd('FlutterOutlineToggle')
  else
    vim.notify('Flutter outline only available when a Dart file is open', vim.log.levels.INFO)
  end
end, { desc = 'Toggle outline (Dart only)' })

-- ========================================================================
-- GLOBAL FLUTTER COMMANDS (work from any buffer)
-- ========================================================================
-- Commands always execute - notifications indicate if app is detected running
-- This prevents false negatives from buffer detection issues
-- ========================================================================
-- Helper function to check if Flutter app is running
-- Checks multiple patterns since buffer names/states may vary over time
local function is_flutter_running()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    -- Check if buffer exists (valid and not wiped)
    if vim.api.nvim_buf_is_valid(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      -- Match various Flutter buffer patterns
      -- __Flutter_* = flutter-tools.nvim output buffers
      -- *Flutter Run* = alternative Flutter output buffer names
      if name:match('__Flutter') or name:match('Flutter.*Run') then
        return true
      end
      
      -- Also check buffer filetype for Flutter log buffers
      local ok, ft = pcall(vim.api.nvim_buf_get_option, buf, 'filetype')
      if ok and ft == 'log' then
        -- Check if this is a Flutter log by looking at buffer content
        local lines = vim.api.nvim_buf_get_lines(buf, 0, 5, false)
        for _, line in ipairs(lines) do
          if line:match('Flutter') or line:match('flutter') then
            return true
          end
        end
      end
    end
  end
  return false
end

-- Hot reload - always execute, notification based on detection
vim.keymap.set('n', '<leader>lfh', function()
  local running = is_flutter_running()
  vim.cmd('FlutterReload')
  if running then
    vim.notify('󱓞 Hot reload triggered', vim.log.levels.INFO)
  else
    vim.notify('󱓞 Hot reload sent (no running app detected, will work if app is running)', vim.log.levels.WARN)
  end
end, { desc = 'Flutter: Hot reload' })

-- Hot restart - always execute, notification based on detection
vim.keymap.set('n', '<leader>lfR', function()
  local running = is_flutter_running()
  vim.cmd('FlutterRestart')
  if running then
    vim.notify('󱓞 Hot restart triggered', vim.log.levels.INFO)
  else
    vim.notify('󱓞 Hot restart sent (no running app detected, will work if app is running)', vim.log.levels.WARN)
  end
end, { desc = 'Flutter: Hot restart' })

-- Quit - always execute, notification based on detection
vim.keymap.set('n', '<leader>lfq', function()
  local running = is_flutter_running()
  vim.cmd('FlutterQuit')
  if running then
    vim.notify('󱓞 Flutter app stopped', vim.log.levels.INFO)
  else
    vim.notify('󱓞 Quit command sent (no running app detected)', vim.log.levels.WARN)
  end
end, { desc = 'Flutter: Quit app' })

-- Toggle logs with notification
vim.keymap.set('n', '<leader>lfL', function()
  vim.cmd('FlutterLogToggle')
  vim.notify('󱓞 Toggled Flutter logs', vim.log.levels.INFO)
end, { desc = 'Flutter: Toggle logs' })

-- DevTools - open in default browser with URL notification
vim.keymap.set('n', '<leader>lft', function()
  local running = is_flutter_running()
  vim.cmd('FlutterOpenDevTools')
  
  -- Try to find and display the DevTools URL
  vim.defer_fn(function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) then
        local name = vim.api.nvim_buf_get_name(buf)
        if name:match('__Flutter') or name:match('Flutter.*Run') then
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          for _, line in ipairs(lines) do
            local url = line:match('(http://[^%s]+)')
            if url and url:match('devtools') then
              vim.notify(string.format('󱓞 DevTools: %s', url), vim.log.levels.INFO)
              return
            end
          end
        end
      end
    end
  end, 500)
  
  if running then
    vim.notify('󱓞 Opening DevTools...', vim.log.levels.INFO)
  else
    vim.notify('󱓞 DevTools command sent (start Flutter app first if not running)', vim.log.levels.WARN)
  end
end, { desc = 'Flutter: Start DevTools' })

-- Select device (always available)
vim.keymap.set('n', '<leader>lfd', function()
  vim.cmd('FlutterDevices')
  -- Longer timeout for device selection since it takes time to load
  vim.notify('󱓞 Select Device. Loading Flutter devices...', vim.log.levels.INFO, { timeout = 8000 })
end, { desc = 'Flutter: Select device' })

-- Launch emulator (always available)
vim.keymap.set('n', '<leader>lfe', function()
  vim.cmd('FlutterEmulators')
  vim.notify('󱓞 Select emulator to launch', vim.log.levels.INFO)
end, { desc = 'Flutter: Launch emulator' })

-- ========================================================================
-- GLOBAL PYTHON COMMANDS (work from any buffer)
-- ========================================================================
-- These keymaps are always available, allowing you to run Python commands
-- from anywhere (logs, terminals, other files)
-- ========================================================================

-- Helper function to find Python venv (same logic as LSP detection)
local function find_python_venv()
  -- Try to find root directory with .venv
  local root = vim.fs.root(0, { '.venv', 'pyproject.toml', 'setup.py', 'requirements.txt', '.git' })
  if root then
    local venv_python = root .. '/.venv/bin/python'
    if vim.loop.fs_stat(venv_python) then
      return root .. '/.venv', venv_python
    end
  end
  return nil, nil
end

-- Add package with uv
vim.keymap.set('n', '<leader>lpa', function()
  local pkg = vim.fn.input('Package to add: ')
  if pkg ~= '' then
    vim.notify(string.format('󰌠 Adding package: %s...', pkg), vim.log.levels.INFO)
    local result = vim.fn.system('uv add ' .. pkg)
    local exit_code = vim.v.shell_error
    
    if exit_code == 0 then
      vim.notify(string.format('✓ Successfully added: %s', pkg), vim.log.levels.INFO)
    else
      vim.notify(string.format('✗ Failed to add %s:\n%s', pkg, result), vim.log.levels.ERROR)
    end
  end
end, { desc = 'Python: Add package (uv)' })

-- Add dev package with uv
vim.keymap.set('n', '<leader>lpA', function()
  local pkg = vim.fn.input('Dev package to add: ')
  if pkg ~= '' then
    vim.notify(string.format('󰌠 Adding dev package: %s...', pkg), vim.log.levels.INFO)
    local result = vim.fn.system('uv add --dev ' .. pkg)
    local exit_code = vim.v.shell_error
    
    if exit_code == 0 then
      vim.notify(string.format('✓ Successfully added dev package: %s', pkg), vim.log.levels.INFO)
    else
      vim.notify(string.format('✗ Failed to add %s:\n%s', pkg, result), vim.log.levels.ERROR)
    end
  end
end, { desc = 'Python: Add dev package (uv)' })

-- Remove package with uv
vim.keymap.set('n', '<leader>lpd', function()
  local pkg = vim.fn.input('Package to remove: ')
  if pkg ~= '' then
    vim.notify(string.format('󰌠 Removing package: %s...', pkg), vim.log.levels.INFO)
    local result = vim.fn.system('uv remove ' .. pkg)
    local exit_code = vim.v.shell_error
    
    if exit_code == 0 then
      vim.notify(string.format('✓ Successfully removed: %s', pkg), vim.log.levels.INFO)
    else
      vim.notify(string.format('✗ Failed to remove %s:\n%s', pkg, result), vim.log.levels.ERROR)
    end
  end
end, { desc = 'Python: Remove package (uv)' })

-- Sync packages with uv
vim.keymap.set('n', '<leader>lpu', function()
  vim.notify('󰌠 Syncing packages with uv...', vim.log.levels.INFO)
  local result = vim.fn.system('uv sync')
  local exit_code = vim.v.shell_error
  
  if exit_code == 0 then
    vim.notify('✓ Packages synced successfully', vim.log.levels.INFO)
  else
    vim.notify(string.format('✗ Sync failed:\n%s', result), vim.log.levels.ERROR)
  end
end, { desc = 'Python: Sync packages (uv)' })

-- Show venv info (detect from project, not shell env)
vim.keymap.set('n', '<leader>lpv', function()
  local venv_dir, venv_python = find_python_venv()
  if venv_dir then
    local python_version = vim.fn.system(venv_python .. ' --version'):gsub('\n', '')
    vim.notify(string.format('󰌠 Venv: %s\nPython: %s', venv_dir, python_version), vim.log.levels.INFO)
  else
    vim.notify('󰌠 No .venv found in project root', vim.log.levels.WARN)
  end
end, { desc = 'Python: Show venv info' })

-- Run tests with pytest (in new tab)
vim.keymap.set('n', '<leader>lpt', function()
  vim.notify('󰌠 Running tests with pytest...', vim.log.levels.INFO)
  vim.cmd('tabnew | terminal uv run pytest')
  -- Stay in normal mode for easy scrolling/navigation
end, { desc = 'Python: Run tests (pytest)' })

-- Run tests with coverage (in new tab)
vim.keymap.set('n', '<leader>lpc', function()
  vim.notify('󰌠 Running tests with coverage...', vim.log.levels.INFO)
  vim.cmd('tabnew | terminal uv run pytest --cov')
  -- Stay in normal mode for easy scrolling/navigation
end, { desc = 'Python: Run tests with coverage' })

-- Run current Python file (in new tab)
vim.keymap.set('n', '<leader>lpr', function()
  -- Check if we have a custom run command for this session
  if vim.g.python_run_command then
    vim.notify(string.format('󰌠 Running: %s\n💡 Enter INSERT mode then Ctrl-C to kill process', vim.g.python_run_command), vim.log.levels.INFO)
    vim.cmd('tabnew | terminal ' .. vim.g.python_run_command)
  else
    -- Default: run current file
    local current_file = vim.fn.expand('%:p')
    if vim.bo.filetype == 'python' then
      vim.notify(string.format('󰌠 Running: %s\n💡 Enter INSERT mode then Ctrl-C to kill process', vim.fn.expand('%:t')), vim.log.levels.INFO)
      vim.cmd('tabnew | terminal uv run python ' .. vim.fn.shellescape(current_file))
    else
      vim.notify('Not a Python file (use <leader>lpR to set custom command)', vim.log.levels.WARN)
    end
  end
end, { desc = 'Python: Run (or custom command)' })

-- Set/Edit custom run command (persists with session)
vim.keymap.set('n', '<leader>lpR', function()
  local current_cmd = vim.g.python_run_command or 'uv run python %'
  local new_cmd = vim.fn.input({
    prompt = 'Python run command: ',
    default = current_cmd,
  })
  
  -- Only save if user pressed Enter (not escape)
  -- vim.fn.input returns empty string on escape, but also if user deletes everything
  -- So we check if it's different from the default to detect actual changes
  if new_cmd ~= '' and new_cmd ~= current_cmd then
    vim.g.python_run_command = new_cmd
    vim.notify(string.format('✓ Custom run command set:\n%s\n\nUse <leader>lpr to run it', new_cmd), vim.log.levels.INFO)
  elseif new_cmd == current_cmd then
    -- User didn't change anything (or hit escape), do nothing
    vim.notify('No changes made', vim.log.levels.INFO)
  end
end, { desc = 'Python: Set/Edit run command' })

-- Clear/Reset custom run command
vim.keymap.set('n', '<leader>lpX', function()
  if vim.g.python_run_command then
    vim.notify(string.format('✓ Cleared custom command:\n%s\n\nWill use default: uv run python <file>', vim.g.python_run_command), vim.log.levels.INFO)
    vim.g.python_run_command = nil
  else
    vim.notify('No custom command set (already using default)', vim.log.levels.INFO)
  end
end, { desc = 'Python: Clear/Reset run command' })

-- Restart Python LSP
vim.keymap.set('n', '<leader>lpl', function()
  vim.cmd('LspRestart pyright')
  vim.notify('󰌠 Restarting pyright LSP...', vim.log.levels.INFO)
end, { desc = 'Python: Restart LSP' })

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
-- WINDOW/TAB OPERATIONS (<leader>w)
-- ========================================================================
-- Window operations
vim.keymap.set('n', '<leader>ww', '<C-w>w', { desc = 'Other window' })
vim.keymap.set('n', '<leader>wc', '<C-w>c', { desc = 'Close window/tab' })
vim.keymap.set('n', '<leader>ws', '<C-w>s', { desc = 'Split window below' })
vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = 'Split window right' })
vim.keymap.set('n', '<leader>wm', '<C-w>_<C-w>|', { desc = 'Maximize window' })
vim.keymap.set('n', '<leader>w=', '<C-w>=', { desc = 'Balance windows' })
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = 'Go to left window' })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = 'Go to lower window' })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = 'Go to upper window' })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = 'Go to right window' })

-- Tab operations (moved from <leader>t to keep toggle menu clean)
vim.keymap.set('n', '<leader>wn', '<cmd>tabnew<CR>', { desc = 'New tab' })
vim.keymap.set('n', '<leader>wo', '<cmd>tabonly<CR>', { desc = 'Close other tabs' })
vim.keymap.set('n', '<leader>w]', '<cmd>tabnext<CR>', { desc = 'Next tab' })
vim.keymap.set('n', '<leader>w[', '<cmd>tabprevious<CR>', { desc = 'Previous tab' })
vim.keymap.set('n', '<leader>w>', '<cmd>tabmove +1<CR>', { desc = 'Move tab right' })
vim.keymap.set('n', '<leader>w<', '<cmd>tabmove -1<CR>', { desc = 'Move tab left' })
vim.keymap.set('n', '<leader>wf', '<cmd>tabfirst<CR>', { desc = 'First tab' })
vim.keymap.set('n', '<leader>wL', '<cmd>tablast<CR>', { desc = 'Last tab' })

-- ========================================================================
-- TOGGLE OPERATIONS (<leader>t)
-- ========================================================================
-- Copilot toggle
vim.keymap.set('n', '<leader>ta', function()
  local status = vim.fn['copilot#Enabled']()
  if status == 1 then
    vim.cmd('Copilot disable')
    vim.notify('Copilot Autocomplete disabled', vim.log.levels.INFO)
  else
    vim.cmd('Copilot enable')
    vim.notify('Copilot Autocomplete enabled', vim.log.levels.INFO)
  end
end, { desc = 'Toggle Copilot [A]utocomplete' })

-- Toggle relative line numbers
vim.keymap.set('n', '<leader>tr', function()
  vim.wo.relativenumber = not vim.wo.relativenumber
  if vim.wo.relativenumber then
    vim.notify('Relative line numbers enabled', vim.log.levels.INFO)
  else
    vim.notify('Absolute line numbers enabled', vim.log.levels.INFO)
  end
end, { desc = 'Toggle [R]elative line numbers' })

-- Toggle inline diagnostics virtual text only (keeps gutter signs)
vim.keymap.set('n', '<leader>tv', function()
  local current = vim.diagnostic.config().virtual_text
  if current then
    vim.diagnostic.config({ virtual_text = false })
    vim.notify('Inline diagnostic messages hidden', vim.log.levels.INFO)
  else
    vim.diagnostic.config({ virtual_text = true })
    vim.notify('Inline diagnostic messages shown', vim.log.levels.INFO)
  end
end, { desc = 'Toggle [V]irtual text (inline messages)' })

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
