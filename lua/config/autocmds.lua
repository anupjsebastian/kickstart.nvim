-- Override diagnostic virtual_text handler to filter out TODO-like diagnostics
do
    local todo_keywords = { 'TODO', 'FIXME', 'HACK', 'NOTE', 'BUG', 'FIXIT', 'ISSUE', 'WARNING', 'XXX', 'OPTIM', 'PERFORMANCE', 'OPTIMIZE', 'INFO' }
    local function is_todo_diagnostic(diagnostic)
        local msg = diagnostic.message or ''
        for _, kw in ipairs(todo_keywords) do
            if msg:find(kw) then return true end
        end
        return false
    end
    local orig_virtual_text = vim.diagnostic.handlers.virtual_text
    vim.diagnostic.handlers.virtual_text = {
        show = function(ns, bufnr, diagnostics, opts)
            local filtered = {}
            for _, d in ipairs(diagnostics) do
                if not is_todo_diagnostic(d) then
                    table.insert(filtered, d)
                end
            end
            orig_virtual_text.show(ns, bufnr, filtered, opts)
        end,
        hide = orig_virtual_text.hide,
    }
end
-- [[ Basic Autocommands ]]
-- See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
-- Try it with `yap` in normal mode
-- See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.hl.on_yank({ higroup = 'IncSearch', timeout = 150 })
    end,
})

-- Highlight active window borders and modified indicators
vim.api.nvim_create_autocmd('ColorScheme', {
    desc = 'Set window border and modified indicator colors',
    group = vim.api.nvim_create_augroup('window-border-colors', { clear = true }),
    callback = function()
        -- Active window border - bright blue
        vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#7aa2f7', bold = true })
        -- You can also use: '#bb9af7' (purple), '#9ece6a' (green), '#f7768e' (red)


        -- Set consistent modified indicator colors across all components
        -- Link to DiagnosticWarn for a consistent orange/yellow color
        vim.api.nvim_set_hl(0, 'BufferLineModified', { link = 'DiagnosticWarn' })
        vim.api.nvim_set_hl(0, 'BufferLineModifiedVisible', { link = 'DiagnosticWarn' })
        vim.api.nvim_set_hl(0, 'BufferLineModifiedSelected', { link = 'DiagnosticWarn', bold = true })
        vim.api.nvim_set_hl(0, 'NeoTreeModified', { link = 'DiagnosticWarn' })
    end,
})

-- Trigger the highlight setup immediately
vim.cmd('doautocmd ColorScheme')

-- Ensure focus starts in the editor, not file tree
vim.api.nvim_create_autocmd('VimEnter', {
    desc = 'Focus editor window on startup, not Neo-tree',
    group = vim.api.nvim_create_augroup('kickstart-focus-editor', { clear = true }),
    callback = function()
        -- Wait a bit for plugins to load, then focus first non-special buffer
        vim.defer_fn(function()
            -- Find the first normal buffer window
            for _, win in ipairs(vim.api.nvim_list_wins()) do
                local buf = vim.api.nvim_win_get_buf(win)
                local buftype = vim.bo[buf].buftype
                local filetype = vim.bo[buf].filetype
                -- Skip special buffers like neo-tree, terminal, etc.
                if buftype == '' and filetype ~= 'neo-tree' then
                    vim.api.nvim_set_current_win(win)
                    break
                end
            end
        end, 50) -- 50ms delay to let plugins initialize
    end,
})

-- Macro recording notifications
-- Shows a visual notification when you start/stop recording macros
vim.api.nvim_create_autocmd('RecordingEnter', {
    desc = 'Show notification when macro recording starts',
    group = vim.api.nvim_create_augroup('macro-recording-notifications', { clear = true }),
    callback = function()
        local reg = vim.fn.reg_recording()
        vim.notify('󰑊 Recording macro @' .. reg, vim.log.levels.INFO, {
            title = 'Macro Recording',
            timeout = 1000,
        })
    end,
})

vim.api.nvim_create_autocmd('RecordingLeave', {
    desc = 'Show notification when macro recording stops',
    group = vim.api.nvim_create_augroup('macro-recording-notifications', { clear = false }),
    callback = function()
        vim.notify('󰚌 Macro recording stopped', vim.log.levels.INFO, {
            title = 'Macro Recording',
            timeout = 1000,
        })
    end,
})

-- Configure diagnostic signs with nicer icons
-- Must be set early, before LSP attaches
vim.diagnostic.config({
        signs = {
                text = {
                        [vim.diagnostic.severity.ERROR] = '󰅚 ',
                        [vim.diagnostic.severity.WARN] = '󰀪 ',
                        [vim.diagnostic.severity.HINT] = '󰌶 ',
                        [vim.diagnostic.severity.INFO] = '󰋽 ',
                },
        },
        virtual_text = {
                spacing = 4,
                source = 'if_many',
                prefix = '●',
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
})

-- Command to restart Python LSP (useful when switching projects/venvs)
vim.api.nvim_create_user_command('PythonRestart', function()
    local clients = vim.lsp.get_clients { name = 'pyright' }
    for _, client in ipairs(clients) do
        vim.lsp.stop_client(client.id, true)
    end
    vim.notify('Pyright stopped. It will restart on next edit.', vim.log.levels.INFO)
end, { desc = 'Restart Python LSP (pyright)' })
