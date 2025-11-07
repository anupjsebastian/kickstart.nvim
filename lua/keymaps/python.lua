-- ========================================================================
-- PYTHON GLOBAL KEYMAPS - Always available (not buffer-local)
-- ========================================================================
-- Loaded eagerly at startup to make commands available from any buffer
-- This allows you to control Python projects from terminals, logs, etc.
-- ========================================================================

local toolcheck = require 'utils.toolcheck'

-- Helper function to run terminal commands with "Press ENTER to close" prompt
local function run_terminal_cmd(cmd)
  vim.cmd('split')
  vim.cmd('wincmd J') -- Move split to bottom
  vim.cmd('resize 15') -- Set height to 15 lines
  vim.cmd('enew') -- Create empty buffer
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
    on_exit = function(_, exit_code)
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

-- Auto-reload Python project files when they change externally
-- This handles: uv add/remove from terminal, manual edits, git operations, etc.
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  pattern = { 'pyproject.toml', 'uv.lock', 'requirements*.txt', 'setup.py', 'setup.cfg' },
  callback = function(args)
    local filename = vim.fn.fnamemodify(args.file, ':t')
    vim.notify('📦 ' .. filename .. ' updated automatically', vim.log.levels.INFO)
  end,
  desc = 'Auto-reload Python project files when changed externally',
})

-- NOTE: The <leader>lp group is registered globally in editor.lua

-- Initialize new Python project with uv
vim.keymap.set('n', '<leader>lpi', function()
  if not toolcheck.check_uv() then
    return
  end
  run_terminal_cmd 'uv init'
  vim.notify('🐍 Initializing Python project (creates pyproject.toml)...', vim.log.levels.INFO)
end, { desc = 'Init project (uv)' })

-- Add dependency to project
vim.keymap.set('n', '<leader>lpa', function()
  if not toolcheck.check_uv() then
    return
  end
  vim.ui.input({
    prompt = 'Enter package name(s) to add: ',
  }, function(input)
    if input and input ~= '' then
      -- Open terminal and run command
      run_terminal_cmd('uv add ' .. input)
      vim.notify('📦 Adding package: ' .. input, vim.log.levels.INFO)

      -- Auto-reload pyproject.toml and related files after a short delay
      vim.defer_fn(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) then
            local bufname = vim.api.nvim_buf_get_name(buf)
            -- Reload pyproject.toml, uv.lock, requirements files, etc.
            if bufname:match 'pyproject%.toml$' or bufname:match 'uv%.lock$' or bufname:match 'requirements.*%.txt$' then
              vim.api.nvim_buf_call(buf, function()
                -- checktime refreshes buffer from disk if file changed externally
                vim.cmd 'checktime'
              end)
            end
          end
        end
      end, 2000) -- 2 second delay to let command complete
    else
      vim.notify('No package specified', vim.log.levels.WARN)
    end
  end)
end, { desc = 'Add dependency' })

-- Remove dependency from project
vim.keymap.set('n', '<leader>lpA', function()
  if not toolcheck.check_uv() then
    return
  end
  vim.ui.input({
    prompt = 'Enter package name(s) to remove: ',
  }, function(input)
    if input and input ~= '' then
      -- Open terminal and run command
      run_terminal_cmd('uv remove ' .. input)
      vim.notify('🗑️  Removing package: ' .. input, vim.log.levels.INFO)

      -- Auto-reload pyproject.toml and related files after a short delay
      vim.defer_fn(function()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) then
            local bufname = vim.api.nvim_buf_get_name(buf)
            -- Reload pyproject.toml, uv.lock, requirements files, etc.
            if bufname:match 'pyproject%.toml$' or bufname:match 'uv%.lock$' or bufname:match 'requirements.*%.txt$' then
              vim.api.nvim_buf_call(buf, function()
                -- checktime refreshes buffer from disk if file changed externally
                vim.cmd 'checktime'
              end)
            end
          end
        end
      end, 2000) -- 2 second delay to let command complete
    else
      vim.notify('No package specified', vim.log.levels.WARN)
    end
  end)
end, { desc = 'Remove dependency' })

-- Update Python dependencies with uv
vim.keymap.set('n', '<leader>lpu', function()
  if not toolcheck.check_uv() then
    return
  end
  run_terminal_cmd 'uv sync'
  vim.notify('🔄 Updating Python dependencies with uv...', vim.log.levels.INFO)
end, { desc = 'Update deps (uv sync)' })

-- Reload Python environment and LSP (after adding/removing packages)
vim.keymap.set('n', '<leader>lpe', function()
  -- Restart all LSP clients
  vim.cmd 'LspRestart'

  -- Reload all Python buffers to pick up new imports
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local filetype = vim.bo[buf].filetype
      if filetype == 'python' then
        vim.api.nvim_buf_call(buf, function()
          vim.cmd 'edit!'
        end)
      end
    end
  end

  vim.notify('🔄 Reloaded Python environment and LSP', vim.log.levels.INFO)
end, { desc = 'Reload environment & LSP' })

-- View installed packages
vim.keymap.set('n', '<leader>lpv', function()
  if not toolcheck.check_uv() then
    return
  end
  run_terminal_cmd 'uv pip list'
  vim.notify('📦 Viewing installed Python packages...', vim.log.levels.INFO)
end, { desc = 'View packages' })

-- Run Python tests
vim.keymap.set('n', '<leader>lpt', function()
  if not toolcheck.check_uv() then
    return
  end
  run_terminal_cmd 'uv run pytest'
  vim.notify('🧪 Running Python tests...', vim.log.levels.INFO)
end, { desc = 'Run tests' })

-- Check code style (ruff check)
vim.keymap.set('n', '<leader>lpc', function()
  if not toolcheck.check_uv() then
    return
  end
  run_terminal_cmd 'uv run ruff check .'
  vim.notify('🔍 Checking Python code style...', vim.log.levels.INFO)
end, { desc = 'Check style' })

-- Run current Python file with configurable command
vim.keymap.set('n', '<leader>lpr', function()
  if not toolcheck.check_uv() then
    return
  end

  local file = vim.fn.expand '%:p'
  if vim.fn.filereadable(file) == 1 then
    -- Check if there's a custom run command stored
    local custom_cmd = vim.g.python_run_command
    local cmd = custom_cmd and custom_cmd ~= '' and custom_cmd or ('uv run python ' .. vim.fn.shellescape(file))

    -- Check if there's already a running Python terminal buffer
    if vim.g.python_terminal_bufnr and vim.api.nvim_buf_is_valid(vim.g.python_terminal_bufnr) then
      -- Find or create window for existing buffer
      local win = vim.fn.bufwinid(vim.g.python_terminal_bufnr)
      if win == -1 then
        -- Buffer exists but not visible, show it
        vim.cmd('split')
        vim.cmd('wincmd J')
        vim.cmd('resize 15')
        vim.api.nvim_win_set_buf(0, vim.g.python_terminal_bufnr)
      else
        -- Already visible, just focus it
        vim.api.nvim_set_current_win(win)
      end
      vim.notify('📺 Showing existing Python terminal (kill with Ctrl+C)', vim.log.levels.INFO)
      return
    end

    -- Create new terminal buffer
    vim.cmd('split')
    vim.cmd('wincmd J') -- Move split to bottom
    vim.cmd('resize 15') -- Set height to 15 lines
    vim.cmd('enew') -- Create empty buffer
    local bufnr = vim.api.nvim_get_current_buf()
    
    -- Store buffer number globally so we can find it later
    vim.g.python_terminal_bufnr = bufnr

    -- Set buffer options - keep buffer alive when hidden
    vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = bufnr }) -- Hide instead of wipe
    vim.api.nvim_set_option_value('buflisted', false, { buf = bufnr })
    vim.api.nvim_buf_set_name(bufnr, 'Python: ' .. vim.fn.fnamemodify(file, ':t'))

    -- Use terminal API
    local chan = vim.api.nvim_open_term(bufnr, {})
    local job_id = vim.fn.jobstart(cmd, {
      on_stdout = function(_, data)
        if data then
          vim.api.nvim_chan_send(chan, table.concat(data, '\n'))
        end
      end,
      on_stderr = function(_, data)
        if data then
          vim.api.nvim_chan_send(chan, table.concat(data, '\n'))
        end
      end,
      on_exit = function(_, exit_code)
        -- Clean up when process actually exits
        vim.schedule(function()
          vim.g.python_terminal_bufnr = nil
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.api.nvim_buf_delete(bufnr, { force = true })
          end
        end)
      end,
      stdout_buffered = false,
      stderr_buffered = false,
    })
    
    -- Store job ID so we can kill it if needed
    vim.api.nvim_buf_set_var(bufnr, 'python_job_id', job_id)
    
    -- Stay in normal mode
    vim.cmd('stopinsert')

    if custom_cmd and custom_cmd ~= '' then
      vim.notify(string.format('🚀 Running: %s\n(Close window to hide, <leader>lpk to kill)', cmd), vim.log.levels.INFO)
    else
      vim.notify('🚀 Running Python file...\n(Close window to hide, <leader>lpk to kill)', vim.log.levels.INFO)
    end
  else
    vim.notify('❌ No Python file to run', vim.log.levels.ERROR)
  end
end, { desc = 'Run current file' })

-- Kill running Python process
vim.keymap.set('n', '<leader>lpk', function()
  if vim.g.python_terminal_bufnr and vim.api.nvim_buf_is_valid(vim.g.python_terminal_bufnr) then
    local ok, job_id = pcall(vim.api.nvim_buf_get_var, vim.g.python_terminal_bufnr, 'python_job_id')
    if ok and job_id then
      vim.fn.jobstop(job_id)
      vim.notify('🛑 Python process killed', vim.log.levels.INFO)
    end
  else
    vim.notify('No Python process running', vim.log.levels.WARN)
  end
end, { desc = 'Kill running process' })

-- Toggle inlay hints (type annotations)
vim.keymap.set('n', '<leader>lph', function()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].filetype == 'python' then
    local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
    vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
    vim.notify(enabled and '💡 Inlay hints disabled' or '💡 Inlay hints enabled', vim.log.levels.INFO)
  else
    vim.notify('⚠️  Not a Python file', vim.log.levels.WARN)
  end
end, { desc = 'Toggle inlay hints' })

-- Set custom run command (interactive input)
vim.keymap.set('n', '<leader>lpR', function()
  -- Get relative path from cwd (project root)
  local relative_file = vim.fn.expand '%:.'
  local current = vim.g.python_run_command or ('uv run python ' .. vim.fn.shellescape(relative_file))
  vim.ui.input({
    prompt = 'Enter Python run command: ',
    default = current,
  }, function(input)
    if input and input ~= '' then
      vim.g.python_run_command = input
      vim.notify(string.format('✓ Custom run command set:\n%s\n\nUse <leader>lpr to execute', input), vim.log.levels.INFO)
    else
      vim.notify('No changes made to run command', vim.log.levels.INFO)
    end
  end)
end, { desc = 'Set custom run command' })

-- Clear/reset custom run command
vim.keymap.set('n', '<leader>lpC', function()
  if vim.g.python_run_command then
    vim.notify(string.format('✓ Cleared custom command:\n%s\n\nWill use default: uv run python <file>', vim.g.python_run_command), vim.log.levels.INFO)
    vim.g.python_run_command = nil
  else
    vim.notify('No custom command set (already using default)', vim.log.levels.INFO)
  end
end, { desc = 'Clear/reset run command' })

-- Run Python REPL/Shell - Don't auto-close for interactive sessions
vim.keymap.set('n', '<leader>lpS', function()
  if not toolcheck.check_uv() then
    return
  end
  vim.cmd 'tabnew'
  vim.fn.jobstart('uv run python', { pty = true })
  vim.notify('🐍 Starting Python Shell...', vim.log.levels.INFO)
end, { desc = 'Shell (REPL)' })

-- Execute Python code from visual selection
vim.keymap.set('v', '<leader>lpX', function()
  if not toolcheck.check_uv() then
    return
  end
  -- Get visual selection
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local lines = vim.fn.getline(start_pos[2], end_pos[2])
  ---@cast lines string[]

  -- Handle single line selection
  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_pos[3], end_pos[3])
  else
    -- Handle multi-line selection
    lines[1] = string.sub(lines[1], start_pos[3])
    lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
  end

  local code = table.concat(lines, '\n')
  local escaped_code = vim.fn.shellescape(code)
  -- Ensure escaped_code is a string (shellescape can return string or string[])
  if type(escaped_code) == 'table' then
    escaped_code = table.concat(escaped_code, ' ')
  end
  ---@cast escaped_code string
  local command = 'uv run python -c ' .. escaped_code
  run_terminal_cmd(command)
  vim.notify('⚡ Executing Python code...', vim.log.levels.INFO)
end, { desc = 'Execute selection' })

-- Lint and fix with ruff
vim.keymap.set('n', '<leader>lpl', function()
  if not toolcheck.check_uv() then
    return
  end
  run_terminal_cmd 'uv run ruff check --fix .'
  vim.notify('🔧 Linting and fixing Python code...', vim.log.levels.INFO)
end, { desc = 'Lint & fix' })
