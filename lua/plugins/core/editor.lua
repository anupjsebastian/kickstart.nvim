-- ========================================================================
-- CORE EDITOR PLUGINS
-- ========================================================================
-- Essential editing tools that are always loaded
-- - Telescope: Fuzzy finder
-- - Which-key: Keybinding helper
-- - Neo-tree: File explorer
-- - guess-indent: Auto-detect indentation
-- ========================================================================

return {
    -- Detect tabstop and shiftwidth automatically
    {
        'NMAC427/guess-indent.nvim',
        opts = {
            -- Exclude files with special indentation rules
            filetype_exclude = {
                'dart',     -- dart-vim-plugin handles indentation better
                'markdown', -- Markdown has special indentation (lists, code blocks)
            },
        },
    },

    -- Telescope: Fuzzy finder (files, LSP, etc)
    {
        'nvim-telescope/telescope.nvim',
        event = 'VeryLazy', -- Deferred for faster startup
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function()
                    return vim.fn.executable 'make' == 1
                end,
            },
            { 'nvim-telescope/telescope-ui-select.nvim' },
            { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
        },
        config = function()
            require('telescope').setup {
                defaults = {
                    -- Cleaner path display (truncate long paths)
                    path_display = { 'truncate' },
                    -- Show dynamic preview titles
                    dynamic_preview_title = true,

                    mappings = {
                        i = {
                            -- Navigation (standard Vim/Telescope behavior)
                            ['<C-n>'] = require('telescope.actions').move_selection_next,
                            ['<C-p>'] = require('telescope.actions').move_selection_previous,

                            -- Preview scrolling
                            ['<C-d>'] = require('telescope.actions').preview_scrolling_down,
                            ['<C-u>'] = require('telescope.actions').preview_scrolling_up,

                            -- Open actions (consistent with Neo-tree)
                            ['<CR>'] = require('telescope.actions').select_default,     -- Open in current window
                            ['<C-x>'] = require('telescope.actions').select_horizontal, -- Open in horizontal split
                            ['<C-v>'] = require('telescope.actions').select_vertical,   -- Open in vertical split
                            ['<C-t>'] = require('telescope.actions').select_tab,        -- Open in new tab

                            -- Close
                            ['<C-c>'] = require('telescope.actions').close,
                            ['<Esc>'] = require('telescope.actions').close,

                            -- Cycle history (use j/k for this)
                            ['<C-j>'] = require('telescope.actions').cycle_history_next,
                            ['<C-k>'] = require('telescope.actions').cycle_history_prev,

                            -- Selection
                            ['<Tab>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_worse,
                            ['<S-Tab>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_better,

                            -- Send to quickfix
                            ['<C-q>'] = require('telescope.actions').send_to_qflist + require('telescope.actions').open_qflist,
                            ['<M-q>'] = require('telescope.actions').send_selected_to_qflist + require('telescope.actions').open_qflist,
                        },
                        n = {
                            -- Same mappings in normal mode
                            ['<C-n>'] = require('telescope.actions').move_selection_next,
                            ['<C-p>'] = require('telescope.actions').move_selection_previous,
                            ['<C-d>'] = require('telescope.actions').preview_scrolling_down,
                            ['<C-u>'] = require('telescope.actions').preview_scrolling_up,

                            ['<CR>'] = require('telescope.actions').select_default,
                            ['<C-x>'] = require('telescope.actions').select_horizontal,
                            ['<C-v>'] = require('telescope.actions').select_vertical,
                            ['<C-t>'] = require('telescope.actions').select_tab,

                            ['q'] = require('telescope.actions').close,
                            ['<Esc>'] = require('telescope.actions').close,

                            ['<Tab>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_worse,
                            ['<S-Tab>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_better,

                            ['<C-q>'] = require('telescope.actions').send_to_qflist + require('telescope.actions').open_qflist,
                            ['<M-q>'] = require('telescope.actions').send_selected_to_qflist + require('telescope.actions').open_qflist,

                            -- Vim-like navigation
                            ['j'] = require('telescope.actions').move_selection_next,
                            ['k'] = require('telescope.actions').move_selection_previous,
                            ['gg'] = require('telescope.actions').move_to_top,
                            ['G'] = require('telescope.actions').move_to_bottom,

                            -- Cycle history
                            ['<C-j>'] = require('telescope.actions').cycle_history_next,
                            ['<C-k>'] = require('telescope.actions').cycle_history_prev,

                            ['?'] = require('telescope.actions').which_key, -- Show help
                        },
                    },
                },
                extensions = {
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown(),
                    },
                },
            }

            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')

            local builtin = require 'telescope.builtin'
            vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Help' })
            vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Keymaps' })
            vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Files' })
            vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = 'Select Telescope' })
            vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Current word' })
            vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Grep' })
            vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Diagnostics' })
            vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'Resume' })
            vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = 'Recent files' })

            -- ============================================================================
            -- ENHANCED BUFFER PICKER
            -- ============================================================================
            -- Custom buffer picker with visual indicators
            -- Extracted to: lua/telescope/buffer_picker.lua
            -- ============================================================================
            vim.keymap.set('n', '<leader><leader>', function()
                require('telescope.buffer_picker').pick_buffer()
            end, { desc = 'Find existing buffers' })

            vim.keymap.set('n', '<leader>/', function()
                builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
                    winblend = 10,
                    previewer = false,
                })
            end, { desc = 'Fuzzily search in current buffer' })

            vim.keymap.set('n', '<leader>s/', function()
                builtin.live_grep {
                    grep_open_files = true,
                    prompt_title = 'Live Grep in Open Files',
                }
            end, { desc = 'Grep in open files' })

            vim.keymap.set('n', '<leader>sn', function()
                builtin.find_files { cwd = vim.fn.stdpath 'config' }
            end, { desc = 'Neovim config files' })
        end,
    },

    -- Which-key: Shows pending keybinds
    {
        'folke/which-key.nvim',
        event = 'VeryLazy', -- Deferred for faster startup
        keys = {
            -- Open which-key command palette showing all keymaps
            {
                '<leader>sK',
                function()
                    require('which-key').show({ global = false })
                end,
                desc = 'Which-key command palette',
            },
            -- Open which-key showing only builtin Vim commands (~200 commands)
            -- Note: Scrolling with <C-d>/<C-u> may not work due to smooth scroll plugin interference.
            -- Use <leader>? (Telescope) for a scrollable/searchable alternative.
            {
                '<leader>sb',
                function()
                    local builtins = require('config.whichkey_builtins')
                    local keys = {}

                    -- Collect all keys from builtin command tables
                    for _, item in ipairs(builtins.g_prefix) do
                        table.insert(keys, item[1] or item.lhs)
                    end
                    for _, item in ipairs(builtins.z_prefix) do
                        table.insert(keys, item[1] or item.lhs)
                    end
                    for _, item in ipairs(builtins.bracket_prefix) do
                        table.insert(keys, item[1] or item.lhs)
                    end
                    for _, item in ipairs(builtins.ctrl_w_prefix) do
                        table.insert(keys, item[1] or item.lhs)
                    end
                    for _, item in ipairs(builtins.other_commands) do
                        if item[1] and not item.group then
                            table.insert(keys, item[1] or item.lhs)
                        end
                    end

                    require('which-key').show({ keys = keys, loop = true })
                end,
                desc = 'Builtin Vim commands',
            },
        },
        config = function()
            local wk = require('which-key')

            -- Setup with options
            wk.setup {
                delay = 0,
                preset = "helix",
                triggers = {
                    { "<leader>", mode = { "n", "v" } },
                    { "g",        mode = { "n", "v" } },
                    { "z",        mode = { "n", "v" } },
                    { "[",        mode = { "n", "v" } },
                    { "]",        mode = { "n", "v" } },
                    { "<c-w>",    mode = "n" },
                    { '"',        mode = { "n", "v" } },
                    { "`",        mode = { "n", "v" } },
                    { "'",        mode = { "n", "v" } },
                    -- Explicitly exclude : to prevent which-key from showing
                },
                win = {
                    height = { min = 10, max = 0.99 }, -- Use 99% of screen height
                },
                icons = {
                    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
                    separator = "➜", -- symbol used between a key and it's label
                    group = "+", -- symbol prepended to a group
                    ellipsis = "…",
                    mappings = true, -- Always show icons (we have Nerd Font)
                    rules = false, -- Disable built-in icon rules to use our custom icons
                    -- Setting keys to empty object means use defaults
                    keys = {},
                },
                -- Filter to hide keymaps that won't work in current buffer
                plugins = {
                    presets = {
                        operators = false,    -- adds help for operators like d, y, ...
                        motions = false,      -- adds help for motions
                        text_objects = false, -- help for text objects triggered after entering an operator
                        windows = true,       -- default bindings on <c-w>
                        nav = true,           -- misc bindings to work with windows
                        z = true,             -- bindings for folds, spelling and others prefixed with z
                        g = true,             -- bindings for prefixed with g
                    },
                },
                spec = {
                    -- Core groups with icons
                    { '<leader>b', group = '󰊄 Buffer' },
                    { '<leader>c', group = '󰘦 Code' },
                    { '<leader>cq', desc = '󰁨 Toggle Diagnostic Quickfix' },
                    { '<leader>d', group = '󰃤 Debug' },
                    { '<leader>g', group = '󰊢 Git' },
                    { '<leader>h', group = '󰊢 Git Hunk', mode = { 'n', 'v' } },
                    { '<leader>l', group = '󰗀 Language Tools' }, -- Global language menu
                    { '<leader>L', group = '󰿘 LSP' }, -- LSP commands
                    { '<leader>lf', group = ' Flutter' }, -- Flutter commands (globally accessible)
                    { '<leader>lp', group = '󰌠 Python' }, -- Python commands (globally accessible)
                    { '<leader>lr', group = '󱘗 Rust' }, -- Rust commands (globally accessible)
                    { '<leader>ls', group = ' Svelte' }, -- Svelte commands (globally accessible)
                    { '<leader>lh', group = ' HTML/CSS' }, -- HTML/CSS commands (globally accessible)
                    { '<leader>s', group = '󰍉 Search' },
                    { '<leader>sb', desc = '󰘖 Builtin Vim commands' },
                    { '<leader>sK', desc = '󰌨 Which-key command palette' },
                    { '<leader>S', group = '󱂬 Session' },
                    { '<leader>t', group = '󰔡 Toggle Options' },
                    { '<leader>u', group = '󰙵 UI' },
                    { '<leader>w', group = '󰖲 Window' },
                    { '<leader>x', group = '󱖫 Diagnostics' },

                    -- Special standalone keymaps (not part of a group)
                    { '<leader>Q', desc = '󰗼 Quit All' },
                    { '<leader>/', desc = '󰱼 Fuzzy Search in Buffer' },
                    { '<leader><leader>', desc = '󰈙 Find Buffers' },
                    { '<leader>?', desc = '󰘳 Search Keymaps' },
                    { '<leader>.', desc = '󰌵 Code Actions', mode = { 'n', 'v' } },

                    -- Bracket motions (Vim defaults + snacks)
                    { ']', group = '󰜴 Next' },
                    { '[', group = '󰜱 Previous' },
                    { ']]', desc = '󱡁 Next Word Occurrence (snacks.words)' },
                    { '[[', desc = '󱡁 Prev Word Occurrence (snacks.words)' },
                    { ']s', desc = '󰓆 Next Misspelled Word (spell)' },
                    { '[s', desc = '󰓆 Prev Misspelled Word (spell)' },
                    { ']c', desc = '󰊢 Next Git Change (gitsigns)' },
                    { '[c', desc = '󰊢 Prev Git Change (gitsigns)' },
                    { ']d', desc = '󱖫 Next Diagnostic (LSP)' },
                    { '[d', desc = '󱖫 Prev Diagnostic (LSP)' },
                    { ']h', desc = '󰊢 Next Git Hunk (gitsigns)' },
                    { '[h', desc = '󰊢 Prev Git Hunk (gitsigns)' },

                    -- Vim argument list navigation (files passed to nvim: nvim file1.txt file2.txt)
                    { ']a', desc = '󰈔 Next Arg (:next)' },
                    { '[a', desc = '󰈔 Prev Arg (:prev)' },
                    { ']A', desc = '󰈔 Last Arg (:last)' },
                    { '[A', desc = '󰈔 First Arg (:first)' },

                    -- Buffer navigation (opened files in buffer list)
                    { ']b', desc = '󰊄 Next Buffer (:bnext)' },
                    { '[b', desc = '󰊄 Prev Buffer (:bprev)' },
                    { ']B', desc = '󰊄 Last Buffer (:blast)' },
                    { '[B', desc = '󰊄 First Buffer (:bfirst)' },

                    -- Location list navigation (window-local list: LSP locations, :lvimgrep results)
                    { ']l', desc = '󱖫 Next Location (:lnfile)' },
                    { '[l', desc = '󱖫 Prev Location (:lpfile)' },
                    { ']L', desc = '󱖫 Last Location (:llast)' },
                    { '[L', desc = '󱖫 First Location (:lfirst)' },

                    -- Quickfix list navigation (global list: :grep results, :make errors, :vimgrep)
                    { ']q', desc = '󰁨 Next Quickfix (:cnfile)' },
                    { '[q', desc = '󰁨 Prev Quickfix (:cpfile)' },
                    { ']Q', desc = '󰁨 Last Quickfix (:clast)' },
                    { '[Q', desc = '󰁨 First Quickfix (:cfirst)' },

                    -- Tag navigation (ctags stack: :tjump results, definition jumps)
                    { ']t', desc = '󰓹 Next Tag (:tnext)' },
                    { '[t', desc = '󰓹 Prev Tag (:tprev)' },
                    { ']T', desc = '󰓹 Last Tag (:tlast)' },
                    { '[T', desc = '󰓹 First Tag (:tfirst)' },
                },
            }

            -- Load built-in vim command labels (g, z, ctrl-w, etc.)
            require('config.whichkey_builtins').setup()
        end,
    },

    -- Neo-tree: File explorer
    -- Imported from kickstart/plugins/neo-tree.lua
}
