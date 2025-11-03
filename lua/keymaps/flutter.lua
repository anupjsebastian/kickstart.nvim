-- ========================================================================
-- FLUTTER GLOBAL KEYMAPS - Terminal-based Flutter workflow
-- ========================================================================
-- Loaded eagerly at startup to make Flutter commands available from any buffer
-- Uses terminal commands instead of flutter-tools.nvim for better control
-- Supports hot reload from anywhere via channel communication
-- ========================================================================

local toolcheck = require('utils.toolcheck')

-- NOTE: The <leader>lf group is registered globally in editor.lua

-- Initialize global variables
vim.g.flutter_terminal_chan = nil -- Terminal job channel ID
vim.g.flutter_terminal_buf = nil -- Terminal buffer number
vim.g.flutter_terminal_tab = nil -- Terminal tab number
vim.g.flutter_device_id = nil -- Selected device ID
vim.g.flutter_auto_reload = true -- Auto-reload on save (enabled by default)

-- ========================================================================
-- HELPER: Run one-shot Flutter commands with "Press ENTER to close" pattern
-- ========================================================================
local function run_flutter_terminal_cmd(cmd)
  vim.cmd('tabnew')
  local wrapped_cmd = string.format(
    '%s; echo "\\n---"; if [ $? -eq 0 ]; then echo "✓ Command completed successfully"; else echo "✗ Command failed with exit code $?"; fi; echo "Press ENTER to close"; read; exit',
    cmd
  )

  local bufnr = vim.api.nvim_get_current_buf()
  vim.fn.termopen({ 'zsh', '-c', wrapped_cmd })

  vim.api.nvim_create_autocmd('TermClose', {
    buffer = bufnr,
    once = true,
    callback = function()
      vim.cmd('bdelete!')
    end,
  })

  vim.defer_fn(function()
    vim.cmd('startinsert')
  end, 100)
end

-- ========================================================================
-- HELPER: Select Flutter device
-- ========================================================================
local function select_flutter_device(callback)
  if not toolcheck.check_flutter() then
    return
  end

  vim.notify('Loading Flutter devices (attached only)...', vim.log.levels.INFO)

  -- Run flutter devices with attached-only connection
  vim.fn.jobstart({ 'flutter', 'devices', '--device-connection=attached' }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if not data then
        return
      end

      -- Parse device list
      -- Format: "Device Name • device-id • platform • platform-version"
      local devices = {}
      for _, line in ipairs(data) do
        -- Match lines with device info (contains bullet point •)
        local name, id = line:match('([^•]+)•%s*([^•]+)•')
        if name and id then
          name = vim.trim(name)
          id = vim.trim(id)
          table.insert(devices, {
            name = name,
            id = id,
            display = string.format('%s (%s)', name, id),
          })
        end
      end

      if #devices == 0 then
        vim.notify('No attached devices found. Connect a device or start an emulator.', vim.log.levels.WARN)
        return
      end

      -- Show device picker
      local choices = {}
      for _, device in ipairs(devices) do
        table.insert(choices, device.display)
      end

      vim.schedule(function()
        vim.ui.select(choices, {
          prompt = 'Select Flutter device:',
        }, function(_, idx)
          if idx then
            vim.g.flutter_device_id = devices[idx].id
            vim.notify('Device selected: ' .. devices[idx].name, vim.log.levels.INFO)
            if callback then
              callback(devices[idx].id)
            end
          end
        end)
      end)
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        -- Filter out empty lines and common informational messages
        local errors = {}
        for _, line in ipairs(data) do
          if line and line ~= '' and not line:match('^%s*$') then
            -- Skip common informational messages that go to stderr
            if not line:match('Checking for wireless devices') 
               and not line:match('Connected device') 
               and not line:match('Flutter')
               and not line:match('Dart')
               and not line:match('Channel') then
              table.insert(errors, line)
            end
          end
        end
        
        -- Only show error if there are actual error messages
        if #errors > 0 then
          vim.schedule(function()
            vim.notify('Error getting devices: ' .. table.concat(errors, '\n'), vim.log.levels.ERROR)
          end)
        end
      end
    end,
  })
end

-- ========================================================================
-- HELPER: Find and reconnect to Flutter terminal (for session restore)
-- ========================================================================
local function find_flutter_terminal()
  -- If we already have a channel stored, try to verify it's still valid
  if vim.g.flutter_terminal_chan then
    -- Check if the buffer associated with this channel still exists and is a terminal
    if vim.g.flutter_terminal_buf and vim.api.nvim_buf_is_valid(vim.g.flutter_terminal_buf) then
      local ok, chan = pcall(vim.api.nvim_buf_get_var, vim.g.flutter_terminal_buf, 'terminal_job_id')
      if ok and chan == vim.g.flutter_terminal_chan then
        return vim.g.flutter_terminal_chan
      end
    end
  end

  -- Search for Flutter terminal buffer
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == 'terminal' then
      local bufname = vim.api.nvim_buf_get_name(buf)
      -- Check if it's a terminal buffer with flutter running
      if bufname:match('term://.*flutter') then
        local ok, chan = pcall(vim.api.nvim_buf_get_var, buf, 'terminal_job_id')
        if ok and chan then
          -- Reconnect to this terminal
          vim.g.flutter_terminal_chan = chan
          vim.g.flutter_terminal_buf = buf
          return chan
        end
      end
    end
  end

  return nil
end

-- ========================================================================
-- HELPER: Start Flutter run
-- ========================================================================
local function start_flutter_run(device_id)
  vim.cmd('tabnew')
  local bufnr = vim.api.nvim_get_current_buf()

  -- Start Flutter with device
  local chan = vim.fn.termopen(string.format('flutter run -d %s', device_id), {
    on_exit = function(_, exit_code)
      -- Clear global state
      vim.g.flutter_terminal_chan = nil
      vim.g.flutter_terminal_buf = nil
      vim.g.flutter_terminal_tab = nil

      -- Show exit message
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end
        
        local exit_msg = exit_code == 0 and '✓ Flutter app exited successfully' or '✗ Flutter app exited with code ' .. exit_code
        
        -- Try to append message to terminal buffer
        pcall(vim.api.nvim_buf_set_option, bufnr, 'modifiable', true)
        pcall(vim.api.nvim_buf_set_option, bufnr, 'readonly', false)
        local line_count = vim.api.nvim_buf_line_count(bufnr)
        pcall(vim.api.nvim_buf_set_lines, bufnr, line_count, line_count, false, {
          '',
          '---',
          exit_msg,
          'Press i then ENTER to close this window',
        })
        
        -- Show persistent notification that stays until buffer closes
        local notif_id = vim.notify(exit_msg .. ' - Press i then ENTER to close terminal', vim.log.levels.INFO, {
          timeout = false, -- Don't auto-dismiss
          title = 'Flutter',
        })
        
        -- Set up keymap for ENTER in terminal mode to close buffer
        pcall(vim.api.nvim_buf_set_keymap, bufnr, 't', '<CR>', '', {
          callback = function()
            if vim.api.nvim_buf_is_valid(bufnr) then
              vim.cmd('bdelete! ' .. bufnr)
            end
          end,
          noremap = true,
          silent = true,
        })
        
        -- Also dismiss notification when buffer is deleted
        vim.api.nvim_create_autocmd('BufDelete', {
          buffer = bufnr,
          once = true,
          callback = function()
            -- Notification will auto-dismiss when buffer closes
            -- (nvim-notify handles this automatically, no need to manually dismiss)
          end,
        })
      end)
    end,
  })

  -- Store terminal info
  vim.g.flutter_terminal_chan = chan
  vim.g.flutter_terminal_buf = bufnr
  vim.g.flutter_terminal_tab = vim.fn.tabpagenr()

  -- Don't auto-enter insert mode - stay in normal mode
  -- This allows immediate use of leader commands without needing to press Esc
  -- User can press 'i' if they want to interact with terminal

  vim.notify('🚀 Flutter app starting on ' .. device_id, vim.log.levels.INFO)
end
-- ========================================================================
-- FLUTTER RUN - Start Flutter app with device selection
-- ========================================================================
vim.keymap.set('n', '<leader>lfr', function()
  if not toolcheck.check_flutter() then
    return
  end

  -- Check if already running
  if vim.g.flutter_terminal_chan then
    vim.notify('Flutter app already running. Quit first with <leader>lfq', vim.log.levels.WARN)
    return
  end

  -- Select device if not set
  if not vim.g.flutter_device_id then
    select_flutter_device(function(device_id)
      if device_id then
        start_flutter_run(device_id)
      end
    end)
  else
    start_flutter_run(vim.g.flutter_device_id)
  end
end, { desc = 'Flutter: Run app' })

-- ========================================================================
-- HOT RELOAD - Send 'r' to terminal (works from anywhere)
-- ========================================================================
vim.keymap.set('n', '<leader>lfh', function()
  local chan = find_flutter_terminal()
  if not chan then
    vim.notify('No Flutter app running. Start with <leader>lfr', vim.log.levels.WARN)
    return
  end

  vim.api.nvim_chan_send(chan, 'r')
  vim.notify('🔄 Hot reload triggered', vim.log.levels.INFO)
end, { desc = 'Flutter: Hot reload' })

-- ========================================================================
-- HOT RESTART - Send 'R' to terminal (works from anywhere)
-- ========================================================================
vim.keymap.set('n', '<leader>lfR', function()
  local chan = find_flutter_terminal()
  if not chan then
    vim.notify('No Flutter app running', vim.log.levels.WARN)
    return
  end

  vim.api.nvim_chan_send(chan, 'R')
  vim.notify('🔄 Hot restart triggered', vim.log.levels.INFO)
end, { desc = 'Flutter: Hot restart' })

-- ========================================================================
-- QUIT - Send 'q' to terminal (works from anywhere)
-- ========================================================================
vim.keymap.set('n', '<leader>lfq', function()
  local chan = find_flutter_terminal()
  if not chan then
    vim.notify('No Flutter terminal found. Trying to quit anyway...', vim.log.levels.WARN)
    -- Try to find any terminal buffer that might have flutter
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == 'terminal' then
        local ok, job_chan = pcall(vim.api.nvim_buf_get_var, buf, 'terminal_job_id')
        if ok then
          vim.api.nvim_chan_send(job_chan, 'q')
          vim.notify('Sent quit command to terminal', vim.log.levels.INFO)
          return
        end
      end
    end
    vim.notify('No terminal found to quit', vim.log.levels.ERROR)
    return
  end

  vim.api.nvim_chan_send(chan, 'q')
  vim.notify('🛑 Flutter app stopping...', vim.log.levels.INFO)
end, { desc = 'Flutter: Quit app' })

-- ========================================================================
-- AUTO-RELOAD ON SAVE - Silently send 'r' when saving .dart files
-- ========================================================================
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = '*.dart',
  callback = function()
    if vim.g.flutter_auto_reload ~= false then
      local chan = find_flutter_terminal()
      if chan then
        vim.api.nvim_chan_send(chan, 'r')
        -- No notification for auto-reload (silent)
      end
    end
  end,
})

-- ========================================================================
-- TOGGLE AUTO-RELOAD - Enable/disable auto-reload on save
-- ========================================================================
vim.keymap.set('n', '<leader>lfa', function()
  vim.g.flutter_auto_reload = not vim.g.flutter_auto_reload
  local status = vim.g.flutter_auto_reload and 'enabled ✓' or 'disabled ✗'
  vim.notify('Auto-reload on save: ' .. status, vim.log.levels.INFO)
end, { desc = 'Flutter: Toggle auto-reload on save' })

-- ========================================================================
-- SELECT DEVICE - Custom device picker (attached only, no wireless)
-- ========================================================================
vim.keymap.set('n', '<leader>lfd', function()
  select_flutter_device()
end, { desc = 'Flutter: Select device' })

-- ========================================================================
-- LAUNCH EMULATOR - Keep flutter-tools.nvim emulator picker
-- ========================================================================
vim.keymap.set('n', '<leader>lfe', function()
  vim.cmd('FlutterEmulators')
  vim.notify('Select emulator to launch', vim.log.levels.INFO)
end, { desc = 'Flutter: Launch emulator' })

-- ========================================================================
-- RESTART LSP - Keep flutter-tools.nvim LSP restart
-- ========================================================================
vim.keymap.set('n', '<leader>lfl', function()
  vim.cmd('FlutterLspRestart')
  vim.notify('Flutter LSP restarting...', vim.log.levels.INFO)
end, { desc = 'Flutter: Restart LSP' })

-- ========================================================================
-- OPEN DEVTOOLS - Send 'v' command to open DevTools (Flutter opens it automatically)
-- ========================================================================
vim.keymap.set('n', '<leader>lft', function()
  local chan = find_flutter_terminal()
  if not chan then
    vim.notify('No Flutter app running. Start with <leader>lfr first.', vim.log.levels.WARN)
    return
  end

  -- Send 'v' command - Flutter will open DevTools in your default browser
  vim.api.nvim_chan_send(chan, 'v')
  vim.notify('✓ Opening DevTools...', vim.log.levels.INFO)
end, { desc = 'Flutter: Open DevTools' })

-- ========================================================================
-- FLUTTER DOCTOR - Check Flutter installation
-- ========================================================================
vim.keymap.set('n', '<leader>lfD', function()
  if not toolcheck.check_flutter() then
    return
  end
  run_flutter_terminal_cmd('flutter doctor')
end, { desc = 'Flutter: Doctor' })

-- ========================================================================
-- FLUTTER CLEAN - Clean build artifacts
-- ========================================================================
vim.keymap.set('n', '<leader>lfC', function()
  if not toolcheck.check_flutter() then
    return
  end
  run_flutter_terminal_cmd('flutter clean')
end, { desc = 'Flutter: Clean' })

-- ========================================================================
-- FLUTTER PUB GET - Install dependencies
-- ========================================================================
vim.keymap.set('n', '<leader>lfp', function()
  if not toolcheck.check_flutter() then
    return
  end
  run_flutter_terminal_cmd('flutter pub get')
end, { desc = 'Flutter: Pub get' })

-- ========================================================================
-- FLUTTER BUILD - Build with target selection
-- ========================================================================
vim.keymap.set('n', '<leader>lfb', function()
  if not toolcheck.check_flutter() then
    return
  end

  vim.ui.select({ 'apk', 'appbundle', 'ios', 'ipa', 'web', 'macos', 'linux', 'windows' }, {
    prompt = 'Select build target:',
  }, function(choice)
    if choice then
      run_flutter_terminal_cmd('flutter build ' .. choice)
    end
  end)
end, { desc = 'Flutter: Build' })

-- ========================================================================
-- FLUTTER TEST - Run tests
-- ========================================================================
vim.keymap.set('n', '<leader>lfT', function()
  if not toolcheck.check_flutter() then
    return
  end
  run_flutter_terminal_cmd('flutter test')
end, { desc = 'Flutter: Test' })

-- ========================================================================
-- FLUTTER INIT - Create new Flutter project with confirmation
-- ========================================================================
vim.keymap.set('n', '<leader>lfi', function()
  if not toolcheck.check_flutter() then
    return
  end

  vim.ui.select({ 'Yes', 'No' }, {
    prompt = 'Initialize Flutter project in current directory?',
  }, function(choice)
    if choice == 'Yes' then
      run_flutter_terminal_cmd('flutter create .')
    end
  end)
end, { desc = 'Flutter: Init project' })
