-- ========================================================================
-- PYTHON GLOBAL KEYMAPS - Always available (not buffer-local)
-- ========================================================================
-- Loaded eagerly at startup to make commands available from any buffer
-- This allows you to control Python projects from terminals, logs, etc.
-- ========================================================================

local toolcheck = require('utils.toolcheck')

-- Helper function to run terminal commands with "Press ENTER to close" prompt
local function run_terminal_cmd(cmd)
  vim.cmd('tabnew')
  -- Wrap command to show exit status and wait for Enter, then close buffer
  local wrapped_cmd = string.format(
    '%s; echo "\n---"; if [ $? -eq 0 ]; then echo "✓ Command completed successfully"; else echo "✗ Command failed with exit code $?"; fi; echo "Press ENTER to close"; read; exit',
    cmd
  )
  local job_id = vim.fn.termopen({ 'zsh', '-c', wrapped_cmd })
  
  -- Auto-enter insert mode when job finishes
  vim.api.nvim_create_autocmd('TermClose', {
    buffer = 0,
    once = true,
    callback = function()
      vim.cmd('bdelete!')
    end,
  })
  
  -- Start in insert mode after a delay (let command run first)
  vim.defer_fn(function()
    if vim.api.nvim_get_current_buf() == vim.fn.bufnr('%') then
      vim.cmd('startinsert')
    end
  end, 100)
end

-- NOTE: The <leader>lp group is registered globally in editor.lua

-- Initialize new Python project with uv
vim.keymap.set('n', '<leader>lpi', function()
  if not toolcheck.check_uv() then
    return
  end
  run_terminal_cmd('uv init')
  vim.notify('🐍 Initializing Python project (creates pyproject.toml)...', vim.log.levels.INFO)
end, { desc = 'Python: Init project (uv)' })


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
            if bufname:match('pyproject%.toml$') or 
               bufname:match('uv%.lock$') or 
               bufname:match('requirements.*%.txt$') then
              vim.api.nvim_buf_call(buf, function()
                -- checktime refreshes buffer from disk if file changed externally
                vim.cmd('checktime')
              end)
            end
          end
        end
      end, 2000) -- 2 second delay to let command complete
    else
      vim.notify('No package specified', vim.log.levels.WARN)
    end
  end)
end, { desc = 'Python: Add dependency' })

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
            if bufname:match('pyproject%.toml$') or 
               bufname:match('uv%.lock$') or 
               bufname:match('requirements.*%.txt$') then
              vim.api.nvim_buf_call(buf, function()
                -- checktime refreshes buffer from disk if file changed externally
                vim.cmd('checktime')
              end)
            end
          end
        end
      end, 2000) -- 2 second delay to let command complete
    else
      vim.notify('No package specified', vim.log.levels.WARN)
    end
  end)
end, { desc = 'Python: Remove dependency' })



-- Update Python dependencies with uv
vim.keymap.set('n', '<leader>lpu', function()
  if not toolcheck.check_uv() then
    return
  end
  run_terminal_cmd('uv sync')
  vim.notify('🔄 Updating Python dependencies with uv...', vim.log.levels.INFO)
end, { desc = 'Python: Update deps (uv sync)' })

-- Reload Python environment and LSP (after adding/removing packages)
vim.keymap.set('n', '<leader>lpe', function()
  -- Restart LSP clients for Python files
  vim.cmd('LspRestart')
  
  -- Reload all Python buffers to pick up new imports
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local filetype = vim.api.nvim_buf_get_option(buf, 'filetype')
      if filetype == 'python' then
        vim.api.nvim_buf_call(buf, function()
          vim.cmd('edit!')
        end)
      end
    end
  end
  
  vim.notify('🔄 Reloaded Python environment and LSP', vim.log.levels.INFO)
end, { desc = 'Python: Reload environment & LSP' })

-- View installed packages
vim.keymap.set('n', '<leader>lpv', function()
  if not toolcheck.check_uv() then
    return
  end
  run_terminal_cmd('uv pip list')
  vim.notify('📦 Viewing installed Python packages...', vim.log.levels.INFO)
end, { desc = 'Python: View packages' })


-- Run Python tests
vim.keymap.set('n', '<leader>lpt', function()
  if not toolcheck.check_uv() then
    return
  end
  run_terminal_cmd('uv run pytest')
  vim.notify('🧪 Running Python tests...', vim.log.levels.INFO)
end, { desc = 'Python: Run tests' })

-- Check code style (ruff check)
vim.keymap.set('n', '<leader>lpc', function()
  if not toolcheck.check_uv() then
    return
  end
  run_terminal_cmd('uv run ruff check .')
  vim.notify('🔍 Checking Python code style...', vim.log.levels.INFO)
end, { desc = 'Python: Check style' })

-- Run current Python file with configurable command
vim.keymap.set('n', '<leader>lpr', function()
  if not toolcheck.check_uv() then
    return
  end

  local file = vim.fn.expand('%:p')
  if vim.fn.filereadable(file) == 1 then
    -- Check if there's a custom run command stored
    local custom_cmd = vim.g.python_run_command
    if custom_cmd and custom_cmd ~= '' then
      -- Use custom command (user set via lpR) - Don't auto-close for long-running processes
      vim.cmd('tabnew')
      vim.fn.termopen(custom_cmd)
      vim.notify(string.format('🚀 Running with custom command:\n%s', custom_cmd), vim.log.levels.INFO)
    else
      -- Default: use uv run python <file>
      run_terminal_cmd('uv run python ' .. vim.fn.shellescape(file))
      vim.notify('🚀 Running Python file with uv...', vim.log.levels.INFO)
    end
  else
    vim.notify('❌ No Python file to run', vim.log.levels.ERROR)
  end
end, { desc = 'Python: Run current file' })

-- Set custom run command (interactive input)
vim.keymap.set('n', '<leader>lpR', function()
  local current = vim.g.python_run_command or 'uv run python ' .. vim.fn.shellescape(vim.fn.expand('%:p'))
  vim.ui.input({
    prompt = 'Enter Python run command: ',
    default = current,
  }, function(input)
    if input and input ~= '' then
      vim.g.python_run_command = input
      vim.notify(
        string.format('✓ Custom run command set:\n%s\n\nUse <leader>lpr to execute', input),
        vim.log.levels.INFO
      )
    else
      vim.notify('No changes made to run command', vim.log.levels.INFO)
    end
  end)
end, { desc = 'Python: Set custom run command' })

-- Clear/reset custom run command
vim.keymap.set('n', '<leader>lpC', function()
  if vim.g.python_run_command then
    vim.notify(
      string.format(
        '✓ Cleared custom command:\n%s\n\nWill use default: uv run python <file>',
        vim.g.python_run_command
      ),
      vim.log.levels.INFO
    )
    vim.g.python_run_command = nil
  else
    vim.notify('No custom command set (already using default)', vim.log.levels.INFO)
  end
end, { desc = 'Python: Clear/Reset run command' })

-- Run Python REPL/Shell - Don't auto-close for interactive sessions
vim.keymap.set('n', '<leader>lpS', function()
  if not toolcheck.check_uv() then
    return
  end
  vim.cmd('tabnew')
  vim.fn.termopen('uv run python')
  vim.notify('🐍 Starting Python Shell...', vim.log.levels.INFO)
end, { desc = 'Python: Shell (REPL)' })

-- Execute Python code from visual selection
vim.keymap.set('v', '<leader>lpX', function()
  if not toolcheck.check_uv() then
    return
  end
  -- Get visual selection
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

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
  run_terminal_cmd('uv run python -c ' .. escaped_code)
  vim.notify('⚡ Executing Python code...', vim.log.levels.INFO)
end, { desc = 'Python: Execute selection' })

-- Lint and fix with ruff
vim.keymap.set('n', '<leader>lpl', function()
  if not toolcheck.check_uv() then
    return
  end
  run_terminal_cmd('uv run ruff check --fix .')
  vim.notify('🔧 Linting and fixing Python code...', vm.log.levels.INFO)
end, { desc = 'Python: Lint & fix' })
