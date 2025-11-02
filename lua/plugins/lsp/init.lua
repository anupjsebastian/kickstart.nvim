-- ========================================================================
-- LSP CONFIGURATION
-- ========================================================================
-- Language Server Protocol setup
-- Provides features like:
--   - Go to definition
--   - Find references
--   - Autocompletion
--   - Symbol search
--   - Code actions
--   - Rename refactoring
-- ========================================================================

return {
  -- Main LSP Configuration
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    priority = 1000,
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      -- Check if blink.cmp is available
      local blink_ok = pcall(require, 'blink.cmp')
      if not blink_ok then
        vim.defer_fn(function()
          require('lazy').load({ plugins = { 'nvim-lspconfig' } })
        end, 1000)
        return
      end
      
      -- LSP UI Enhancements - Better hover, signature help, and borders
      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'rounded',
        max_width = 80,
      })

      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = 'rounded',
        max_width = 80,
      })

      -- Add keymaps to close LSP floating windows
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'lspinfo',
        callback = function(event)
          vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = event.buf, silent = true })
          vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
        end,
      })

      -- When you jump into a floating window (K twice), allow q to close it
      vim.api.nvim_create_autocmd('BufEnter', {
        callback = function(event)
          local buftype = vim.bo[event.buf].buftype
          if buftype == 'nofile' or buftype == 'help' then
            local winid = vim.api.nvim_get_current_win()
            local config = vim.api.nvim_win_get_config(winid)
            if config.relative ~= '' then
              vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true, nowait = true })
            end
          end
        end,
      })

      -- LSP Keymaps (applied when LSP attaches to a buffer)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('<leader>.', vim.lsp.buf.code_action, 'Code Actions (VSCode-like)', { 'n', 'x' })
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- Highlight references under cursor
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- Inlay hints toggle
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Get capabilities from blink.cmp
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- General LSP servers (lua_ls for Neovim config, pyright for Python)
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = 'basic',
                autoImportCompletions = true,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'workspace',
              },
            },
          },
        },
        html = {
          -- HTML language server
          filetypes = { 'html', 'svelte' },
          root_dir = function(fname)
            local util = require('lspconfig.util')
            return util.find_git_ancestor(fname)
              or util.find_node_modules_ancestor(fname)
              or util.find_package_json_ancestor(fname)
              or vim.fn.getcwd()
          end,
        },
        cssls = {
          -- CSS language server
          filetypes = { 'css', 'scss', 'less', 'svelte' },
          root_dir = function(fname)
            local util = require('lspconfig.util')
            return util.find_git_ancestor(fname)
              or util.find_node_modules_ancestor(fname)
              or util.find_package_json_ancestor(fname)
              or vim.fn.getcwd()
          end,
        },
        jsonls = {
          -- JSON language server
          filetypes = { 'json', 'jsonc' },
          root_dir = function(fname)
            local util = require('lspconfig.util')
            return util.find_git_ancestor(fname)
              or vim.fn.getcwd()
          end,
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Lua formatter
        'ruff', -- Python linter/formatter
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      -- Get LSP servers to install (keys of servers table)
      local lsp_servers = vim.tbl_keys(servers or {})
      
      require('mason-lspconfig').setup {
        ensure_installed = lsp_servers,
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }

      -- ========================================================================
      -- PYTHON VENV DETECTION
      -- ========================================================================
      -- Automatically configure pyright to use .venv when it attaches
      -- This is here instead of python.lua to ensure it runs after LSP setup
      -- ========================================================================
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('python-venv-detection', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == 'pyright' then
            local root_dir = client.config.root_dir
            local venv_python = root_dir .. '/.venv/bin/python'
            
            if vim.loop.fs_stat(venv_python) then
              client.config.settings.python = client.config.settings.python or {}
              client.config.settings.python.pythonPath = venv_python
              client.notify('workspace/didChangeConfiguration', { settings = client.config.settings })
            end
          end
        end,
      })
    end,
  },

  -- Autoformat
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
      },
    },
  },
}
