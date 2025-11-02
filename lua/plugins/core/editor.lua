-- ========================================================================
-- CORE EDITOR PLUGINS
-- ========================================================================
-- Essential editing tools that are always loaded
-- - Telescope: Fuzzy finder
-- - Which-key: Keybinding helper
-- - Neo-tree: File explorer
-- - guess-indent: Auto-detect indentation
-- ========================================================================

return {
  -- Detect tabstop and shiftwidth automatically
  {
    'NMAC427/guess-indent.nvim',
    opts = {
      -- Exclude Dart files - dart-vim-plugin handles indentation better
      filetype_exclude = {
        'dart',
      },
    },
  },

  -- Telescope: Fuzzy finder (files, LSP, etc)
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy', -- Deferred for faster startup
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              -- Navigation (consistent with Neo-tree)
              ['<C-j>'] = require('telescope.actions').move_selection_next,
              ['<C-k>'] = require('telescope.actions').move_selection_previous,
              
              -- Preview scrolling
              ['<C-d>'] = require('telescope.actions').preview_scrolling_down,
              ['<C-u>'] = require('telescope.actions').preview_scrolling_up,
              
              -- Open actions (consistent with Neo-tree)
              ['<CR>'] = require('telescope.actions').select_default, -- Open in current window
              ['<C-x>'] = require('telescope.actions').select_horizontal, -- Open in horizontal split
              ['<C-v>'] = require('telescope.actions').select_vertical, -- Open in vertical split
              ['<C-t>'] = require('telescope.actions').select_tab, -- Open in new tab
              
              -- Close
              ['<C-c>'] = require('telescope.actions').close,
              ['<Esc>'] = require('telescope.actions').close,
              
              -- Cycle history
              ['<C-n>'] = require('telescope.actions').cycle_history_next,
              ['<C-p>'] = require('telescope.actions').cycle_history_prev,
              
              -- Selection
              ['<Tab>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_worse,
              ['<S-Tab>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_better,
              
              -- Send to quickfix
              ['<C-q>'] = require('telescope.actions').send_to_qflist + require('telescope.actions').open_qflist,
              ['<M-q>'] = require('telescope.actions').send_selected_to_qflist + require('telescope.actions').open_qflist,
            },
            n = {
              -- Same mappings in normal mode
              ['<C-j>'] = require('telescope.actions').move_selection_next,
              ['<C-k>'] = require('telescope.actions').move_selection_previous,
              ['<C-d>'] = require('telescope.actions').preview_scrolling_down,
              ['<C-u>'] = require('telescope.actions').preview_scrolling_up,
              
              ['<CR>'] = require('telescope.actions').select_default,
              ['<C-x>'] = require('telescope.actions').select_horizontal,
              ['<C-v>'] = require('telescope.actions').select_vertical,
              ['<C-t>'] = require('telescope.actions').select_tab,
              
              ['q'] = require('telescope.actions').close,
              ['<Esc>'] = require('telescope.actions').close,
              
              ['<Tab>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_worse,
              ['<S-Tab>'] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_better,
              
              ['<C-q>'] = require('telescope.actions').send_to_qflist + require('telescope.actions').open_qflist,
              ['<M-q>'] = require('telescope.actions').send_selected_to_qflist + require('telescope.actions').open_qflist,
              
              -- Vim-like navigation
              ['j'] = require('telescope.actions').move_selection_next,
              ['k'] = require('telescope.actions').move_selection_previous,
              ['gg'] = require('telescope.actions').move_to_top,
              ['G'] = require('telescope.actions').move_to_bottom,
              
              ['?'] = require('telescope.actions').which_key, -- Show help
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      
      -- ============================================================================
      -- ENHANCED BUFFER PICKER
      -- ============================================================================
      -- Custom buffer picker with visual indicators
      -- Filters out [No Name] buffers automatically
      -- ============================================================================
      vim.keymap.set('n', '<leader><leader>', function()
        local entry_display = require('telescope.pickers.entry_display')
        
        -- Custom entry maker with indicators
        local function buffer_entry_maker(opts)
          opts = opts or {}
          
          local displayer = entry_display.create {
            separator = ' ',
            items = {
              { width = 2 },  -- Modified indicator
              { width = 2 },  -- Diagnostic indicator
              { width = 3 },  -- Icon
              { remaining = true },  -- Filename
            },
          }
          
          local make_display = function(entry)
            local bufnr = entry.bufnr
            local display_name = entry.display_name
            
            -- Get buffer state
            local is_modified = vim.api.nvim_buf_get_option(bufnr, 'modified')
            local is_readonly = vim.api.nvim_buf_get_option(bufnr, 'readonly')
            local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
            local is_special = buftype ~= '' -- terminal, quickfix, help, etc.
            
            -- Get diagnostic counts for this buffer
            local diagnostics = vim.diagnostic.get(bufnr)
            local error_count = 0
            local warn_count = 0
            for _, d in ipairs(diagnostics) do
              if d.severity == vim.diagnostic.severity.ERROR then
                error_count = error_count + 1
              elseif d.severity == vim.diagnostic.severity.WARN then
                warn_count = warn_count + 1
              end
            end
            
            -- Build separate indicators for alignment
            local modified_indicator = is_modified and { '●', 'DiagnosticInfo' } or { ' ', 'Normal' }
            
            local diag_indicator
            if error_count > 0 then
              diag_indicator = { '󰅚', 'DiagnosticError' }
            elseif warn_count > 0 then
              diag_indicator = { '󰀪', 'DiagnosticWarn' }
            else
              diag_indicator = { ' ', 'Normal' }
            end
            
            -- Get file icon and determine highlight based on buffer type
            local icon, icon_hl
            local name_hl = 'Normal'
            
            if is_special or is_readonly then
              -- Special/readonly buffers (terminals, quickfix, etc) get yellow
              icon = '󰈙'  -- Log/document icon
              icon_hl = 'DiagnosticWarn'
              name_hl = 'DiagnosticWarn'
            else
              icon, icon_hl = require('nvim-web-devicons').get_icon(display_name, string.match(display_name, '%a+$'), { default = true })
              icon = icon or ''
            end
            
            return displayer {
              modified_indicator,
              diag_indicator,
              { icon, icon_hl },
              { display_name, name_hl },
            }
          end
          
          return function(entry)
            local bufnr = entry.bufnr
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            
            -- Filter out buffers with no name
            if bufname == '' then
              return nil
            end
            
            -- Get display name (just the filename)
            local display_name = vim.fn.fnamemodify(bufname, ':t')
            
            return {
              bufnr = bufnr,
              filename = bufname,
              display_name = display_name,
              ordinal = display_name,
              display = make_display,
              lnum = entry.lnum,
            }
          end
        end
        
        require('telescope.builtin').buffers {
          sort_mru = true,
          sort_lastused = true,
          ignore_current_buffer = false,
          show_all_buffers = true,
          previewer = false,
          theme = 'dropdown',
          layout_config = {
            width = 0.7,
            height = 0.5,
          },
          entry_maker = buffer_entry_maker(),
        }
      end, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = 'Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- Which-key: Shows pending keybinds
  {
    'folke/which-key.nvim',
    event = 'VeryLazy', -- Deferred for faster startup
    opts = {
      delay = 0,
      -- Floating window configuration (bottom right)
      win = {
        width = { min = 30, max = 60 },  -- Width range for the popup
        height = { min = 4, max = 0.9 }, -- Max 90% of screen height - fits all items
        col = 0.99,                       -- Position close to right edge
        row = 0.95,                       -- Position close to bottom
        border = 'rounded',               -- Border style
        padding = { 1, 2 },               -- Padding inside window
        title = true,                     -- Show title
        title_pos = 'center',             -- Center the title
        wo = {
          winblend = 0,                   -- No transparency (0-100)
        },
      },
      layout = {
        width = { min = 30 },             -- Minimum column width
        spacing = 3,                      -- Spacing between columns
      },
      icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
        ellipsis = "…",
        mappings = true, -- Always show icons (we have Nerd Font)
        rules = false, -- Disable built-in icon rules to use our custom icons
        -- Setting keys to empty object means use defaults
        keys = {},
      },
      -- Filter to hide keymaps that won't work in current buffer
      plugins = {
        presets = {
          operators = false, -- adds help for operators like d, y, ...
          motions = false, -- adds help for motions
          text_objects = false, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
      },
      spec = {
        -- Core groups with icons
        { '<leader>b', group = '󰊄 Buffer' },
        { '<leader>c', group = '󰘦 Code' },
        { '<leader>d', group = '󰃤 Debug' },
        { '<leader>f', group = '󱓞 Flutter' }, -- Only visible in Dart files
        { '<leader>g', group = '󰊢 Git' },
        { '<leader>h', group = '󰊢 Git Hunk', mode = { 'n', 'v' } },
        { '<leader>o', group = '󰖟 Browser' }, -- Only visible in HTML/CSS/JS/TS/Svelte files
        { '<leader>p', group = '󰌠 Python' }, -- Only visible in Python files
        { '<leader>r', group = '󱘗 Rust' }, -- Only visible in Rust files
        { '<leader>s', group = '󰍉 Search' },
        { '<leader>S', group = '󱂬 Session' },
        { '<leader>t', group = '󰔡 Toggle' },
        { '<leader>u', group = '󰙵 UI' },
        { '<leader>v', group = '󰡄 Svelte' }, -- Only visible in Svelte files
        { '<leader>w', group = '󰖲 Window' },
        { '<leader>x', group = '󱖫 Diagnostics' },
        
        -- Special standalone keymaps (not part of a group)
        { '<leader>q', desc = '󰁨 Toggle Diagnostic Quickfix' },
        { '<leader>Q', desc = '󰗼 Quit All' },
        { '<leader>/', desc = '󰱼 Fuzzy Search in Buffer' },
        { '<leader><leader>', desc = '󰈙 Find Buffers' },
        { '<leader>?', desc = '󰘳 Search Keymaps' },
        { '<leader>.', desc = '󰌵 Code Actions', mode = { 'n', 'v' } },
        
        -- Bracket motions (Vim defaults + snacks)
        { ']', group = '󰜴 Next' },
        { '[', group = '󰜱 Previous' },
        { ']]', desc = '󱡁 Next Word Occurrence (snacks.words)' },
        { '[[', desc = '󱡁 Prev Word Occurrence (snacks.words)' },
        { ']s', desc = '󰓆 Next Misspelled Word (spell)' },
        { '[s', desc = '󰓆 Prev Misspelled Word (spell)' },
        { ']c', desc = '󰊢 Next Git Change (gitsigns)' },
        { '[c', desc = '󰊢 Prev Git Change (gitsigns)' },
        { ']d', desc = '󱖫 Next Diagnostic (LSP)' },
        { '[d', desc = '󱖫 Prev Diagnostic (LSP)' },
        { ']h', desc = '󰊢 Next Git Hunk (gitsigns)' },
        { '[h', desc = '󰊢 Prev Git Hunk (gitsigns)' },
        
        -- Vim argument list navigation (files passed to nvim: nvim file1.txt file2.txt)
        { ']a', desc = '󰈔 Next Arg (:next)' },
        { '[a', desc = '󰈔 Prev Arg (:prev)' },
        { ']A', desc = '󰈔 Last Arg (:last)' },
        { '[A', desc = '󰈔 First Arg (:first)' },
        
        -- Buffer navigation (opened files)
        { ']b', desc = '󰊄 Next Buffer (:bnext)' },
        { '[b', desc = '󰊄 Prev Buffer (:bprev)' },
        { ']B', desc = '󰊄 Last Buffer (:blast)' },
        { '[B', desc = '󰊄 First Buffer (:bfirst)' },
        
        -- Location list navigation (LSP locations, grep results)
        { ']l', desc = '󱖫 Next Location (:lnext)' },
        { '[l', desc = '󱖫 Prev Location (:lprev)' },
        { ']L', desc = '󱖫 Last Location (:llast)' },
        { '[L', desc = '󱖫 First Location (:lfirst)' },
        
        -- Quickfix list navigation (search results, errors)
        { ']q', desc = '󰁨 Next Quickfix (:cnext)' },
        { '[q', desc = '󰁨 Prev Quickfix (:cprev)' },
        { ']Q', desc = '󰁨 Last Quickfix (:clast)' },
        { '[Q', desc = '󰁨 First Quickfix (:cfirst)' },
        
        -- Tag navigation (ctags, jump to definition)
        { ']t', desc = '󰓹 Next Tag (:tnext)' },
        { '[t', desc = '󰓹 Prev Tag (:tprev)' },
        { ']T', desc = '󰓹 Last Tag (:tlast)' },
        { '[T', desc = '󰓹 First Tag (:tfirst)' },
      },
    },
  },

  -- Neo-tree: File explorer
  -- Imported from kickstart/plugins/neo-tree.lua
}
