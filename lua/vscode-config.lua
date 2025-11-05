--[[
=====================================================================
                    VSCODE-NEOVIM CONFIGURATION
=====================================================================
This configuration is loaded when Neovim is running inside VSCode.
Only essential plugins that work well with VSCode are loaded.

VSCode provides most UI features, so we only need:
  - Text manipulation plugins (comments, autopairs, surround)
  - Treesitter for better syntax understanding
  - Repeat for better operation repetition
=====================================================================
--]]

-- ========================================================================
-- BASIC VIM SETTINGS
-- ========================================================================
-- Set leader key (must be set before any leader keymaps)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Enable case-insensitive searching UNLESS \C or one or more capital letters in search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Bootstrap lazy.nvim (same as regular config)
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- VSCode-compatible plugins only
require('lazy').setup({
  -- Treesitter for better syntax and text objects
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'bash',
          'c',
          'diff',
          'html',
          'lua',
          'luadoc',
          'markdown',
          'markdown_inline',
          'query',
          'vim',
          'vimdoc',
          'python',
          'rust',
          'javascript',
          'typescript',
          'svelte',
          'dart',
        },
        auto_install = true,
        sync_install = false,
        ignore_install = {},
        modules = {},
        highlight = {
          enable = true,
          -- VSCode handles highlighting, but treesitter provides better text objects
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      }
    end,
  },

  -- Better . repeat for plugin operations
  { 'tpope/vim-repeat' },

  -- Mini.nvim modules that work well with VSCode
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better a/i textobjects (function, class, etc.)
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      -- Uses default mini.surround keymaps (sa, sd, sr)
      require('mini.surround').setup()

      -- Auto-pair brackets, quotes, etc.
      require('mini.pairs').setup()
    end,
  },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- VSCode-specific keymaps
local keymap = vim.keymap.set
local vscode = require('vscode')

-- ========================================================================
-- GENERAL KEYMAPS
-- ========================================================================

-- Toggle/Focus file explorer with backslash (match Neovim Neo-tree)
-- Opens sidebar and focuses it (press Ctrl-w l or Ctrl-l to return to editor)
keymap('n', '\\', function()
  vscode.call('workbench.view.explorer')  -- Opens explorer and focuses it
end, { desc = 'Open/Focus file explorer' })

-- Window navigation also works to go back to editor
-- Ctrl-h focuses sidebar, Ctrl-l focuses editor (configured below)

-- ========================================================================
-- FILE EXPLORER OPERATIONS (when focused in sidebar)
-- ========================================================================
-- NOTE: These keymaps are DISABLED because they conflict with Vim operators
-- VSCode explorer has its own keybindings (Enter, Delete, F2, etc.)
-- If you need Vim-style file operations, use leader-based keymaps:
--   <leader>fa = new file
--   <leader>fA = new folder
--   <leader>fd = delete file
--   <leader>fr = rename file

-- Create new file (leader-based, no conflict)
keymap('n', '<leader>fa', function()
  vscode.call('explorer.newFile')
end, { desc = 'Explorer: Add file' })

-- Create new folder (leader-based)
keymap('n', '<leader>fA', function()
  vscode.call('explorer.newFolder')
end, { desc = 'Explorer: Add directory' })

-- Delete file/folder (leader-based, doesn't conflict with 'd' operator)
keymap('n', '<leader>fd', function()
  vscode.call('deleteFile')
end, { desc = 'Explorer: Delete' })

-- Rename file/folder (leader-based)
keymap('n', '<leader>fr', function()
  vscode.call('renameFile')
end, { desc = 'Explorer: Rename' })

-- Copy file/folder (leader-based, doesn't conflict with 'y' yank)
keymap('n', '<leader>fy', function()
  vscode.call('filesExplorer.copy')
end, { desc = 'Explorer: Copy (yank)' })

-- Cut file/folder (leader-based, doesn't conflict with 'x' delete char)
keymap('n', '<leader>fx', function()
  vscode.call('filesExplorer.cut')
end, { desc = 'Explorer: Cut' })

-- Paste file/folder (leader-based, doesn't conflict with 'p' paste)
keymap('n', '<leader>fp', function()
  vscode.call('filesExplorer.paste')
end, { desc = 'Explorer: Paste' })

-- Refresh explorer
keymap('n', 'R', function()
  vscode.call('workbench.files.action.refreshFilesExplorer')
end, { desc = 'Explorer: Refresh' })

-- Toggle hidden files (H like Neo-tree)
keymap('n', 'H', function()
  vscode.call('workbench.action.toggleHiddenFiles')
end, { desc = 'Explorer: Toggle hidden files' })

-- Reveal current file in explorer (like Neo-tree follow_current_file)
keymap('n', '.', function()
  vscode.call('workbench.files.action.showActiveFileInExplorer')
end, { desc = 'Explorer: Reveal active file' })

-- Open file in splits (match Neo-tree <C-x>, <C-v>, <C-t>)
-- Open in horizontal split
keymap('n', '<C-x>', function()
  vscode.call('explorer.openToSide')
end, { desc = 'Explorer: Open in horizontal split' })

-- Open in vertical split
keymap('n', '<C-v>', function()
  vscode.call('workbench.action.splitEditorOrthogonal')
end, { desc = 'Explorer: Open in vertical split' })

-- Open in new editor group (like tab)
keymap('n', '<C-t>', function()
  vscode.call('workbench.action.files.newUntitledFile')
end, { desc = 'Explorer: Open in new group' })

-- Alternative: 'o' to open file (in addition to Enter)
keymap('n', 'o', function()
  vscode.call('list.select')
end, { desc = 'Explorer: Open file' })

-- Close floating windows / clear search (match Neovim behavior)
keymap('n', '<Esc>', function()
  vscode.call('closeFindWidget')
  vscode.call('closeReferenceSearch')
  vscode.call('editor.action.hideHover')
end, { desc = 'Close floating window or clear highlight' })

-- Exit terminal mode (match Neovim)
keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation (match Neovim <C-hjkl>)
keymap('n', '<C-h>', function() vscode.call('workbench.action.navigateLeft') end, { desc = 'Move focus to the left window' })
keymap('n', '<C-l>', function() vscode.call('workbench.action.navigateRight') end, { desc = 'Move focus to the right window' })
keymap('n', '<C-j>', function() vscode.call('workbench.action.navigateDown') end, { desc = 'Move focus to the lower window' })
keymap('n', '<C-k>', function() vscode.call('workbench.action.navigateUp') end, { desc = 'Move focus to the upper window' })

-- ========================================================================
-- QUIT OPERATIONS (<leader>Q)
-- ========================================================================
keymap('n', '<leader>Q', function() vscode.call('workbench.action.quit') end, { desc = 'Quit all' })

-- ========================================================================
-- BUFFER OPERATIONS (<leader>b)
-- ========================================================================
keymap('n', '<leader>bd', function() vscode.call('workbench.action.closeActiveEditor') end, { desc = 'Delete buffer' })
keymap('n', '<leader>bD', function() vscode.call('workbench.action.closeActiveEditor') end, { desc = 'Delete buffer (force)' })
keymap('n', '<leader>bn', function() vscode.call('workbench.action.nextEditor') end, { desc = 'Next buffer' })
keymap('n', '<leader>bp', function() vscode.call('workbench.action.previousEditor') end, { desc = 'Previous buffer' })
keymap('n', '<leader>bo', function() vscode.call('workbench.action.closeOtherEditors') end, { desc = 'Delete other buffers' })
keymap('n', '<leader>bb', function() vscode.call('workbench.action.showAllEditors') end, { desc = 'Pick buffer' })

-- ========================================================================
-- WINDOW/TAB OPERATIONS (<leader>w)
-- ========================================================================
keymap('n', '<leader>ww', function() vscode.call('workbench.action.focusNextGroup') end, { desc = 'Other window' })
keymap('n', '<leader>wc', function() vscode.call('workbench.action.closeEditorsInGroup') end, { desc = 'Close window/workspace' })
keymap('n', '<leader>ws', function() vscode.call('workbench.action.splitEditorDown') end, { desc = 'Split window below' })
keymap('n', '<leader>wv', function() vscode.call('workbench.action.splitEditorRight') end, { desc = 'Split window right' })
keymap('n', '<leader>wh', function() vscode.call('workbench.action.navigateLeft') end, { desc = 'Go to left window' })
keymap('n', '<leader>wj', function() vscode.call('workbench.action.navigateDown') end, { desc = 'Go to lower window' })
keymap('n', '<leader>wk', function() vscode.call('workbench.action.navigateUp') end, { desc = 'Go to upper window' })
keymap('n', '<leader>wl', function() vscode.call('workbench.action.navigateRight') end, { desc = 'Go to right window' })

-- ========================================================================
-- TOGGLE OPERATIONS (<leader>t)
-- ========================================================================
keymap('n', '<leader>tr', function()
  vim.wo.relativenumber = not vim.wo.relativenumber
  if vim.wo.relativenumber then
    vim.notify('Relative line numbers enabled', vim.log.levels.INFO)
  else
    vim.notify('Absolute line numbers enabled', vim.log.levels.INFO)
  end
end, { desc = 'Toggle Relative line numbers' })

-- ========================================================================
-- UI OPERATIONS (<leader>u)
-- ========================================================================
keymap('n', '<leader>ui', function() vscode.call('editor.action.inspectTMScopes') end, { desc = 'Inspect position' })

-- ========================================================================
-- SEARCH OPERATIONS (<leader>s)
-- ========================================================================
keymap('n', '<leader>sf', function() vscode.call('workbench.action.quickOpen') end, { desc = 'Files' })
keymap('n', '<leader>sg', function() vscode.call('workbench.action.findInFiles') end, { desc = 'Grep' })
keymap('n', '<leader>sb', function() vscode.call('workbench.action.showAllEditors') end, { desc = 'Find buffers' })
keymap('n', '<leader>sw', function() vscode.call('editor.action.addSelectionToNextFindMatch') end, { desc = 'Current word' })
keymap('n', '<leader>ss', function() vscode.call('workbench.action.gotoSymbol') end, { desc = 'Select Telescope' })
keymap('n', '<leader>sd', function() vscode.call('workbench.actions.view.problems') end, { desc = 'Diagnostics' })
keymap('n', '<leader>sh', function() vscode.call('workbench.action.showAllSymbols') end, { desc = 'Help' })
keymap('n', '<leader>sk', function() vscode.call('workbench.action.openGlobalKeybindings') end, { desc = 'Keymaps' })
keymap('n', '<leader>sr', function() vscode.call('workbench.action.openRecent') end, { desc = 'Resume' })
keymap('n', '<leader>s.', function() vscode.call('workbench.action.openRecent') end, { desc = 'Recent files' })
keymap('n', '<leader><leader>', function() vscode.call('workbench.action.quickOpen') end, { desc = 'Find buffers' })
keymap('n', '<leader>/', function() vscode.call('editor.action.commentLine') end, { desc = 'Toggle comment line' })

-- ========================================================================
-- CODE OPERATIONS (<leader>c)
-- ========================================================================
keymap('n', '<leader>cq', function() vscode.call('workbench.actions.view.problems') end, { desc = 'Toggle diagnostic quickfix list' })

-- ========================================================================
-- LSP OPERATIONS (gr* prefix)
-- ========================================================================
keymap('n', 'K', function() vscode.call('editor.action.showHover') end, { desc = 'Hover Documentation' })
keymap('n', 'grn', function() vscode.call('editor.action.rename') end, { desc = 'LSP: Rename' })
keymap('n', 'gra', function() vscode.call('editor.action.quickFix') end, { desc = 'LSP: Code Action' })
keymap('x', 'gra', function() vscode.call('editor.action.quickFix') end, { desc = 'LSP: Code Action' })
keymap('n', '<leader>.', function() vscode.call('editor.action.quickFix') end, { desc = 'LSP: Code Actions (VSCode-like)' })
keymap('x', '<leader>.', function() vscode.call('editor.action.quickFix') end, { desc = 'LSP: Code Actions (VSCode-like)' })
keymap('n', 'grr', function() vscode.call('editor.action.goToReferences') end, { desc = 'LSP: References' })
keymap('n', 'gri', function() vscode.call('editor.action.goToImplementation') end, { desc = 'LSP: Implementation' })
keymap('n', 'grd', function() vscode.call('editor.action.revealDefinition') end, { desc = 'LSP: Definition' })
keymap('n', 'grD', function() vscode.call('editor.action.revealDeclaration') end, { desc = 'LSP: Declaration' })
keymap('n', 'gO', function() vscode.call('workbench.action.gotoSymbol') end, { desc = 'LSP: Document Symbols' })
keymap('n', 'gW', function() vscode.call('workbench.action.showAllSymbols') end, { desc = 'LSP: Workspace Symbols' })
keymap('n', 'grt', function() vscode.call('editor.action.goToTypeDefinition') end, { desc = 'LSP: Type Definition' })

-- ========================================================================
-- DIAGNOSTIC OPERATIONS
-- ========================================================================
keymap('n', '[d', function() vscode.call('editor.action.marker.prevInFiles') end, { desc = 'Previous diagnostic' })
keymap('n', ']d', function() vscode.call('editor.action.marker.nextInFiles') end, { desc = 'Next diagnostic' })

-- ========================================================================
-- GIT OPERATIONS (<leader>g, <leader>h)
-- ========================================================================
keymap('n', '<leader>gb', function() vscode.call('gitlens.toggleLineBlame') end, { desc = 'Toggle git blame' })
keymap('n', '<leader>gB', function() vscode.call('git.openFile') end, { desc = 'Git browse' })

-- NOTE: <leader>h (Git Hunk) operations are typically handled by GitLens in VSCode
-- Add hunk keymaps here if needed based on your VSCode extensions

vim.notify('VSCode-Neovim loaded successfully!', vim.log.levels.INFO)
