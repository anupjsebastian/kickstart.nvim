-- ========================================================================
-- SESSION MANAGEMENT - Auto-save and restore your workspace
-- ========================================================================
--
-- This plugin automatically saves your session (open files, window layout,
-- buffers, etc.) when you quit Neovim and restores it when you reopen
-- the same directory.
--
-- Features:
--   - ✅ Auto-saves session on exit (automatically!)
--   - ⏸️  Manual restore via dashboard 's' or <leader>Sr (no auto-restore on startup)
--   - Saves per-directory (each project has its own session)
--   - Saves open buffers, window splits, cursor positions, and more
--
-- IMPORTANT: Session restore options:
--   1. Press 's' on the dashboard to restore last session
--   2. Use <leader>Sr to restore manually
--   3. Sessions auto-save on exit but don't auto-restore on startup
--
-- This gives you the choice to start fresh or resume your work.
--
-- Keymaps:
--   <leader>Ss - Save session manually
--   <leader>Sr - Restore session manually
--   <leader>Sd - Delete session for current directory
--   <leader>Sf - Find/search all sessions (Telescope)
--
-- Quit keymaps (in init.lua, integrated with auto-session):
--   <leader>Qa - Quit all and save session (most common)
--   <leader>Qq - Force quit all without saving (no session save)
--   <leader>Qw - Save all files, save session, then quit
--
-- WORKFLOW:
--   1. cd into your project directory
--   2. nvim (opens dashboard - press 's' to restore or start fresh!)
--   3. Work on your project
--   4. Quit with <leader>Q or just :qa (auto-saves!)
--   5. Next time: repeat from step 1 - your choice to restore or not!
--
-- PROJECT-SPECIFIC SETTINGS:
--   Instead of saving globals in sessions, use .nvim.lua in project root:
--
--   Example: ~/myproject/.nvim.lua
--   ```lua
--   -- Project-specific Neovim settings
--   vim.g.python_run_command = 'python manage.py runserver'
--   vim.opt_local.tabstop = 4
--   ```
--
--   Neovim automatically sources .nvim.lua when you cd into the directory
--
-- Sessions are saved in: ~/.local/share/nvim/sessions/
-- ========================================================================

return {
  'rmagatti/auto-session',
  lazy = false, -- Load on startup to restore session
  opts = {
    -- Session save/restore options
    auto_session_enabled = true, -- Automatically save sessions on exit
    auto_restore_enabled = false, -- Don't auto-restore - use dashboard 's' or <leader>Sr instead
    auto_save_enabled = true, -- Auto-save session on exit
    auto_session_suppress_dirs = { '~/', '~/Downloads', '/' }, -- Don't save sessions in these dirs
    auto_session_use_git_branch = false, -- One session per directory (not per git branch)

    -- What to save in the session
    auto_session_enable_last_session = false, -- Don't restore last session if not in a project
    auto_session_create_enabled = true, -- Auto-create session on first save

    -- Session options - what to save
    -- Note: Added 'buffers' back for scope.nvim tab-scoped buffer management
    sessionoptions = 'buffers,curdir,folds,help,tabpages,winsize',

    -- Hooks to run before/after session save/restore
    pre_save_cmds = {
      'Neotree close', -- Close Neo-tree before saving session
    },
    post_restore_cmds = {
      'DeleteNoNameBuffers', -- Clean up unnamed buffers after session restore
    },
    -- Save/restore custom variables using auto-session callbacks
    save_extra_cmds = {
      function()
        -- Save Python custom run command if it exists
        if vim.g.python_run_command then
          return [[let g:python_run_command = ']] .. vim.g.python_run_command:gsub("'", "''") .. [[']]
        end
        return ''
      end,
    },

    -- Session lens (Telescope integration for browsing sessions)
    session_lens = {
      load_on_setup = true,
      theme_conf = { border = true },
      previewer = false,
    },
  },
  keys = {
    -- Manual session control (Capital S to avoid conflict with search)
    {
      '<leader>Ss',
      '<cmd>AutoSession save<cr>',
      desc = 'Save',
    },
    {
      '<leader>Sr',
      '<cmd>AutoSession restore<cr>',
      desc = 'Restore',
    },
    {
      '<leader>Sd',
      '<cmd>AutoSession delete<cr>',
      desc = 'Delete',
    },
    {
      '<leader>Sf',
      '<cmd>AutoSession search<cr>',
      desc = 'Find/search',
    },
  },
  config = function(_, opts)
    require('auto-session').setup(opts)

    -- Register with which-key
    require('which-key').add {
      { '<leader>S', group = 'Session' },
      { '<leader>Q', group = 'Quit' },
    }
  end,
}
