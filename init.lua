--[[
=====================================================================
                    NEOVIM CONFIGURATION
=====================================================================
This configuration started from Kickstart.nvim and has been customized
and reorganized into a modular structure.

For help:
  - Run `:Tutor` to learn Neovim basics
  - Run `:help` to access built-in documentation
  - Press `<Space>sh` to search help with Telescope
  - Run `:checkhealth` to diagnose issues
  - See docs/ for detailed documentation

This is YOUR config now! Customize it to your needs.

VSCode Compatibility:
  When running inside VSCode, this config automatically loads a minimal
  VSCode-compatible setup (lua/vscode-config.lua) with only text manipulation
  plugins. See VSCODE-NEOVIM-COMPATIBILITY.md for details.
=====================================================================
--]]

-- ========================================================================
-- VSCODE-NEOVIM COMPATIBILITY CHECK
-- ========================================================================
-- If running inside VSCode, load minimal VSCode-compatible config
if vim.g.vscode then
  require 'vscode-config'
  return
end

-- ========================================================================
-- MODULAR NEOVIM CONFIGURATION
-- ========================================================================
-- This configuration has been organized into modular pieces for clarity
-- and maintainability. Each module handles a specific aspect:
--
--   lua/vscode-config.lua - VSCode-Neovim minimal config (auto-loaded in VSCode)
--
--   lua/config/
--     ├── options.lua           - Vim settings (leader, mouse, clipboard)
--     ├── keymaps.lua           - Global keymaps (window nav, quit, buffer ops)
--     ├── autocmds.lua          - Global autocommands (highlight yank, etc.)
--     ├── lazy.lua              - Plugin manager bootstrap
--     ├── icons.lua             - Icon definitions
--     └── whichkey_builtins.lua - Which-key built-in mappings
--
--   lua/plugins/
--     ├── core/          - Core plugins (always loaded)
--     │   ├── ui.lua             - Colorscheme, lualine, treesitter, mini.nvim
--     │   ├── editor.lua         - Telescope, which-key, guess-indent
--     │   ├── git.lua            - Gitsigns
--     │   ├── completion.lua     - Blink.cmp, snippets, lazydev
--     │   ├── session.lua        - Auto-session (manual restore)
--     │   ├── extras.lua         - Mini.animate, trouble, noice
--     │   ├── neo-tree.lua       - File explorer
--     │   ├── snacks.lua         - Snacks.nvim (dashboard, notifier, etc.)
--     │   ├── cheatsheet.lua     - Custom cheatsheet with 3-level hierarchy
--     │   └── debug.lua          - DAP debugging (nvim-dap, nvim-dap-ui)
--     │
--     ├── ui/            - UI enhancement plugins
--     │   ├── bufferline.lua     - Buffer/tab line with scope.nvim integration
--     │   └── smear-cursor.lua   - Smooth cursor movement animation
--     │
--     ├── lsp/           - LSP infrastructure
--     │   └── init.lua           - LSP config, mason, conform, fidget
--     │
--     └── lang/          - Language-specific (lazy-loaded by filetype)
--         ├── flutter.lua        - Dart/Flutter (ft='dart')
--         ├── python.lua         - Python (ft='python')
--         ├── rust.lua           - Rust (ft='rust')
--         ├── svelte.lua         - Svelte (ft='svelte')
--         └── html.lua           - HTML/CSS/JS (ft='html')
--
--   lua/keymaps/       - Language-specific keymaps (buffer-local)
--     ├── flutter.lua           - Flutter workflow keymaps
--     ├── python.lua            - Python workflow keymaps
--     ├── rust.lua              - Rust workflow keymaps
--     ├── svelte.lua            - Svelte workflow keymaps
--     └── html.lua              - HTML workflow keymaps
--
--   lua/telescope/     - Custom telescope extensions
--     └── buffer_picker.lua     - Enhanced buffer picker
--
--   lua/utils/         - Utility modules
--     ├── init.lua              - General utilities
--     └── toolcheck.lua         - Tool availability checker
--
-- See docs/ for detailed documentation:
--   - getting-started/README.md - Installation and setup
--   - plugins/README.md         - Plugin documentation
--   - keymaps/README.md         - Keymap reference
--   - languages/README.md       - Language-specific guides
--   - VSCODE-NEOVIM-COMPATIBILITY.md - VSCode integration
-- ========================================================================

-- Load core configuration modules
require 'config.options'  -- Vim options and settings
require 'config.keymaps'  -- Global keymaps
require 'config.autocmds' -- Global autocommands
require 'config.lazy'     -- Plugin manager and plugins

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
