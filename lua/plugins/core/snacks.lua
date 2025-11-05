-- ========================================================================
-- SNACKS.NVIM - Quality of Life Improvements
-- ========================================================================
-- Collection of small, useful plugins from folke/snacks.nvim
-- Focused on improving everyday Neovim experience with minimal overhead
--
-- Included modules:
--   Core Features:
--   - bufdelete: Delete buffers without breaking layout
--   - rename: LSP-aware file renaming with import updates
--   - scratch: Persistent scratch buffers by context
--   - words: Highlight word under cursor + references
--   - indent: Animated indent guides and scope
--   - animate: Cursor animations and movement trails
--   - gitbrowse: Open files in GitHub/GitLab
--   - gh: GitHub CLI integration
--
--   Polish:
--   - bigfile: Auto-disable features for large files
--   - scroll: Smooth scrolling animations
--   - toggle: Unified toggle system
--   - statuscolumn: Enhanced gutter with git/diagnostics
--   - dashboard: Beautiful startup screen
--   - notifier: Better notifications (compared with Noice)
--
-- Note: Terminal module disabled - using external terminal workflow
-- ========================================================================

return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
        -- ====================================================================
        -- CORE FEATURES
        -- ====================================================================

        -- Better buffer deletion (preserves window layout)
        bufdelete = { enabled = true },

        -- LSP-aware file renaming
        rename = {
            enabled = true,
        },

        -- Terminal management - DISABLED (using external terminal)
        terminal = {
            enabled = false,
        },

        -- Scratch buffers (persistent, context-aware)
        scratch = {
            enabled = true,
            name = 'scratch',
            ft = 'markdown',   -- default filetype
            icon = '󰎞',
            autowrite = true,  -- auto-save on hide
            filekey = {
                cwd = true,    -- separate scratch per directory
                branch = true, -- separate per git branch
                count = true,  -- use vim.v.count1 for multiple scratches
            },
        },

        -- Word reference highlighting
        words = {
            enabled = true,
            debounce = 100, -- ms delay before highlighting
        },

        -- Animated indent guides
        indent = {
            enabled = true,
            animate = {
                enabled = true,
                duration = {
                    step = 20,   -- ms per step
                    total = 200, -- total animation time
                },
            },
            scope = {
                enabled = true, -- highlight current scope
                animate = true,
            },
        },

        -- Git browse (open in GitHub/GitLab/etc)
        gitbrowse = {
            enabled = true,
            open = function(url)
                vim.fn.system({ 'open', url })
            end,
        },

        -- GitHub CLI integration
        gh = {
            enabled = true,
            -- Custom commands can be added here later
        },

        -- ====================================================================
        -- POLISH & QUALITY OF LIFE
        -- ====================================================================

        -- Big file handler (disable features for files >1.5MB)
        bigfile = {
            enabled = true,
            notify = true,
            size = 1.5 * 1024 * 1024, -- 1.5MB
            setup = function()
                -- Disable heavy features for big files
                vim.b.minianimate_disable = true
                vim.cmd('syntax off')
                vim.opt_local.foldmethod = 'manual'
                vim.opt_local.spell = false
            end,
        },

        -- Smooth scrolling
        scroll = {
            enabled = true,
            animate = {
                duration = { step = 15, total = 150 },
                easing = 'outCubic',
            },
        },

        -- Unified toggle system
        toggle = { enabled = true },

        -- Enhanced status column (gutter)
        statuscolumn = {
            enabled = true,
            left = { 'mark', 'sign' }, -- left side of number
            right = { 'fold', 'git' }, -- right side of number
            folds = {
                open = true,           -- show open fold icons
                git_hl = true,         -- use git colors for git signs
            },
            git = {
                patterns = { 'GitSign', 'MiniDiffSign' },
            },
        },

        -- Dashboard (startup screen)
        dashboard = {
            enabled = true,
            sections = {
                { section = 'header' },
                { section = 'keys',  gap = 1, padding = 1 },
                {
                    pane = 2,
                    section = 'recent_files',
                    icon = ' ',
                    title = 'Recent Files',
                    indent = 2,
                    padding = 1,
                },
                {
                    pane = 2,
                    section = 'projects',
                    icon = ' ',
                    title = 'Projects',
                    indent = 2,
                    padding = 1,
                },
                {
                    pane = 2,
                    icon = ' ',
                    title = 'Git Status',
                    section = 'terminal',
                    enabled = function()
                        return vim.fn.isdirectory('.git') == 1
                    end,
                    cmd = 'git status --short --branch',
                    height = 5,
                    padding = 1,
                    indent = 3,
                },
                { section = 'startup' },
            },
            preset = {
                keys = {
                    { icon = ' ', key = 'f', desc = 'Find File', action = ':Telescope find_files' },
                    { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
                    { icon = ' ', key = 'g', desc = 'Find Text', action = ':Telescope live_grep' },
                    { icon = ' ', key = 'r', desc = 'Recent Files', action = ':Telescope oldfiles' },
                    { icon = ' ', key = 'c', desc = 'Config', action = ':e $MYVIMRC' },
                    { icon = ' ', key = 's', desc = 'Restore Session', action = ':AutoSession restore' },
                    { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy' },
                    { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
                },
                header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
        ]],
            },
        },

        -- Notifier (better notifications)
        -- DISABLED: Using noice.nvim for notifications instead (provides cmdline UI + notifications)
        -- Noice provides floating cmdline and better message routing in addition to notifications
        notifier = {
            enabled = false, -- Disabled to prevent conflict with noice.nvim
            timeout = 3000,  -- default timeout in ms
            width = { min = 40, max = 0.4 },
            height = { min = 1, max = 0.6 },
            margin = { top = 0, right = 1, bottom = 0 },
            padding = true,
            sort = { 'level', 'added' },
            icons = {
                error = ' ',
                warn = ' ',
                info = ' ',
                debug = ' ',
                trace = ' ',
            },
            style = 'compact',
        },

        -- ====================================================================
        -- STYLING
        -- ====================================================================
        styles = {
            notification = {
                wo = { wrap = true },
                border = 'rounded',
            },
            scratch = {
                border = 'rounded',
                width = 100,
                height = 30,
                minimal = false,
                position = 'float',
            },
            terminal = {
                border = 'rounded',
                width = 0.8,
                height = 0.8,
                position = 'float',
            },
        },
    },

    -- ====================================================================
    -- KEYMAPS
    -- ====================================================================
    keys = {
        -- Buffer management
        { '<leader>bd', function() require('snacks').bufdelete() end,          desc = 'Delete Buffer (smart)' },
        { '<leader>bo', function() require('snacks').bufdelete.other() end,    desc = 'Delete Other Buffers' },

        -- File operations
        { '<leader>cR', function() require('snacks').rename.rename_file() end, desc = 'Rename File (LSP)' },

        -- Scratch buffers
        { '<leader>bS', function() require('snacks').scratch() end,            desc = 'Toggle Scratch Buffer' },
        { '<leader>bs', function() require('snacks').scratch.select() end,     desc = 'Select Scratch Buffer' },

        -- Git
        { '<leader>gb', function() require('snacks').gitbrowse() end,          desc = 'Git Browse (web)',         mode = { 'n', 'v' } },
        { '<leader>gB', function() require('snacks').git.blame_line() end,     desc = 'Git Blame Line' },

        -- GitHub
        { '<leader>gH', function() require('snacks').gh() end,                 desc = 'GitHub' },
        { '<leader>gI', ':GhIssues<CR>',                                       desc = 'GitHub Issues' },
        { '<leader>gP', ':GhPrs<CR>',                                          desc = 'GitHub PRs' },

        -- Notifications (handled by noice.nvim - keymaps in extras.lua)
        -- Keeping these keymaps as aliases for consistency
        { '<leader>un', function() require('noice').cmd('dismiss') end,        desc = 'Dismiss All Notifications' },
        { '<leader>uh', function() require('noice').cmd('history') end,        desc = 'Notification History' },
        {
            '<leader>us',
            function()
                require('smear_cursor').toggle()
                vim.notify('Smear cursor ' .. (require('smear_cursor').enabled and 'enabled' or 'disabled'),
                    vim.log.levels.INFO)
            end,
            desc = 'Toggle Smear Cursor'
        },

        -- Word references (navigate between word occurrences)
        { ']]',         function() require('snacks').words.jump(vim.v.count1) end,      desc = 'Next word occurrence (snacks)', mode = { 'n', 't' } },
        { '[[',         function() require('snacks').words.jump(-vim.v.count1) end,     desc = 'Prev word occurrence (snacks)', mode = { 'n', 't' } },

        -- Toggles (integrated with which-key)
        { '<leader>td', function() require('snacks').toggle.diagnostics():toggle() end, desc = 'Toggle Diagnostics' },
        { '<leader>tl', function() require('snacks').toggle.line_number():toggle() end, desc = 'Toggle Line Numbers' },
        { '<leader>ts', function() require('snacks').toggle.scroll():toggle() end,      desc = 'Toggle Smooth Scroll' },
        { '<leader>tw', function() require('snacks').toggle.words():toggle() end,       desc = 'Toggle Word Highlights' },
        { '<leader>ti', function() require('snacks').toggle.indent():toggle() end,      desc = 'Toggle Indent Guides' },
    },

    -- ====================================================================
    -- INITIALIZATION
    -- ====================================================================
    init = function()
        -- ================================================================
        -- SNACKS SETUP
        -- ================================================================
        -- Setup vim.notify to use snacks notifier
        vim.api.nvim_create_autocmd('User', {
            pattern = 'VeryLazy',
            callback = function()
                -- Setup some globals for easy access
                _G.dd = function(...)
                    require('snacks').debug.inspect(...)
                end
                _G.bt = function()
                    require('snacks').debug.backtrace()
                end
                vim.print = _G.dd

                -- Override LspRestart to suppress "Invalid server name" errors
                vim.api.nvim_create_user_command('LspRestart', function(opts)
                    -- Get all active clients
                    local clients = vim.lsp.get_clients()

                    if opts.args ~= '' then
                        -- Restart specific server by name
                        local found = false
                        for _, client in ipairs(clients) do
                            if client.name == opts.args then
                                vim.lsp.stop_client(client.id)
                                vim.defer_fn(function()
                                    vim.cmd.edit() -- Trigger LSP attach
                                end, 500)
                                found = true
                                break
                            end
                        end
                        if not found then
                            -- Silently ignore invalid server names (like Copilot)
                            return
                        end
                    else
                        -- Restart all clients
                        for _, client in ipairs(clients) do
                            vim.lsp.stop_client(client.id)
                        end
                        vim.defer_fn(function()
                            vim.cmd.edit() -- Trigger LSP attach for all
                        end, 500)
                    end
                end, {
                    nargs = '?',
                    complete = function()
                        local clients = vim.lsp.get_clients()
                        local names = {}
                        for _, client in ipairs(clients) do
                            table.insert(names, client.name)
                        end
                        return names
                    end,
                    desc = 'Restart LSP clients'
                })

                -- Create commands for GitHub integration
                vim.api.nvim_create_user_command('GhIssues', function()
                    require('snacks').gh.issue()
                end, { desc = 'Open GitHub Issues' })

                vim.api.nvim_create_user_command('GhPrs', function()
                    require('snacks').gh.pr()
                end, { desc = 'Open GitHub PRs' })
            end,
        })
    end,
}
