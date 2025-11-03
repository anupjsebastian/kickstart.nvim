-- ========================================================================
-- ICONS - Centralized icon definitions
-- ========================================================================
-- Single source of truth for all icons used across the configuration
-- Maintains visual consistency and makes updates easier
-- ========================================================================

local M = {}

-- ========================================================================
-- DIAGNOSTICS
-- ========================================================================
M.diagnostics = {
  Error = ' ',
  Warn = ' ',
  Hint = ' ',
  Info = ' ',
}

-- ========================================================================
-- GIT
-- ========================================================================
M.git = {
  added = '',
  changed = '',
  deleted = '',
  renamed = '➜',
  untracked = '?',
  ignored = '◌',
  unstaged = '✗',
  staged = '✓',
  conflict = '!',
}

-- ========================================================================
-- FILE TYPES
-- ========================================================================
M.filetype = {
  default = '',
  folder = '',
  folder_open = '',
  folder_empty = '',
  file = '',
}

-- ========================================================================
-- UI ELEMENTS
-- ========================================================================
M.ui = {
  separator = '│',
  line = '─',
  corner = '└',
  branch = '├',
  arrow_right = '',
  arrow_left = '',
  arrow_up = '',
  arrow_down = '',
  check = '✓',
  cross = '✗',
  dot = '●',
  circle = '○',
  lock = '',
  unlock = '',
  search = '',
  settings = '',
  history = '',
  close = '',
}

-- ========================================================================
-- DEBUG
-- ========================================================================
M.debug = {
  breakpoint = '',
  breakpoint_condition = '',
  breakpoint_rejected = '',
  log_point = '',
  stopped = '',
  expanded = '▾',
  collapsed = '▸',
  current_frame = '*',
}

-- ========================================================================
-- LSP
-- ========================================================================
M.lsp = {
  error = ' ',
  warn = ' ',
  hint = ' ',
  info = ' ',
  ok = ' ',
  loading = ' ',
}

-- ========================================================================
-- KINDS (LSP completion item kinds)
-- ========================================================================
M.kinds = {
  Text = '󰉿',
  Method = '󰊕',
  Function = '󰊕',
  Constructor = '󰒓',
  Field = '󰜢',
  Variable = '󰀫',
  Class = '󰠱',
  Interface = '󰜰',
  Module = '󰆧',
  Property = '󰖷',
  Unit = '󰑭',
  Value = '󰎠',
  Enum = '󰎠',
  Keyword = '󰌋',
  Snippet = '',
  Color = '󰏘',
  File = '󰈔',
  Reference = '󰈇',
  Folder = '󰉋',
  EnumMember = '󰎠',
  Constant = '󰏿',
  Struct = '󰙅',
  Event = '󱐋',
  Operator = '󰆕',
  TypeParameter = '󰊄',
}

-- ========================================================================
-- NOTIFICATIONS
-- ========================================================================
M.notify = {
  error = ' ',
  warn = ' ',
  info = ' ',
  debug = ' ',
  trace = ' ',
}

-- ========================================================================
-- MISC
-- ========================================================================
M.misc = {
  vim = '',
  neovim = '',
  terminal = '',
  package = '',
  plugin = '',
  git = '',
  github = '',
  dashboard = '',
  lazy = '󰒲 ',
  mason = '',
  copilot = '',
  telescope = '',
  tree = '',
  scratch = '󰎞',
}

return M
