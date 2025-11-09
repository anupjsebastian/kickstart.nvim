-- [[ Setting options ]]
-- See `:help vim.opt`
-- See `:help vim.o`
-- See `:help option-list`

-- Set <space> as the leader key
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setup Node.js PATH for plugins like Copilot ]]
-- Add fnm's Node.js to PATH so Neovim can find it
-- This is required for GitHub Copilot and other Node.js based plugins
--
-- NOTE: This only sets up Node.js for plugins. For web development tooling,
-- we use bun (see lua/plugins/lang/svelte.lua for bun commands).
--
-- Only prepend PATH if node isn't already available
if vim.fn.executable('node') == 0 then
    vim.schedule(function()
        local home = vim.env.HOME
        local fnm_node_path = home .. '/.local/share/fnm/aliases/default/bin'

        -- Try to add fnm node to PATH
        if vim.fn.isdirectory(fnm_node_path) == 1 then
            vim.env.PATH = fnm_node_path .. ':' .. vim.env.PATH
            vim.notify('✓ Node.js configured via fnm', vim.log.levels.DEBUG)
        else
            -- Only warn if Copilot is actually installed
            if vim.fn.exists(':Copilot') == 2 then
                vim.notify('⚠ fnm node not found - Copilot may not work', vim.log.levels.WARN)
            end
        end
    end)
end

-- Make line numbers default
vim.o.number = true

-- Enable relative line numbers for easier jumping
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
-- See `:help 'clipboard'`
vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'
vim.o.numberwidth = 4 -- Width of the number column (includes signs)

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.o.timeoutlen = 300

-- Set time to wait for key codes (affects terminal mode escape)
-- Lower value = faster escape from terminal insert mode
vim.o.ttimeoutlen = 10

-- Configure cursor shapes for different modes
-- n-v-c = block in normal, visual, command modes
-- i-ci-ve = thin vertical bar in insert mode
-- r-cr = horizontal bar in replace mode
vim.opt.guicursor = {
    'n-v-c:block',                                  -- Block cursor in normal, visual, command
    'i-ci-ve:ver25',                                -- Thin vertical bar (25% width) in insert
    'r-cr:hor20',                                   -- Horizontal bar (20% height) in replace
    'o:hor50',                                      -- Horizontal bar in operator-pending
    'a:blinkwait700-blinkoff400-blinkon250',        -- Blinking settings
    'sm:block-blinkwait175-blinkoff150-blinkon175', -- Search match
}

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
-- See `:help 'list'` and `:help 'listchars'`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
-- Note: Disabled due to command-line rendering issue (last character hidden)
-- The live preview causes a redraw race condition with the cmdline
vim.o.inccommand = ''

-- Show which line your cursor is on
vim.o.cursorline = true

-- Window separators - visible borders between windows
vim.opt.fillchars = {
    vert = '│',
    horiz = '─',
    horizup = '┴',
    horizdown = '┬',
    vertleft = '┤',
    vertright = '├',
    verthoriz =
    '┼'
}

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- ========================================================================
-- FOLDING CONFIGURATION - For Flutter widgets and code blocks
-- ========================================================================
-- Enable folding based on Treesitter (for Flutter widgets, functions, etc.)
--
-- NOTE: This is the GLOBAL folding configuration.
-- Language-specific configs (e.g., flutter.lua) may override these settings
-- with autocmds for specific filetypes. The language-specific settings take
-- precedence when you open files of that type.
--
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'

-- Start with all folds open (don't fold on file open)
vim.o.foldenable = false

-- Set fold level (higher = more unfolded by default)
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

-- Show first line of fold (modern, clean look)
vim.o.foldtext = ''

-- Hide fold column globally (saves space, folds still work with za/zc/zo)
-- Set to '1' if you want the fold column back
vim.o.foldcolumn = '0'

-- Folding keymaps:
--   za - Toggle fold under cursor
--   zc - Close fold under cursor
--   zo - Open fold under cursor
--   zM - Close all folds
--   zR - Open all folds
--   zj - Move to next fold
--   zk - Move to previous fold
