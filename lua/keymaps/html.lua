-- ========================================================================
-- HTML/CSS GLOBAL KEYMAPS - Always available (not buffer-local)
-- ========================================================================
-- Loaded eagerly at startup for HTML/CSS workflow commands
-- Available from any buffer for live-server and browser control
-- ========================================================================

local toolcheck = require('utils.toolcheck')

-- NOTE: The <leader>lh group is registered globally in editor.lua

-- Start live-server with auto-reload - Don't auto-close for long-running server
vim.keymap.set('n', '<leader>lhl', function()
  if not toolcheck.check_live_server() then
    return
  end

  -- Build browser flag for live-server
  local browser_flag = ''
  if vim.g.html_browser_preference and vim.g.html_browser_preference ~= 'Default' then
    local browser_map = {
      ['Google Chrome'] = 'google chrome',
      ['Safari'] = 'safari',
      ['Firefox'] = 'firefox',
    }
    local browser_name = browser_map[vim.g.html_browser_preference]
    if browser_name then
      browser_flag = ' --browser="' .. browser_name .. '"'
    end
  end

    -- Create a new terminal buffer for live-server
  vim.cmd('tabnew')
  vim.cmd('setlocal bufhidden=wipe')
  vim.fn.jobstart('live-server' .. browser_flag, { pty = true })
  vim.cmd('startinsert')
  vim.notify(
    '🌐 Live server started in '
      .. (vim.g.html_browser_preference or 'default browser')
      .. '!\n'
      .. 'Auto-reload enabled. Saves will refresh the browser.',
    vim.log.levels.INFO
  )
end, { desc = 'Start live-server' })

-- Set browser preference
vim.keymap.set('n', '<leader>lhb', function()
  local available_browsers = {
    { name = 'Google Chrome', display = ' Google Chrome' },
    { name = 'Safari', display = ' Safari' },
    { name = 'Firefox', display = ' Firefox' },
    { name = 'Default', display = ' System Default' },
  }

  local choices = {}
  for _, browser in ipairs(available_browsers) do
    local marker = (vim.g.html_browser_preference == browser.name) and '✓ ' or '  '
    table.insert(choices, marker .. browser.display)
  end

  vim.ui.select(choices, {
    prompt = 'Select preferred browser for HTML/CSS files:',
  }, function(choice, idx)
    if not choice or not idx then
      return
    end

    vim.g.html_browser_preference = available_browsers[idx].name
    vim.notify(
      '✓ Browser preference set to: ' .. available_browsers[idx].display .. '\n(Persists with session)',
      vim.log.levels.INFO
    )
  end)
end, { desc = 'Set browser preference' })

-- Open current HTML file in preferred browser
vim.keymap.set('n', '<leader>lho', function()
  if vim.bo.filetype ~= 'html' then
    vim.notify('Not an HTML file', vim.log.levels.WARN)
    return
  end

  local filepath = vim.fn.expand('%:p')
  local browser = vim.g.html_browser_preference or 'Default'
  local cmd

  if browser == 'Default' then
    cmd = string.format('open "%s"', filepath)
  else
    cmd = string.format('open -a "%s" "%s"', browser, filepath)
  end

  vim.fn.system(cmd)
  vim.notify('Opened in ' .. browser .. ': ' .. vim.fn.expand('%:t'), vim.log.levels.INFO)
end, { desc = 'Open in browser' })
