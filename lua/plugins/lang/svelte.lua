-- ========================================================================
-- SVELTE PROFILE - Language-specific plugins and LSP configuration
-- ========================================================================
--
-- This file contains all Svelte-specific plugins and configurations.
-- These plugins will ONLY load when you open a .svelte file, keeping your
-- startup time fast and avoiding conflicts with other languages.
--
-- Key features to configure here:
--   - Svelte LSP (svelte-language-server)
--   - TypeScript/JavaScript support for Svelte components
--   - Tailwind CSS integration (if using Tailwind)
--   - Prettier formatting for Svelte files
--   - Emmet support for Svelte
--   - Svelte-specific keymaps
--
-- Note: You may also want to configure support for related web files:
--   - JavaScript/TypeScript (.js, .ts)
--   - HTML/CSS (.html, .css)
--
-- Usage: Just open a .svelte file and these plugins will automatically load!
-- ========================================================================

-- Load Web Dev/Svelte keymaps immediately (not buffer-local, always available)
require('keymaps.svelte')

return {
  -- ========================================================================
  -- SVELTE LSP - Language Server Protocol for Svelte
  -- ========================================================================
  -- Provides intelligent code completion, diagnostics, and more for Svelte
  -- components, including support for TypeScript, CSS, and HTML within .svelte files
  -- NOTE: LSP servers are configured in lua/plugins/lsp/init.lua
  -- This section just ensures tools are installed
  -- ========================================================================
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    ft = { 'svelte', 'typescript', 'javascript', 'html', 'css', 'json' }, -- Load for web files
    opts = {
      ensure_installed = {
        'svelte-language-server',
        'typescript-language-server',
        'tailwindcss-language-server',
        'html-lsp',  -- HTML language server
        'css-lsp',   -- CSS language server
        'json-lsp',  -- JSON language server
        'prettier',
        'eslint_d',
      },
    },
  },

  -- ========================================================================
  -- WEB FORMATTERS - Prettier for Svelte/JS/TS/CSS
  -- ========================================================================
  -- Configures prettier to format Svelte and related web files
  -- ========================================================================
  {
    'stevearc/conform.nvim',
    ft = { 'svelte', 'typescript', 'javascript', 'css', 'html', 'json' },
    opts = function(_, opts)
      -- Extend the existing formatters_by_ft table
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.svelte = { 'prettier' }
      opts.formatters_by_ft.javascript = { 'prettier' }
      opts.formatters_by_ft.javascriptreact = { 'prettier' }
      opts.formatters_by_ft.typescript = { 'prettier' }
      opts.formatters_by_ft.typescriptreact = { 'prettier' }
      opts.formatters_by_ft.css = { 'prettier' }
      opts.formatters_by_ft.html = { 'prettier' }
      opts.formatters_by_ft.json = { 'prettier' }
      opts.formatters_by_ft.markdown = { 'prettier' }
      return opts
    end,
  },

  -- ========================================================================
  -- TREESITTER PARSERS - Syntax highlighting for web languages
  -- ========================================================================
  -- Ensures Treesitter parsers are installed for better syntax highlighting
  -- ========================================================================
  {
    'nvim-treesitter/nvim-treesitter',
    ft = { 'svelte', 'typescript', 'javascript', 'css', 'html', 'json' },
    opts = function(_, opts)
      -- Ensure web language parsers are installed
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        'svelte',
        'typescript',
        'tsx',
        'javascript',
        'jsdoc',
        'css',
        'html',
        'json',
      })
      return opts
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
    ft = { 'svelte', 'html', 'css', 'javascript', 'typescript', 'jsx', 'tsx' },
    opts = {
      render = 'virtual', -- Shows color block at end of line
      virtual_symbol = '███', -- Wider block (3 characters for better visibility)
      enable_named_colors = true, -- Enable CSS named colors like 'red', 'blue'
      enable_tailwind = true, -- Enable Tailwind CSS colors (bg-blue-500, text-red-600, etc.)
      exclude_filetypes = { 'dart' }, -- Exclude Dart to avoid conflict with flutter-tools
    },
  },

  -- ========================================================================
  -- EMMET - HTML/CSS abbreviation expansion
  -- ========================================================================
  -- Provides Emmet abbreviation support for faster HTML/CSS writing
  -- Type abbreviations like `div.container>ul>li*3` and expand with <C-y>,
  -- ========================================================================
  {
    'mattn/emmet-vim',
    ft = { 'svelte', 'html', 'css', 'javascript', 'typescript' },
    init = function()
      -- Set Emmet leader key (default is <C-y>)
      vim.g.user_emmet_leader_key = '<C-e>'
      -- Enable only for specific file types
      vim.g.user_emmet_install_global = 0
      -- Enable Emmet for Svelte files
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'html', 'css', 'svelte', 'javascript', 'typescript' },
        callback = function()
          vim.cmd 'EmmetInstall'
        end,
      })
    end,
  },

  -- ========================================================================
  -- SVELTE-SPECIFIC KEYMAPS (Buffer-local only)
  -- ========================================================================
  -- Svelte-specific formatting and LSP commands
  -- NOTE: Build/test/package commands are now GLOBAL in keymaps.lua
  -- This allows you to run them from logs, terminals, etc.
  -- ========================================================================
  {
    'nvim-lua/plenary.nvim',
    ft = { 'svelte', 'javascript', 'typescript' },
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'svelte', 'javascript', 'typescript' },
        callback = function(event)
          local bufnr = event.buf
          local filetype = vim.bo[bufnr].filetype

          -- NOTE: The <leader>ls group is registered globally in editor.lua
          -- NOTE: Most <leader>ls commands (build, test, etc.) are now global in keymaps.lua

          -- Format with Prettier (only for Svelte)
          if filetype == 'svelte' then
            vim.keymap.set('n', '<leader>lsf', function()
              require('conform').format { formatters = { 'prettier' } }
            end, { buffer = bufnr, desc = 'Format with prettier' })

            -- Restart Svelte LSP
            vim.keymap.set('n', '<leader>lsl', function()
              vim.cmd 'LspRestart svelte'
            end, { buffer = bufnr, desc = 'Restart Svelte LSP' })

            -- Open component in split
            vim.keymap.set('n', '<leader>lso', function()
              local word = vim.fn.expand '<cfile>'
              vim.cmd('split ' .. word)
            end, { buffer = bufnr, desc = 'Open component in split' })
          end
        end,
      })
    end,
  },

  -- ========================================================================
  -- HTML/CSS KEYMAPS (Buffer-local only)
  -- ========================================================================
  -- NOTE: Most HTML/CSS commands are now GLOBAL in keymaps.lua
  -- This allows you to start/stop live-server from logs, terminals, etc.
  -- This section only keeps Emmet (buffer-specific)
  -- ========================================================================
  {
    'nvim-lua/plenary.nvim',
    ft = { 'html', 'css' },
    config = function()
      -- Initialize browser preference (defaults to Google Chrome, persists with session)
      if not vim.g.html_browser_preference then
        vim.g.html_browser_preference = 'Google Chrome'
      end

      -- Note: Browser commands (<leader>lho, <leader>lhb, <leader>lhl) are now global in keymaps.lua
      -- This allows you to start/stop live-server from any buffer (terminals, logs, etc.)
    end,
  },
}

