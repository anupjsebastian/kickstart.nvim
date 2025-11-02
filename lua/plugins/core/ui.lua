-- ========================================================================
-- UI PLUGINS
-- ========================================================================
-- Visual enhancements and UI components
-- - Colorscheme: tokyonight
-- - Statusline: lualine (LazyVim-style)
-- - Treesitter: Syntax highlighting
-- - Mini modules: Textobjects, surround, pairs
-- - Todo comments: Highlight TODOs/FIXMEs
-- ========================================================================

return {
  -- Colorscheme
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      require('tokyonight').setup {
        styles = {
          comments = { italic = false },
        },
      }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  -- Beautiful statusline (LazyVim-style)
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    opts = function()
      local icons = {
        diagnostics = {
          Error = ' ',
          Warn = ' ',
          Hint = ' ',
          Info = ' ',
        },
        git = {
          added = ' ',
          modified = ' ',
          removed = ' ',
        },
      }

      return {
        options = {
          theme = 'tokyonight',
          globalstatus = true,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = { 'dashboard', 'alpha', 'starter' },
          },
        },
        sections = {
          lualine_a = {
            {
              'mode',
              fmt = function(str)
                return str:sub(1, 1)
              end,
            },
            {
              -- Macro recording indicator
              function()
                local reg = vim.fn.reg_recording()
                if reg == '' then
                  return ''
                end
                return '󰑋 @' .. reg
              end,
              color = { fg = '#ff9e64', gui = 'bold' },
            },
          },
          lualine_b = {
            {
              'branch',
              icon = '',
            },
          },
          lualine_c = {
            {
              'diagnostics',
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            {
              'filetype',
              icon_only = true,
              separator = '',
              padding = { left = 1, right = 0 },
            },
            {
              'filename',
              path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
              symbols = {
                modified = '  ',
                readonly = ' ',
                unnamed = '[No Name]',
              },
            },
          },
          lualine_x = {
            {
              'diff',
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
            },
          },
          lualine_y = {
            {
              'progress',
              separator = ' ',
              padding = { left = 1, right = 0 },
            },
            {
              'location',
              padding = { left = 0, right = 1 },
            },
          },
          lualine_z = {
            function()
              return ' ' .. os.date '%R'
            end,
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = {},
      }
    end,
  },

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VeryLazy', -- Deferred for faster startup
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  -- Mini.nvim collection
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      require('mini.surround').setup()

      -- Autopairs - automatically close brackets, quotes, etc.
      require('mini.pairs').setup()
    end,
  },

  -- vim-repeat: Enable repeating plugin maps with '.'
  {
    'tpope/vim-repeat',
    event = 'VeryLazy',
  },

  -- Treesitter: Syntax highlighting and code understanding
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = 'VeryLazy', -- Deferred for faster startup
    priority = 50, -- Load after other VeryLazy plugins
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'javascript',
        'typescript',
        'css',
        'json',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby', 'dart' } }, -- Dart: Treesitter indent too aggressive for widget trees
      fold = {
        enable = true,
      },
    },
  },
}
