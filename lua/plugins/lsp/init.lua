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
            { 'j-hui/fidget.nvim',    opts = {} },
            'saghen/blink.cmp',
        },
        config = function()
            -- LSP UI Enhancements - Better hover, signature help, and borders
            -- Set default border for all LSP floating windows
            require('lspconfig.ui.windows').default_options.border = 'rounded'

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
                            vim.keymap.set('n', 'q', '<cmd>close<cr>',
                                { buffer = event.buf, silent = true, nowait = true })
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

                    map('grn', vim.lsp.buf.rename, 'Rename')
                    map('K', vim.lsp.buf.hover, 'Hover Documentation')
                    map('gra', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })
                    map('<leader>.', vim.lsp.buf.code_action, 'Code Actions (VSCode-like)', { 'n', 'x' })
                    map('grr', require('telescope.builtin').lsp_references, 'References')
                    map('gri', require('telescope.builtin').lsp_implementations, 'Implementation')
                    map('grd', require('telescope.builtin').lsp_definitions, 'Definition')
                    map('grD', vim.lsp.buf.declaration, 'Declaration')
                    map('gO', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
                    map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')
                    map('grt', require('telescope.builtin').lsp_type_definitions, 'Type Definition')

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
                        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight',
                            { clear = false })
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
                        end, 'Toggle Inlay Hints')
                    end
                end,
            })

            -- Get LSP capabilities with blink.cmp enhancements (with fallback)
            local capabilities = vim.lsp.protocol.make_client_capabilities()

            -- Try to enhance with blink capabilities if available
            local blink_ok, blink = pcall(require, 'blink.cmp')
            if blink_ok then
                capabilities = blink.get_lsp_capabilities(capabilities)
            else
                vim.notify('blink.cmp not available, using vanilla LSP capabilities', vim.log.levels.WARN)
            end

            -- Require lspconfig util once at the top
            local lspconfig_util = require('lspconfig.util')

            -- General LSP servers (lua_ls for Neovim config, basedpyright for Python)
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
                basedpyright = {
                    settings = {
                        basedpyright = {
                            analysis = {
                                typeCheckingMode = 'basic',
                                autoImportCompletions = true,
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                                diagnosticMode = 'openFilesOnly',
                            },
                        },
                    },
                    -- Detect and configure virtual environment
                    -- Supports: .venv, venv, VIRTUAL_ENV env var (set by direnv/pyenv)
                    before_init = function(_, config)
                        local util = lspconfig_util
                        local root_dir = config.root_dir

                        -- Try to find Python interpreter in order of preference:
                        -- 1. VIRTUAL_ENV environment variable (direnv, pyenv, manually activated)
                        -- 2. Local .venv or venv directories
                        -- 3. System python3
                        local function find_python()
                            -- Check VIRTUAL_ENV first (direnv support)
                            local venv_env = os.getenv('VIRTUAL_ENV')
                            if venv_env then
                                local python = util.path.join(venv_env, 'bin', 'python')
                                if vim.fn.filereadable(python) == 1 then
                                    return python
                                end
                            end

                            -- Check common venv locations in project root
                            local venv_names = { '.venv', 'venv', '.env', 'env' }
                            for _, name in ipairs(venv_names) do
                                local python = util.path.join(root_dir, name, 'bin', 'python')
                                if vim.fn.filereadable(python) == 1 then
                                    return python
                                end
                            end

                            -- Fall back to system python3
                            return vim.fn.exepath('python3')
                        end

                        local python_path = find_python()
                        config.settings = vim.tbl_deep_extend('force', config.settings, {
                            python = { pythonPath = python_path }
                        })
                    end,
                },
                html = {
                    -- HTML language server
                    filetypes = { 'html', 'svelte' },
                    root_dir = function(fname)
                        return lspconfig_util.find_git_ancestor(fname)
                            or lspconfig_util.find_node_modules_ancestor(fname)
                            or lspconfig_util.find_package_json_ancestor(fname)
                            or vim.fn.getcwd()
                    end,
                },
                cssls = {
                    -- CSS language server
                    filetypes = { 'css', 'scss', 'less', 'svelte' },
                    root_dir = function(fname)
                        return lspconfig_util.find_git_ancestor(fname)
                            or lspconfig_util.find_node_modules_ancestor(fname)
                            or lspconfig_util.find_package_json_ancestor(fname)
                            or vim.fn.getcwd()
                    end,
                },
                jsonls = {
                    -- JSON language server
                    filetypes = { 'json', 'jsonc' },
                    root_dir = function(fname)
                        return lspconfig_util.find_git_ancestor(fname)
                            or vim.fn.getcwd()
                    end,
                },
            }

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                'stylua', -- Lua formatter
                'ruff',   -- Python linter/formatter
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
        end,
    },

    -- Autoformat
    {
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo' },
        keys = {
            {
                '<leader>cf',
                function()
                    require('conform').format {
                        async = true,            -- Don't block editor while formatting
                        lsp_format = 'fallback', -- Use LSP if no formatter configured
                        notify_on_error = true,  -- Show errors on manual format
                    }
                    vim.notify('Buffer formatted', vim.log.levels.INFO)
                end,
                mode = { 'n', 'v' },
                desc = 'Format buffer/selection',
            },
        },
        opts = {
            notify_on_error = false, -- Don't show errors on auto-save
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
                sh = { 'shfmt' },
                bash = { 'shfmt' },
                yaml = { 'prettier' },
                toml = { 'taplo' },
                json = { 'prettier' },
                markdown = { 'prettier' },
            },
        },
    },
}
