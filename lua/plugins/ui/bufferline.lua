-- ============================================================================
-- BUFFERLINE - Tab-scoped buffer management with workspace indicators
-- ============================================================================
-- Shows buffers as tabs at the top with visual workspace/tab indicators.
-- Each tab maintains its own buffer list (workspace-like behavior).
--
-- Features:
--   - Tab-scoped buffers via scope.nvim integration
--   - Visual tab/workspace indicators
--   - File icons, modified indicators, close buttons
--   - Diagnostic indicators (errors/warnings)
--   - Mouse support for clicking tabs
--
-- Keymaps:
--   ]b / [b          - Next/previous buffer (in current tab)
--   <Leader>bd       - Close current buffer (uses snacks smart delete)
--   <Leader>bo       - Close other buffers (uses snacks)
--   <Leader>bD       - Close buffer + buffers to the right
--   <Leader>bl       - Close buffers to the left
--   <Leader>br       - Close buffers to the right
--   <Leader>bp       - Pin/unpin buffer (keeps it when closing others)
--   <Leader>1-9      - Go to buffer 1-9
--   <Leader>wn       - New workspace (tab) - existing keymap
--   <Leader>wc       - Close workspace (tab) - existing keymap
--   ]w / [w          - Next/previous workspace (tab)
--
-- Dependencies:
--   - nvim-web-devicons (for file icons)
--   - scope.nvim (for tab-scoped buffers)
-- ============================================================================

return {
  -- Scope: Tab-scoped buffer management
  {
    'tiagovla/scope.nvim',
    lazy = false, -- Load immediately to work with session restore
    config = function()
      require('scope').setup {
        restore_state = false, -- Let auto-session handle restoration
      }
    end,
  },

  -- Bufferline: Visual buffer tabs with workspace indicators
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    version = '*',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'tiagovla/scope.nvim', -- Tab-scoped buffers
    },
    config = function()
      -- Setup bufferline when we have multiple buffers
      local function setup_bufferline()
        local bufs = vim.fn.getbufinfo({ buflisted = 1 })
        if #bufs >= 2 then
          require('bufferline').setup(require('plugins.ui.bufferline').opts)
          return true
        end
        return false
      end
      
      -- Try immediate setup (e.g., after session restore)
      if not setup_bufferline() then
        -- Otherwise wait for multiple buffers
        vim.api.nvim_create_autocmd({ 'BufAdd', 'BufEnter' }, {
          callback = function()
            if vim.bo.filetype ~= 'snacks_dashboard' and vim.bo.buftype == '' then
              if setup_bufferline() then
                -- Remove this autocmd after setup
                return true
              end
            end
          end,
        })
      end
    end,
    opts = {
      options = {
        mode = 'buffers', -- Show buffers (not tabs)
        
        -- Buffer numbers (no tab indicator here - moved to top right)
        numbers = function(opts)
          return string.format('%s', opts.ordinal)
        end,
        
        -- Close behavior
        close_command = 'bdelete! %d',
        right_mouse_command = 'bdelete! %d',
        left_mouse_command = 'buffer %d',
        middle_mouse_command = nil,
        
        -- Visual indicators
        indicator = {
          icon = '▎',
          style = 'icon', -- 'icon' | 'underline' | 'none'
        },
        buffer_close_icon = '󰅖',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        
        -- Diagnostics
        diagnostics = 'nvim_lsp',
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match('error') and ' ' or ' '
          return ' ' .. icon .. count
        end,
        
        -- Separator style
        separator_style = 'slant', -- 'slant' | 'slope' | 'thick' | 'thin' | { 'any', 'any' }
        
        -- Workspace indicators on the right
        -- Custom area to show workspace/tab numbers
        custom_areas = {
          right = function()
            local result = {}
            local current_tab = vim.fn.tabpagenr()
            local total_tabs = vim.fn.tabpagenr('$')
            
            -- Get standard system colors
            local normal_fg = vim.api.nvim_get_hl(0, { name = 'Normal' }).fg or 0xaaaaaa
            local normal_bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg or 0x000000
            local comment_fg = vim.api.nvim_get_hl(0, { name = 'Comment' }).fg or 0x666666
            
            -- For active tab: use String color (typically green/cyan - highly visible)
            local active_fg = vim.api.nvim_get_hl(0, { name = 'String' }).fg or 0x98c379
            -- For active bg: use PmenuSel (menu selection - guaranteed contrast)
            local active_bg = vim.api.nvim_get_hl(0, { name = 'PmenuSel' }).bg or 0x3e4451
            
            -- Add separator before tabs
            table.insert(result, { text = '  ', fg = comment_fg })
            
            -- Build tab indicators
            for i = 1, total_tabs do
              if i == current_tab then
                -- Current workspace - use high contrast system colors
                table.insert(result, { 
                  text = ' ' .. i .. ' ',
                  fg = active_fg,  -- Bright string color
                  bg = active_bg,  -- Menu selection background
                  bold = true,
                })
              else
                -- Inactive workspace - subtle
                table.insert(result, { 
                  text = ' ' .. i .. ' ',
                  fg = comment_fg,  -- Comment color (dimmed)
                  bg = normal_bg,   -- Normal background
                })
              end
              
              -- Add separator between tabs
              if i < total_tabs then
                table.insert(result, { text = '│', fg = comment_fg })
              end
            end
            
            table.insert(result, { text = '  ', fg = comment_fg })
            return result
          end,
        },
        
        -- Show tabs at the end
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        show_tab_indicators = false, -- Disabled - using custom_areas instead
        show_duplicate_prefix = true,
        persist_buffer_sort = true,
        
        -- Enforce regular tab size
        enforce_regular_tabs = false,
        always_show_bufferline = true,
        
        -- Offsets for file explorers
        offsets = {
          {
            filetype = 'neo-tree',
            text = '󰙅 File Explorer',
            text_align = 'center',
            separator = true,
          },
          {
            filetype = 'NvimTree',
            text = '󰙅 File Explorer',
            text_align = 'center',
            separator = true,
          },
        },
        
        -- Custom filter (hide certain buffers)
        custom_filter = function(buf_number, buf_numbers)
          -- Filter out file types
          if vim.bo[buf_number].filetype ~= 'qf' then
            return true
          end
        end,
        
        -- Sorting
        sort_by = 'insert_after_current',
      },
      
      -- Highlight groups (will use your colorscheme)
      highlights = {
        -- Current buffer (active)
        buffer_selected = {
          bold = true,
          italic = false,
        },
        -- Inactive buffers
        buffer_visible = {
          italic = false,
        },
        -- Diagnostics in selected buffer
        diagnostic_selected = {
          bold = true,
        },
        error_selected = {
          bold = true,
        },
        warning_selected = {
          bold = true,
        },
        info_selected = {
          bold = true,
        },
        hint_selected = {
          bold = true,
        },
      },
    },
    
    keys = function()
      local map_keys = {
        -- Buffer navigation
        { ']b', '<Cmd>BufferLineCycleNext<CR>', desc = 'Next buffer' },
        { '[b', '<Cmd>BufferLineCyclePrev<CR>', desc = 'Previous buffer' },
        { '>b', '<Cmd>BufferLineMoveNext<CR>', desc = 'Move buffer right' },
        { '<b', '<Cmd>BufferLineMovePrev<CR>', desc = 'Move buffer left' },
        
        -- Buffer close commands (directional)
        -- Note: <Leader>bd and <Leader>bo are defined in snacks.lua (smart delete)
        { '<Leader>bD', function()
          -- Close current buffer + all to the right
          require('snacks').bufdelete()
          vim.cmd('BufferLineCloseRight')
        end, desc = 'Delete buffer + buffers to right' },
        { '<Leader>bl', '<Cmd>BufferLineCloseLeft<CR>', desc = 'Delete buffers to left' },
        { '<Leader>br', '<Cmd>BufferLineCloseRight<CR>', desc = 'Delete buffers to right' },
        { '<Leader>bp', '<Cmd>BufferLineTogglePin<CR>', desc = 'Pin/unpin buffer' },
        
        -- Pick buffer (interactive)
        { '<Leader>bb', '<Cmd>BufferLinePick<CR>', desc = 'Pick buffer' },
        { '<Leader>bc', '<Cmd>BufferLinePickClose<CR>', desc = 'Pick buffer to close' },
        
        -- Sort buffers
        { '<Leader>bse', '<Cmd>BufferLineSortByExtension<CR>', desc = 'Sort by extension' },
        { '<Leader>bsd', '<Cmd>BufferLineSortByDirectory<CR>', desc = 'Sort by directory' },
        
        -- Workspace (tab) navigation
        -- Note: <Leader>wn and <Leader>wc already exist for new/close tab
        { ']w', '<Cmd>tabnext<CR>', desc = 'Next workspace' },
        { '[w', '<Cmd>tabprevious<CR>', desc = 'Previous workspace' },
        { '<Leader>wo', '<Cmd>tabonly<CR>', desc = 'Close other workspaces' },
      }
      
      -- Jump to buffer by number (1-9)
      for i = 1, 9 do
        table.insert(map_keys, {
          '<Leader>' .. i,
          '<Cmd>BufferLineGoToBuffer ' .. i .. '<CR>',
          desc = 'Go to buffer ' .. i
        })
      end
      
      return map_keys
    end,
  },
}
