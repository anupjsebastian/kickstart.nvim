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

-- NOTE: Automatic buffer cleanup autocommands removed for simplicity.
-- Use manual commands below or snacks.bufdelete() for buffer management.
-- Session management already handles buffer cleanup adequately.

-- ========================================================================
-- GENERAL KEYMAPS
-- ========================================================================

-- Close floating windows with Escape from anywhere
-- Simplified for performance - handles LSP hover (K K then Esc), Telescope, and other floats
vim.keymap.set('n', '<Esc>', function()
    -- Check if we're in Telescope (prompt buffer) - close it directly
    local buftype = vim.bo.buftype
    if buftype == 'prompt' then
        local ok = pcall(require('telescope.actions').close, vim.api.nvim_get_current_buf())
        if ok then return end
    end

    -- Get current window and check if it's floating
    local current_win = vim.api.nvim_get_current_win()
    local config = vim.api.nvim_win_get_config(current_win)

    -- If we're in a floating window (like LSP hover after K K), close it
    if config.relative ~= '' then
        pcall(vim.api.nvim_win_close, current_win, false)
        return
    end

    -- Otherwise close any floating windows (except notifications)
    -- Only iterate if we're NOT already in a float (more performant)
    local closed_any = false
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local success, win_config = pcall(vim.api.nvim_win_get_config, win)
        if success and win_config.relative ~= '' then
            -- Quick filetype check - skip notification windows
            local buf = vim.api.nvim_win_get_buf(win)
            local ft = vim.bo[buf].filetype

            -- Skip noice/notification windows
            if not (ft:match('^noice') or ft == 'notify' or ft == 'snacks_notif') then
                pcall(vim.api.nvim_win_close, win, false)
                closed_any = true
            end
        end
    end

    -- If no floating windows closed, clear search highlight
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
vim.keymap.set('n', '<leader>Q', '<cmd>qa<CR>', { desc = 'Quit all' })

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
vim.keymap.set('n', '<leader>wc', '<C-w>c', { desc = 'Close window/workspace' })
vim.keymap.set('n', '<leader>ws', '<C-w>s', { desc = 'Split window below' })
vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = 'Split window right' })
vim.keymap.set('n', '<leader>wm', '<C-w>_<C-w>|', { desc = 'Maximize window' })
vim.keymap.set('n', '<leader>w=', '<C-w>=', { desc = 'Balance windows' })
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = 'Go to left window' })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = 'Go to lower window' })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = 'Go to upper window' })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = 'Go to right window' })

-- Tab operations (moved from <leader>t to keep toggle menu clean)
vim.keymap.set('n', '<leader>wn', '<cmd>tabnew<CR>', { desc = 'New workspace' })
vim.keymap.set('n', '<leader>wo', '<cmd>tabonly<CR>', { desc = 'Close other workspaces' })
vim.keymap.set('n', '<leader>w]', '<cmd>tabnext<CR>', { desc = 'Next workspace' })
vim.keymap.set('n', '<leader>w[', '<cmd>tabprevious<CR>', { desc = 'Previous workspace' })
vim.keymap.set('n', '<leader>w>', '<cmd>tabmove +1<CR>', { desc = 'Move workspace right' })
vim.keymap.set('n', '<leader>w<', '<cmd>tabmove -1<CR>', { desc = 'Move workspace left' })
vim.keymap.set('n', '<leader>wf', '<cmd>tabfirst<CR>', { desc = 'First workspace' })
vim.keymap.set('n', '<leader>wL', '<cmd>tablast<CR>', { desc = 'Last workspace' })

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
end, { desc = 'Toggle Copilot Autocomplete' })

-- Toggle relative line numbers
vim.keymap.set('n', '<leader>tr', function()
    vim.wo.relativenumber = not vim.wo.relativenumber
    if vim.wo.relativenumber then
        vim.notify('Relative line numbers enabled', vim.log.levels.INFO)
    else
        vim.notify('Absolute line numbers enabled', vim.log.levels.INFO)
    end
end, { desc = 'Toggle Relative line numbers' })

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
end, { desc = 'Toggle Virtual text (inline messages)' })

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
