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
  -- SVELTE-SPECIFIC KEYMAPS
  -- ========================================================================
  -- Additional Svelte-specific settings and keymaps
  -- ========================================================================
  {
    'nvim-lua/plenary.nvim',
    ft = 'svelte',
    config = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'svelte',
        callback = function(event)
          local bufnr = event.buf

          -- NOTE: The <leader>ls group is registered globally in editor.lua

          -- Format with Prettier
          vim.keymap.set('n', '<leader>lsf', function()
            require('conform').format { formatters = { 'prettier' } }
          end, { buffer = bufnr, desc = 'Format with prettier' })

          -- Restart Svelte LSP
          vim.keymap.set('n', '<leader>lsl', function()
            vim.cmd 'LspRestart svelte'
          end, { buffer = bufnr, desc = 'Restart LSP' })

          -- Restart TypeScript LSP (often needed in Svelte projects)
          vim.keymap.set('n', '<leader>lst', function()
            vim.cmd 'LspRestart ts_ls'
          end, { buffer = bufnr, desc = 'Restart TypeScript LSP' })

          -- Open component in split
          vim.keymap.set('n', '<leader>lso', function()
            local word = vim.fn.expand '<cfile>'
            vim.cmd('split ' .. word)
          end, { buffer = bufnr, desc = 'Open component in split' })
        end,
      })
    end,
  },

  -- ========================================================================
  -- WEB DEVELOPMENT KEYMAPS (HTML/CSS/JS/TS)
  -- ========================================================================
  -- Browser preview keymaps for web files
  -- ========================================================================
  {
    'nvim-lua/plenary.nvim',
    ft = { 'html', 'css', 'javascript', 'typescript', 'svelte' },
    config = function()
      -- Helper function to open file in specific browser
      local function open_in_browser(browser)
        local filetype = vim.bo.filetype
        local filepath = vim.fn.expand('%:p')
        
        if filetype == 'html' then
          local cmd
          if browser then
            cmd = string.format('open -a "%s" "%s"', browser, filepath)
          else
            cmd = string.format('open "%s"', filepath)
          end
          vim.fn.system(cmd)
          local browser_name = browser or 'default browser'
          vim.notify('Opened in ' .. browser_name .. ': ' .. vim.fn.expand('%:t'), vim.log.levels.INFO)
        else
          -- For Svelte/JS/TS, suggest starting a dev server
          vim.notify('For ' .. filetype .. ' files, start your dev server (npm run dev) and open http://localhost', vim.log.levels.INFO)
        end
      end

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'html', 'css', 'javascript', 'typescript', 'svelte' },
        callback = function(event)
          local bufnr = event.buf

          -- NOTE: The <leader>lh group is registered globally in editor.lua

          -- Open in default browser
          vim.keymap.set('n', '<leader>lhd', function()
            open_in_browser(nil)
          end, { buffer = bufnr, desc = 'Open in default browser' })

          -- Open in Chrome
          vim.keymap.set('n', '<leader>lhc', function()
            open_in_browser('Google Chrome')
          end, { buffer = bufnr, desc = 'Open in Chrome' })

          -- Open in Safari
          vim.keymap.set('n', '<leader>lhs', function()
            open_in_browser('Safari')
          end, { buffer = bufnr, desc = 'Open in Safari' })

          -- Open in Firefox
          vim.keymap.set('n', '<leader>lhf', function()
            open_in_browser('Firefox')
          end, { buffer = bufnr, desc = 'Open in Firefox' })

          -- Start live-server in terminal split
          vim.keymap.set('n', '<leader>lhl', function()
            vim.cmd('split | terminal live-server')
            vim.notify('Live server started. Press Ctrl+C to stop.', vim.log.levels.INFO)
          end, { buffer = bufnr, desc = 'Start live-server in split' })
        end,
      })
    end,
  },
}
