-- ========================================================================
-- VIM TRAINING PLUGINS - Learn good Vim habits
-- ========================================================================
-- Plugins to help break bad habits and learn efficient Vim motions
--
-- Hardtime: Blocks repeated hjkl spam and other bad habits
-- Precognition: Shows available motions as hints on the current line
-- ========================================================================

return {
  -- Hardtime: Break bad habits by blocking inefficient patterns
  {
    'm4xshen/hardtime.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    event = 'VeryLazy',
    opts = {
      enabled = true,        -- Default enabled
      max_count = 3,         -- Max times you can press hjkl consecutively
      resetting_time = 5000, -- Reset counter after 3 seconds (default: 1000ms)
      disable_mouse = false,
      hint = true,           -- Show hints about better motions
      notification = true,
      allow_different_key = true,
      -- Restricted keys (common bad habits)
      restriction_mode = 'block', -- 'block' | 'hint'
      restricted_keys = {
        ['h'] = { 'n', 'x' },
        ['j'] = { 'n', 'x' },
        ['k'] = { 'n', 'x' },
        ['l'] = { 'n', 'x' },
        ['-'] = { 'n', 'x' },
        ['+'] = { 'n', 'x' },
        ['gj'] = { 'n', 'x' },
        ['gk'] = { 'n', 'x' },
        ['<CR>'] = { 'n', 'x' },
        ['<C-M>'] = { 'n', 'x' },
        ['<C-N>'] = { 'n', 'x' },
        ['<C-P>'] = { 'n', 'x' },
      },
      -- Disable in certain buffer types
      disabled_filetypes = {
        'qf',
        'netrw',
        'NvimTree',
        'neo-tree',
        'lazy',
        'mason',
        'oil',
        'TelescopePrompt',
      },
    },
  },

  -- Precognition: Show available motions as inline hints
  {
    'tris203/precognition.nvim',
    event = 'VeryLazy',
    opts = {
      enabled = true, -- Default enabled
      startVisible = true,
      showBlankVirtLine = true,
      highlightColor = { link = 'Comment' },
      hints = {
        Caret = { text = '^', prio = 2 },
        Dollar = { text = '$', prio = 1 },
        MatchingPair = { text = '%', prio = 5 },
        Zero = { text = '0', prio = 1 },
        w = { text = 'w', prio = 10 },
        b = { text = 'b', prio = 9 },
        e = { text = 'e', prio = 8 },
        W = { text = 'W', prio = 7 },
        B = { text = 'B', prio = 6 },
        E = { text = 'E', prio = 5 },
      },
      gutterHints = {
        G = { text = 'G', prio = 10 },
        gg = { text = 'gg', prio = 9 },
        PrevParagraph = { text = '{', prio = 8 },
        NextParagraph = { text = '}', prio = 8 },
      },
      -- Disable in certain filetypes
      disabled_fts = {
        'qf',
        'netrw',
        'NvimTree',
        'neo-tree',
        'lazy',
        'mason',
        'oil',
        'TelescopePrompt',
        'Trouble',
        'help',
      },
    },
  },
}
