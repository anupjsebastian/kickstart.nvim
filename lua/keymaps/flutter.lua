-- ========================================================================
-- FLUTTER GLOBAL KEYMAPS - Always available (not buffer-local)
-- ========================================================================
-- Loaded eagerly at startup to make Flutter commands available from any buffer
-- This allows hot reload, quit, device management from terminals, logs, etc.
-- ========================================================================

-- NOTE: The <leader>lf group is registered globally in editor.lua

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
    vim.notify('󱓞 Hot reload sent (no running app detected, will work if app is running)', vm.log.levels.WARN)
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

-- Copy DevTools URL to clipboard
vim.keymap.set('n', '<leader>lfc', function()
  vim.cmd('FlutterCopyProfilerUrl')
  vim.notify('󱓞 DevTools URL copied to clipboard', vim.log.levels.INFO)
end, { desc = 'Flutter: Copy DevTools URL' })

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
