-- ========================================================================
-- HTML/CSS PROFILE - Language-specific plugins and global workflow
-- ========================================================================
--
-- This file contains all HTML/CSS-specific plugins and configurations.
-- Includes:
--   - HTML/CSS LSP servers
--   - Browser management and live-server workflow
--   - Global keymaps for browser control
--
-- Usage: Keymaps are globally available, plugins load on .html/.css files
-- ========================================================================

-- Load HTML/CSS keymaps immediately (not buffer-local, always available)
require('keymaps.html')

return {
  -- ========================================================================
  -- HTML/CSS LSP - Language Server Protocol
  -- ========================================================================
  -- Provides intelligent code completion, diagnostics for HTML/CSS
  -- ========================================================================
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    ft = { 'html', 'css' },
    opts = {
      ensure_installed = {
        'html-lsp',  -- HTML language server
        'css-lsp',   -- CSS language server
      },
    },
  },

  -- ========================================================================
  -- HTML/CSS BROWSER PREFERENCE - Session persistence
  -- ========================================================================
  -- Initialize browser preference on HTML/CSS files
  -- ========================================================================
  {
    'nvim-lua/plenary.nvim',
    ft = { 'html', 'css' },
    config = function()
      -- Initialize browser preference (defaults to Google Chrome, persists with session)
      if not vim.g.html_browser_preference then
        vim.g.html_browser_preference = 'Google Chrome'
      end
    end,
  },

  -- ========================================================================
  -- TAILWIND CSS INLINE COLOR PREVIEW
  -- ========================================================================
  -- Shows inline color previews for Tailwind classes and hex/rgb/hsl colors
  -- Example: bg-blue-500 shows blue color block, #3b82f6 shows blue block
  -- NOTE: Excludes dart/flutter files to avoid conflict with flutter-tools
  -- ========================================================================
  {
    'brenoprata10/nvim-highlight-colors',
    ft = { 'html', 'css' },
    opts = {
      render = 'virtual', -- Shows color block at end of line
      virtual_symbol = '███', -- Wider block (3 characters for better visibility)
      enable_named_colors = true, -- Enable CSS named colors like 'red', 'blue'
      enable_tailwind = true, -- Enable Tailwind CSS colors (bg-blue-500, text-red-600, etc.)
      exclude_filetypes = { 'dart' }, -- Exclude Dart to avoid conflict with flutter-tools
    },
  },
}

