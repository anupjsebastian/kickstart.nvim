-- ============================================================================
-- UTILITY FUNCTIONS - Error Handling, Safe Requires, Helpers
-- ============================================================================
-- Reusable utility functions for cleaner, more robust code
-- ============================================================================

local M = {}

-- ============================================================================
-- SAFE REQUIRE - Load modules with error handling
-- ============================================================================
-- Safely require a module without crashing if it doesn't exist
-- @param module string: Module name to require
-- @param opts table: Options { silent = boolean, error_msg = string }
-- @return module or nil
--
-- Example:
--   local lspconfig = safe_require('lspconfig')
--   if lspconfig then
--     lspconfig.setup()
--   end
function M.safe_require(module, opts)
    opts = opts or {}
    local ok, result = pcall(require, module)
    if not ok then
        if not opts.silent then
            local msg = opts.error_msg or ('Failed to load module: ' .. module)
            vim.notify(msg, vim.log.levels.ERROR)
        end
        return nil
    end
    return result
end

-- ============================================================================
-- SAFE CALL - Wrap function calls with error handling
-- ============================================================================
-- Wrap a function to catch errors and optionally notify user
-- @param fn function: Function to wrap
-- @param opts table: Options { silent = boolean, error_msg = string, on_error = function }
-- @return wrapped function
--
-- Example:
--   local safe_format = safe_call(function()
--     vim.lsp.buf.format()
--   end, { error_msg = 'Failed to format buffer' })
--   safe_format()
function M.safe_call(fn, opts)
    opts = opts or {}
    return function(...)
        local ok, err = pcall(fn, ...)
        if not ok then
            if not opts.silent then
                local msg = opts.error_msg or ('Operation failed: ' .. tostring(err))
                vim.notify(msg, vim.log.levels.ERROR)
            end
            if opts.on_error then
                opts.on_error(err)
            end
        end
        return ok, err
    end
end

-- ============================================================================
-- TRY CATCH - Try/catch style error handling
-- ============================================================================
-- Provides try/catch style error handling for Lua
-- @param try_fn function: Function to try
-- @param catch_fn function: Function to call on error (receives error message)
-- @param finally_fn function: Optional function to always run after
--
-- Example:
--   try_catch(
--     function() vim.cmd('source invalid.vim') end,
--     function(err) print('Caught error:', err) end,
--     function() print('Cleanup') end
--   )
function M.try_catch(try_fn, catch_fn, finally_fn)
    local ok, err = pcall(try_fn)
    if not ok and catch_fn then
        catch_fn(err)
    end
    if finally_fn then
        finally_fn()
    end
    return ok, err
end

-- ============================================================================
-- SAFE COMMAND - Execute vim command with error handling
-- ============================================================================
-- Safely execute a vim command
-- @param cmd string: Vim command to execute
-- @param opts table: Options { silent = boolean, error_msg = string }
-- @return boolean: success
--
-- Example:
--   safe_command('LspRestart', { error_msg = 'LSP not running' })
function M.safe_command(cmd, opts)
    opts = opts or {}
    local ok, err = pcall(vim.cmd, cmd)
    if not ok then
        if not opts.silent then
            local msg = opts.error_msg or ('Command failed: ' .. cmd .. ' - ' .. tostring(err))
            vim.notify(msg, vim.log.levels.ERROR)
        end
        return false
    end
    return true
end

-- ============================================================================
-- CHECK EXISTS - Check if command, executable, or module exists
-- ============================================================================
-- Check if a command exists
function M.command_exists(cmd)
    return vim.fn.exists(':' .. cmd) == 2
end

-- Check if an executable exists in PATH
function M.executable_exists(exe)
    return vim.fn.executable(exe) == 1
end

-- Check if a module can be required
function M.module_exists(module)
    local ok = pcall(require, module)
    return ok
end

-- ============================================================================
-- DEBOUNCE - Rate limit function calls
-- ============================================================================
-- Debounce a function (only call after delay with no new calls)
-- @param fn function: Function to debounce
-- @param delay number: Delay in milliseconds
-- @return debounced function
--
-- Example:
--   local debounced_save = debounce(function() vim.cmd('write') end, 1000)
--   -- Call multiple times, only executes once after 1 second of inactivity
function M.debounce(fn, delay)
    local timer = vim.loop.new_timer()
    return function(...)
        local args = { ... }
        timer:stop()
        timer:start(
            delay,
            0,
            vim.schedule_wrap(function()
                fn(unpack(args))
            end)
        )
    end
end

-- ============================================================================
-- THROTTLE - Limit function call frequency
-- ============================================================================
-- Throttle a function (call at most once per delay period)
-- @param fn function: Function to throttle
-- @param delay number: Delay in milliseconds
-- @return throttled function
function M.throttle(fn, delay)
    local last_call = 0
    return function(...)
        local now = vim.loop.now()
        if now - last_call >= delay then
            last_call = now
            fn(...)
        end
    end
end

-- ============================================================================
-- FILE UTILITIES
-- ============================================================================
-- Check if file exists
function M.file_exists(path)
    return vim.fn.filereadable(path) == 1
end

-- Check if directory exists
function M.dir_exists(path)
    return vim.fn.isdirectory(path) == 1
end

-- Get file extension
function M.get_extension(filename)
    return filename:match('^.+%.(.+)$')
end

-- ============================================================================
-- TABLE UTILITIES
-- ============================================================================
-- Check if table is empty
function M.is_empty(tbl)
    return next(tbl) == nil
end

-- Deep copy a table
function M.deep_copy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[M.deep_copy(orig_key)] = M.deep_copy(orig_value)
        end
        setmetatable(copy, M.deep_copy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

-- Merge tables (shallow)
function M.merge(...)
    local result = {}
    for _, tbl in ipairs({ ... }) do
        for k, v in pairs(tbl) do
            result[k] = v
        end
    end
    return result
end

-- ============================================================================
-- NOTIFICATION HELPERS
-- ============================================================================
-- Notify with consistent formatting
function M.notify(msg, level, opts)
    level = level or vim.log.levels.INFO
    opts = opts or {}
    vim.notify(msg, level, opts)
end

function M.error(msg, opts)
    M.notify(msg, vim.log.levels.ERROR, opts)
end

function M.warn(msg, opts)
    M.notify(msg, vim.log.levels.WARN, opts)
end

function M.info(msg, opts)
    M.notify(msg, vim.log.levels.INFO, opts)
end

-- ============================================================================
-- KEYMAP HELPERS
-- ============================================================================
-- Set keymap with consistent options
function M.map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false -- default to silent
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- Buffer-local keymap
function M.buf_map(bufnr, mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
end

return M
