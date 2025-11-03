-- ========================================================================
-- FLUTTER/DART PROFILE - Language-specific plugins and LSP configuration
-- ========================================================================
--
-- This file contains all Flutter and Dart-specific plugins and configurations.
-- These plugins will ONLY load when you open a .dart file, keeping your
-- startup time fast and avoiding conflicts with other languages.
--
-- Key features to configure here:
--   - Flutter tools (hot reload, device management, widget inspector)
--   - Dart LSP (dartls via flutter-tools)
--   - Dart-specific formatters and linters
--   - Flutter-specific keymaps (e.g., <leader>fr for Flutter Run)
--
-- Usage: Just open a .dart file and these plugins will automatically load!
--
-- Note: Flutter utility functions are in lua/utils/flutter.lua and loaded
-- early to ensure they're available when core plugins need them.
-- ========================================================================

-- Load Flutter keymaps immediately (not buffer-local, always available)
require('keymaps.flutter')

return {
  -- ============================================================================
  -- FLUTTER & DART DEVELOPMENT ENVIRONMENT
  -- ============================================================================
  -- Comprehensive Flutter development setup with:
  --   • flutter-tools: LSP, DAP, widget tree, outline, dev tools
  --   • nvim-dap: Debug adapter protocol support
  --   • dart-vim-plugin: Official Dart indentation (Treesitter indent has issues)
  --   • Treesitter: Syntax highlighting and code understanding
  -- ============================================================================

  -- ============================================================================
  -- DART VIM PLUGIN - Official Dart indentation support
  -- ============================================================================
  -- Treesitter indent is broken for Dart (github.com/nvim-treesitter/nvim-treesitter/issues/1612)
  -- This official plugin provides proper indentation for Dart/Flutter files
  {
    'dart-lang/dart-vim-plugin',
    ft = 'dart',
    init = function()
      -- Enable Dart-specific indentation options (VSCode-like behavior)
      vim.g.dart_style_guide = 2  -- Use 2-space indentation
      vim.g.dart_format_on_save = 0  -- Disable format on save (we use conform.nvim)
      
      -- Set indentation to align with opening parenthesis (VSCode behavior)
      -- This makes parameters align with the opening ( like:
      -- Container(
      --   child: Text(
      --     'hello',
      --   ),
      -- )
    end,
    config = function()
      -- Ensure Dart files use proper indentation settings
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'dart',
        callback = function()
          vim.opt_local.shiftwidth = 2
          vim.opt_local.tabstop = 2
          vim.opt_local.softtabstop = 2
          vim.opt_local.expandtab = true
          -- VSCode-style: align continuation lines with opening delimiter
          -- (0 = align with opening paren, Ws = indent when line starts with whitespace
          vim.opt_local.cinoptions = '(0,Ws,m1'
        end,
      })
    end,
  },

  -- ========================================================================
  -- NVIM-DAP - Debug Adapter Protocol for Flutter debugging
  -- ========================================================================
  -- Load DAP when opening Dart files to enable breakpoint debugging
  {
    'mfussenegger/nvim-dap',
    ft = 'dart',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
    },
  },
  {
    'nvim-flutter/flutter-tools.nvim',
    ft = 'dart', -- Only load when opening Dart files
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- Optional: better UI for Flutter commands
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
    },
    config = function()
      -- Get shared LSP capabilities from blink.cmp
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      require('flutter-tools').setup {
        -- UI configuration
        ui = {
          border = 'rounded', -- border type for floating windows
          notification_style = 'native', -- 'native' or 'plugin' (native uses vim.notify)
        },

        -- Flutter SDK path (usually auto-detected, but you can specify if needed)
        -- flutter_path = '/path/to/flutter/bin/flutter',
        -- flutter_lookup_cmd = nil, -- example: "dirname $(which flutter)" or "asdf where flutter"

        -- FVM support - takes priority over path, uses <workspace>/.fvm/flutter_sdk if enabled
        fvm = false,

        -- Root patterns to find the root of your flutter project
        root_patterns = { '.git', 'pubspec.yaml' },

        -- Uncomment to set a default device (get ID from `flutter devices`)
        -- device = {
        --   id = 'chrome', -- or 'macos', 'emulator-5554', etc.
        -- },

        lsp = {
          capabilities = capabilities,
          
          -- Suppress didChange errors during snippet expansion
          on_attach = function(client, bufnr)
            -- Reduce didChange notification frequency to prevent errors with snippets
            client.server_capabilities.textDocumentSync = vim.tbl_deep_extend('force', client.server_capabilities.textDocumentSync or {}, {
              change = 2, -- 2 = Incremental (less prone to errors than full sync)
            })
            
            -- Filter out dartls didChange error notifications (they're harmless during snippet expansion)
            -- Only suppress this specific error from dartls, not all notifications
            vim.api.nvim_create_autocmd('User', {
              pattern = 'VeryLazy',
              once = true,
              callback = function()
                local notify = vim.notify
                vim.notify = function(msg, level, opts)
                  -- Only suppress dartls textDocument/didChange errors
                  if type(msg) == 'string' 
                     and msg:match('textDocument/didChange') 
                     and (msg:match('dartls') or vim.bo.filetype == 'dart') then
                    return -- Suppress this specific error from dartls only
                  end
                  notify(msg, level, opts)
                end
              end,
            })
          end,
          
          -- Color preview for dart variables (Colors.red, Color(0xFF...), etc.)
          -- This shows the actual Material Design colors inline!
          color = {
            enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
            background = true, -- highlight the background
            background_color = nil, -- required, when background is transparent (i.e. background_color = { r = 19, g = 17, b = 24},)
            foreground = false, -- highlight the foreground
            virtual_text = true, -- show the highlight using virtual text
            virtual_text_str = '■', -- the virtual text character to highlight
          },
          -- Settings passed to the Dart LSP
          settings = {
            -- Show TODOs in the problems pane
            showTodos = true,
            -- Completion settings
            completeFunctionCalls = true,
            -- Enable/disable specific lints
            -- analysisExcludedFolders = {},
            renameFilesWithClasses = 'prompt', -- "always" or "prompt"
            enableSnippets = true,
            updateImportsOnRename = true, -- Whether to update imports and other directives when files are renamed
          },
        },

        -- Flutter-specific settings
        decorations = {
          statusline = {
            -- Set to true to show Flutter app info in statusline
            app_version = false,
            device = true, -- Show device name
          },
        },

        widget_guides = {
          enabled = true, -- Show visual guides for widget nesting
        },

        closing_tags = {
          highlight = 'Comment', -- Highlight color for closing tags
          prefix = '// ', -- Text to show before closing tag
          enabled = true, -- Show closing tags for widgets
        },

        -- DISABLED: We use terminal commands instead of plugin-managed dev log
        dev_log = {
          enabled = false, -- Don't create __FLUTTER_DEV_LOG__ buffer
          notify_errors = false,
        },

        -- DISABLED: We manage DevTools manually with browser selection
        dev_tools = {
          autostart = false, -- Don't autostart devtools server
          auto_open_browser = false, -- Don't automatically open browser
        },

        outline = {
          open_cmd = '60vnew', -- command to use to open the outline buffer (increased from 30 to 50)
          auto_open = false, -- if true this will open the outline automatically when it is first populated
        },

        debugger = {
          enabled = true, -- Enable Flutter debugger integration
          run_via_dap = false, -- Don't intercept flutter run (we use terminal commands)
          -- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
          -- see |:help dap.set_exception_breakpoints()| for more info
          exception_breakpoints = {},
          -- Whether to call toString() on objects in debug views like hovers and the variables list.
          -- Invoking toString() has a performance cost and may introduce side-effects,
          -- although users may expected this functionality. null is treated like false.
          evaluate_to_string_in_debug_views = true,
          -- Flutter tools will automatically register DAP configurations
          -- No need to manually configure launch.json
        },
      }

      -- ========================================================================
      -- DAP UI SETUP - Beautiful debugging interface
      -- ========================================================================
      local dap, dapui = require 'dap', require 'dapui'

      -- Configure DAP UI to open in tabs for better half-width screen support
      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
        -- Open each element in a new tab instead of side panels
        -- This prevents layout issues on small/half-width screens
        layouts = {
          {
            elements = {
              { id = 'scopes', size = 0.25 },
              { id = 'breakpoints', size = 0.25 },
              { id = 'stacks', size = 0.25 },
              { id = 'watches', size = 0.25 },
            },
            size = 40,
            position = 'right',
          },
          {
            elements = {
              { id = 'repl', size = 0.5 },
              { id = 'console', size = 0.5 },
            },
            size = 10,
            position = 'bottom',
          },
        },
        -- Override element window commands to open in tabs
        element_mappings = {},
        windows = { indent = 1 },
      }

      -- Custom function to open DAP UI elements in tabs
      local function open_dapui_in_tabs()
        -- Save current tab to return to it
        local current_tab = vim.fn.tabpagenr()
        
        -- Create new tab with a named buffer for debug views
        vim.cmd 'tabnew'
        local debug_buf = vim.api.nvim_create_buf(false, true)
        -- Use pcall to safely set buffer name (may fail if name exists)
        pcall(vim.api.nvim_buf_set_name, debug_buf, 'Flutter Debug')
        vim.api.nvim_set_current_buf(debug_buf)
        
        -- Open DAP UI in this tab
        dapui.open()
        
        -- Return to original tab so user continues coding there
        vim.cmd('tabnext ' .. current_tab)
      end

      -- Custom function to close DAP UI tabs
      local function close_dapui_tabs()
        dapui.close()
        
        -- Find and close the Flutter Debug tab
        local current_tab = vim.fn.tabpagenr()
        for i = 1, vim.fn.tabpagenr '$' do
          vim.cmd('tabnext ' .. i)
          local bufname = vim.api.nvim_buf_get_name(0)
          if bufname:match('Flutter Debug') then
            vim.cmd 'tabclose'
            break
          end
        end
        
        -- Return to original tab
        if vim.fn.tabpagenr '$' >= current_tab then
          vim.cmd('tabnext ' .. current_tab)
        end
      end

      -- Automatically open/close DAP UI in tabs
      dap.listeners.after.event_initialized['dapui_config'] = open_dapui_in_tabs
      dap.listeners.before.event_terminated['dapui_config'] = close_dapui_tabs
      dap.listeners.before.event_exited['dapui_config'] = close_dapui_tabs

      -- ========================================================================
      -- ENABLE TREESITTER FOLDING FOR DART FILES
      -- ========================================================================
      -- Set fold method to use Treesitter for Flutter widgets
      -- Using multiple autocmds to ensure it sticks (some plugins override it)
      -- 
      -- NOTE: These settings OVERRIDE the global folding config in options.lua
      -- for Dart files specifically. The autocmd runs after buffer load, so these
      -- settings take precedence for *.dart files.
      -- 
      local fold_augroup = vim.api.nvim_create_augroup('DartFolding', { clear = true })
      
      vim.api.nvim_create_autocmd({ 'BufRead', 'BufEnter', 'BufWinEnter' }, {
        group = fold_augroup,
        pattern = '*.dart',
        callback = function()
          vim.opt_local.foldmethod = 'expr'
          vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
          vim.opt_local.foldlevel = 99          -- High level = everything unfolded
          vim.opt_local.foldlevelstart = 99     -- Start with everything unfolded
          
          -- Hide fold column (no extra column, folds still work!)
          vim.opt_local.foldcolumn = '0'
          
          -- Minimal fold display (VS Code style - just shows first line)
          vim.opt_local.foldtext = ''
        end,
      })
      
      -- Also set after LSP attaches (flutter-tools might reset it)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = fold_augroup,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == 'dartls' then
            vim.opt_local.foldmethod = 'expr'
            vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
            vim.opt_local.foldlevel = 99        -- Everything unfolded
          end
        end,
      })

      -- ========================================================================
      -- FLUTTER-SPECIFIC KEYMAPS (Dart files only)
      -- ========================================================================
      -- Buffer-local keymaps for Dart files (code actions)
      -- Global Flutter commands (run, reload, quit, devices) are in lua/keymaps/flutter.lua
      -- ========================================================================
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'dart',
        callback = function(event)
          local opts = { buffer = true, silent = true }

          -- Code Actions (Cmd+. equivalent) - wrap, remove, extract widgets, etc.
          -- Note: 'gra' is already defined globally in lua/plugins/lsp/init.lua for all languages
          vim.keymap.set('n', '<leader>.', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Flutter: Code actions (Cmd+.)' }))
          vim.keymap.set('v', '<leader>.', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Flutter: Code actions (Cmd+.)' }))
        end,
      })
    end,
  },

  -- ========================================================================
  -- DART TREESITTER - Ensure dart parser is installed for proper folding
  -- ========================================================================
  {
    'nvim-treesitter/nvim-treesitter',
    ft = 'dart',
    opts = function(_, opts)
      -- Ensure Dart parser is installed
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'dart' })
      return opts
    end,
  },
}
