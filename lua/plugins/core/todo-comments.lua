-- ========================================================================
-- TODO-COMMENTS.NVIM - Unified TODO/FIXME/HACK/NOTE/XXX management
-- ========================================================================
-- Integrates folke/todo-comments.nvim for highlighting, navigation, Telescope,
-- quickfix, and loclist support. Disables virtual text for TODOs, but keeps it
-- for diagnostics. Adds jump mappings and which-key labels.
-- ========================================================================

return {
  'folke/todo-comments.nvim',
  event = 'VeryLazy',
  dependencies = { 
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim', -- Required for TodoTelescope command
  },
  opts = {
    signs = true, -- show icons in the sign column
    sign_priority = 8, -- priority of the sign (higher = more visible)
    keywords = {
      FIX = { icon = ' ', color = 'error', alt = { 'FIXME', 'BUG', 'FIXIT', 'ISSUE' } },
      TODO = { icon = ' ', color = 'info' },
      HACK = { icon = ' ', color = 'warning' },
      WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
      PERF = { icon = '󰓅 ', color = 'default', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
      NOTE = { icon = '󰎞 ', color = 'hint', alt = { 'INFO' } },
    },
    merge_keywords = true,
    highlight = {
      multiline = true,
      multiline_pattern = '^.',
      multiline_context = 10,
      before = '',
      keyword = 'wide',
      after = 'fg',
      pattern = [[.*<(KEYWORDS)\s*:]],
      comments_only = true,
      max_line_len = 400,
      exclude = {},
    },
    colors = {
      error = { 'DiagnosticError', 'ErrorMsg', '#DC2626' },
      warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
      info = { 'DiagnosticInfo', '#001effff' },
      hint = { 'DiagnosticHint', '#10B981' },
      default = { 'Identifier', '#7C3AED' },
    },
    search = {
      command = 'rg',
      args = {
        '--color=never', '--no-heading', '--with-filename',
        '--line-number', '--column', '--hidden',
      },
      pattern = [[\b(KEYWORDS):]],
    },
    -- Disable virtual text for TODOs (but keep for diagnostics)
    virtual_text = false,
  },
  config = function(_, opts)
    require('todo-comments').setup(opts)
    
    -- Load Telescope extension
    pcall(require('telescope').load_extension, 'todo-comments')
    
    -- Define custom signs for TODO comments (since the plugin doesn't create them by default)
    vim.fn.sign_define('TodoSignFIX', { text = '', texthl = 'TodoFgFIX' })
    vim.fn.sign_define('TodoSignTODO', { text = ' ', texthl = 'TodoFgTODO' })
    vim.fn.sign_define('TodoSignHACK', { text = ' ', texthl = 'TodoFgHACK' })
    vim.fn.sign_define('TodoSignWARN', { text = ' ', texthl = 'TodoFgWARN' })
    vim.fn.sign_define('TodoSignPERF', { text = '󰓅', texthl = 'TodoFgPERF' })
    vim.fn.sign_define('TodoSignNOTE', { text = '󰎞', texthl = 'TodoFgNOTE' })
    
    -- Auto-place signs when buffer is loaded
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'TextChanged', 'InsertLeave' }, {
      pattern = '*',
      callback = function(args)
        local bufnr = args.buf
        if vim.bo[bufnr].buftype ~= '' then return end
        
        -- Clear existing TODO signs
        vim.fn.sign_unplace('todo_signs', { buffer = bufnr })
        
        -- Search for TODO keywords and place signs
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local keywords = { 
          { pattern = 'TODO:', sign = 'TodoSignTODO' },
          { pattern = 'FIXME:', sign = 'TodoSignFIX' },
          { pattern = 'FIX:', sign = 'TodoSignFIX' },
          { pattern = 'BUG:', sign = 'TodoSignFIX' },
          { pattern = 'HACK:', sign = 'TodoSignHACK' },
          { pattern = 'WARN:', sign = 'TodoSignWARN' },
          { pattern = 'WARNING:', sign = 'TodoSignWARN' },
          { pattern = 'XXX:', sign = 'TodoSignWARN' },
          { pattern = 'PERF:', sign = 'TodoSignPERF' },
          { pattern = 'NOTE:', sign = 'TodoSignNOTE' },
          { pattern = 'INFO:', sign = 'TodoSignNOTE' },
        }
        
        for lnum, line in ipairs(lines) do
          for _, kw in ipairs(keywords) do
            if line:match(kw.pattern) then
              vim.fn.sign_place(0, 'todo_signs', kw.sign, bufnr, { lnum = lnum, priority = 8 })
              break
            end
          end
        end
      end,
    })
    
    -- Keymaps for navigation
    vim.keymap.set('n', ']t', function()
      require('todo-comments').jump_next()
    end, { desc = 'Next TODO comment' })
    vim.keymap.set('n', '[t', function()
      require('todo-comments').jump_prev()
    end, { desc = 'Prev TODO comment' })
    -- Telescope integration
    vim.keymap.set('n', '<leader>st', function()
      vim.cmd('TodoTelescope')
    end, { desc = 'Search TODOs (Telescope)' })
    -- Quickfix/loclist integration
    vim.keymap.set('n', '<leader>xt', '<cmd>TodoQuickFix<cr>', { desc = 'TODOs to Quickfix' })
    vim.keymap.set('n', '<leader>xT', '<cmd>TodoLocList<cr>', { desc = 'TODOs to Loclist' })
  end,
}
