# Adding a New Language/Framework to This Config

This guide walks you through adding a new language or framework to this Neovim configuration, following the established patterns and conventions.

## Overview

Languages in this config follow a modular structure:
- **Plugin configuration** in `lua/plugins/lang/{language}.lua`
- **Global keymaps** in `lua/keymaps/{language}.lua`
- **Which-key group registration** in `lua/plugins/core/editor.lua`
- **Cheatsheet documentation** in `lua/plugins/core/cheatsheet.lua`

## Step-by-Step Process

### 1. Create Language Plugin File

**Location**: `lua/plugins/lang/{language}.lua`

**Template Structure**:
```lua
-- ========================================================================
-- {LANGUAGE} PROFILE - Language-specific plugins and LSP configuration
-- ========================================================================
--
-- This file contains all {Language}-specific plugins and configurations.
-- These plugins will ONLY load when you open a .{ext} file, keeping your
-- startup time fast and avoiding conflicts with other languages.
--
-- Key features to configure here:
--   - {Language} LSP (via mason-tool-installer)
--   - Formatters, linters, debuggers
--   - Language-specific plugins
--   - Buffer-local keymaps (commands that only work in {lang} files)
--
-- Usage: Just open a .{ext} file and these plugins will automatically load!
-- ========================================================================

-- Load {Language} keymaps immediately (not buffer-local, always available)
require('keymaps.{language}')

return {
  -- ========================================================================
  -- {LANGUAGE} LSP - Language Server Protocol
  -- ========================================================================
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    ft = { '{filetype}' },
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        '{lsp-name}',      -- LSP server
        '{formatter}',      -- Formatter
        '{linter}',         -- Linter (optional)
      })
      return opts
    end,
  },

  -- ========================================================================
  -- {LANGUAGE} TREESITTER - Syntax highlighting
  -- ========================================================================
  {
    'nvim-treesitter/nvim-treesitter',
    ft = '{filetype}',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { '{parser-name}' })
      return opts
    end,
  },

  -- ========================================================================
  -- BUFFER-LOCAL KEYMAPS (Optional - only for file-specific commands)
  -- ========================================================================
  -- Only use this section for commands that MUST run in specific file types
  -- Examples: LSP-specific actions, file-type-dependent operations
  {
    'neovim/nvim-lspconfig',
    ft = { '{filetype}' },
    config = function()
      -- Add buffer-local keymaps on LSP attach
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('{language}-lsp-attach', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.name == '{lsp-name}' then
            local opts = { buffer = event.buf, silent = true }
            
            -- Example buffer-local keymap
            vim.keymap.set('n', '<leader>l{prefix}{key}', function()
              -- Command that only works in {lang} files
            end, vim.tbl_extend('force', opts, { desc = '{Language}: Description' }))
          end
        end,
      })
    end,
  },
}
```

### 2. Create Global Keymaps File

**Location**: `lua/keymaps/{language}.lua`

**Purpose**: Global keymaps available from ANY buffer (terminals, logs, other files).

**Template Structure**:
```lua
-- ========================================================================
-- {LANGUAGE} GLOBAL KEYMAPS - Always available (not buffer-local)
-- ========================================================================
-- Loaded eagerly at startup to make commands available from any buffer
-- This allows you to control {Language} projects from terminals, logs, etc.
-- ========================================================================

local toolcheck = require('utils.toolcheck')

-- NOTE: The <leader>l{prefix} group is registered globally in editor.lua

-- Example: Run project
vim.keymap.set('n', '<leader>l{prefix}r', function()
  if not toolcheck.check_{tool}() then
    return
  end
  vim.cmd('tabnew | terminal {command}')
  vim.notify('🚀 Running {language} project...', vim.log.levels.INFO)
end, { desc = '{Language}: Run project' })

-- Example: Build project
vim.keymap.set('n', '<leader>l{prefix}b', function()
  if not toolcheck.check_{tool}() then
    return
  end
  vim.cmd('tabnew | terminal {build-command}')
  vim.notify('📦 Building {language} project...', vim.log.levels.INFO)
end, { desc = '{Language}: Build' })

-- Add more keymaps following the same pattern...
```

### 3. Add Tool Check Function (if needed)

**Location**: `lua/utils/toolcheck.lua`

If your language requires a specific build tool, add a check function:

```lua
-- Check if {tool} is installed
function M.check_{tool}()
  if vim.fn.executable('{tool}') == 1 then
    return true
  end
  
  vim.notify(
    '❌ {Tool} not found!\n\n' ..
    'Install with Homebrew:\n' ..
    '  brew install {tool}\n\n' ..
    'Or visit: {installation-url}',
    vim.log.levels.ERROR
  )
  return false
end
```

### 4. Register Which-Key Group

**Location**: `lua/plugins/core/editor.lua`

Find the which-key groups section (around line 320) and add:

```lua
{ '<leader>l{prefix}', group = '{icon} {Language}' }, -- {Language} commands (globally accessible)
```

**Icon suggestions**:
- Python: `󰌠`
- Rust: `󱘗`
- Flutter: `󱓞`
- JavaScript/TypeScript: `󰛦`
- Go: `󰟓`
- Java: ``
- C/C++: ``

### 5. Update Cheatsheet

**Location**: `lua/plugins/core/cheatsheet.lua`

#### A. Update header comment (around line 70):

```lua
-- │  ├─ {Language} (GLOBAL) - <Space>l{prefix}{key1}/l{prefix}{key2}/l{prefix}{key3}...
```

#### B. Add cheatsheet entries (find appropriate section):

```lua
-- ============================================================
-- {LANGUAGE} (GLOBAL - available in all buffers)
-- ============================================================
{ category = '{Language}', key = '<Space>l{prefix}r', desc = 'Run project' },
{ category = '{Language}', key = '<Space>l{prefix}b', desc = 'Build project' },
{ category = '{Language}', key = '<Space>l{prefix}t', desc = 'Run tests' },
-- Add all your keymaps here...
```

## Conventions and Best Practices

### Keymap Prefix Convention

Each language gets a unique prefix under `<leader>l`:
- Python: `lp` (e.g., `<leader>lpr` = run, `<leader>lpt` = test)
- Rust: `lr` (e.g., `<leader>lrb` = build, `<leader>lrt` = test)
- Flutter: `lf` (e.g., `<leader>lfr` = reload, `<leader>lfq` = quit)
- Svelte/Web: `ls` (e.g., `<leader>lsr` = run dev, `<leader>lsb` = build)
- HTML: `lh` (e.g., `<leader>lhl` = live server)

**Choose a 1-letter prefix** that doesn't conflict with existing ones.

### Global vs Buffer-Local Keymaps

#### Use GLOBAL keymaps (`lua/keymaps/{language}.lua`) for:
- Build/run commands (can run from any buffer)
- Package management (add/remove dependencies)
- Project-wide operations (tests, lint, format entire project)
- Tool-specific workflows (cargo, npm, gradle, etc.)

#### Use BUFFER-LOCAL keymaps (in plugin file) for:
- LSP-specific actions (only work when LSP is attached)
- File-type-dependent operations (e.g., extracting Flutter widgets from Dart code)
- Commands that require the current file's context

**Golden Rule**: If you can run it from a terminal buffer, make it global!

### File Type Configuration

Use `ft` (filetype) for lazy loading:
```lua
ft = 'python',          -- Single filetype
ft = { 'rust', 'toml' }, -- Multiple filetypes
```

Common filetypes:
- Python: `python`
- Rust: `rust`
- JavaScript/TypeScript: `javascript`, `typescript`, `javascriptreact`, `typescriptreact`
- Dart: `dart`
- Go: `go`
- Java: `java`
- C/C++: `c`, `cpp`

### Notification Patterns

Use consistent emoji and formatting:
```lua
vim.notify('🚀 Running...', vim.log.levels.INFO)      -- Starting action
vim.notify('📦 Building...', vim.log.levels.INFO)     -- Build/compile
vim.notify('🧪 Running tests...', vim.log.levels.INFO) -- Testing
vim.notify('✓ Success!', vim.log.levels.INFO)         -- Success
vim.notify('❌ Error!', vim.log.levels.ERROR)          -- Error
vim.notify('⚠️  Warning!', vim.log.levels.WARN)        -- Warning
```

### Tool Checking Pattern

Always check if required tools are installed:
```lua
vim.keymap.set('n', '<leader>l{prefix}r', function()
  if not toolcheck.check_{tool}() then
    return  -- Exit early if tool not found
  end
  -- Run command...
end, { desc = 'Description' })
```

### Session Persistence

For custom commands that should persist across sessions, use `vim.g.` variables:
```lua
vim.g.{language}_custom_command = 'your-command'
```

Then add to `lua/plugins/core/session.lua` in the `save_extra_cmds`:
```lua
function()
  if vim.g.{language}_custom_command then
    return [[lua vim.g.{language}_custom_command = ]] .. string.format('%q', vim.g.{language}_custom_command)
  end
  return ''
end,
```

## Common Gotchas

### 1. Keymap Conflicts
- Always check existing keymaps before choosing a prefix
- Use `<leader>sc` in Neovim to search all keymaps
- Buffer-local and global keymaps with the same key will conflict in that buffer

### 2. Lazy Loading Issues
- If keymaps don't work, ensure `require('keymaps.{language}')` is called BEFORE the `return {}` statement
- The require must be at the top level, not inside a plugin spec

### 3. LSP Configuration
- LSP servers are configured in `lua/plugins/lsp/init.lua` (centralized)
- Only add LSP-specific keymaps in buffer-local sections if they absolutely need LSP context
- Most LSP actions (format, rename, etc.) are already available globally via `<Space>c` and `gr` prefixes

### 4. Tool Installation
- Always add tools to `mason-tool-installer.nvim` options
- Don't assume tools are installed - use `toolcheck` functions
- Provide clear installation instructions in error messages

### 5. Cheatsheet Maintenance
- Update BOTH the header comment and the data entries
- Keep descriptions concise but descriptive
- Mark global vs buffer-local clearly: "(any buffer)" vs "(Dart files)"

## Testing Your Changes

1. **Restart Neovim**: `<leader>Qa` (quit all and save session)
2. **Reopen project**: `cd your-project && nvim`
3. **Test keymaps**:
   - Open the language file to test buffer-local keymaps
   - Open a terminal buffer to test global keymaps
   - Press `<leader>l` to see which-key menu
4. **Check cheatsheet**: `<leader>sc` and search for your language
5. **Verify no conflicts**: Use `<leader>sc` to search for duplicate keymaps

## Example: Adding Go Support

Here's a complete example for adding Go:

### 1. `lua/plugins/lang/go.lua`
```lua
-- Load Go keymaps immediately
require('keymaps.go')

return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    ft = 'go',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        'gopls',        -- Go LSP
        'gofumpt',      -- Formatter
        'golangci-lint', -- Linter
      })
      return opts
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    ft = 'go',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'go' })
      return opts
    end,
  },
}
```

### 2. `lua/keymaps/go.lua`
```lua
local toolcheck = require('utils.toolcheck')

-- Run Go program
vim.keymap.set('n', '<leader>lgr', function()
  if not toolcheck.check_go() then return end
  vim.cmd('tabnew | terminal go run .')
  vim.notify('🚀 Running Go program...', vim.log.levels.INFO)
end, { desc = 'Go: Run' })

-- Build Go program
vim.keymap.set('n', '<leader>lgb', function()
  if not toolcheck.check_go() then return end
  vim.cmd('tabnew | terminal go build')
  vim.notify('📦 Building Go program...', vim.log.levels.INFO)
end, { desc = 'Go: Build' })
```

### 3. `lua/utils/toolcheck.lua` (add):
```lua
function M.check_go()
  if vim.fn.executable('go') == 1 then
    return true
  end
  vim.notify(
    '❌ Go not found!\n\nInstall with Homebrew:\n  brew install go',
    vim.log.levels.ERROR
  )
  return false
end
```

### 4. `lua/plugins/core/editor.lua` (add):
```lua
{ '<leader>lg', group = '󰟓 Go' }, -- Go commands (globally accessible)
```

### 5. `lua/plugins/core/cheatsheet.lua` (update header and add entries):
```lua
-- │  ├─ Go (GLOBAL) - <Space>lgr/lgb/lgt/lgf

{ category = 'Go', key = '<Space>lgr', desc = 'Run program' },
{ category = 'Go', key = '<Space>lgb', desc = 'Build program' },
```

## File Naming Conventions

- Plugin files: `lua/plugins/lang/{language}.lua` (lowercase, hyphenated if needed)
- Keymap files: `lua/keymaps/{language}.lua` (matches plugin filename)
- Use full names for clarity: `typescript.lua` not `ts.lua`

## Maintaining Documentation

When adding a language, update:
1. ✅ `lua/plugins/lang/{language}.lua` - Plugin configuration
2. ✅ `lua/keymaps/{language}.lua` - Global keymaps
3. ✅ `lua/plugins/core/editor.lua` - Which-key group
4. ✅ `lua/plugins/core/cheatsheet.lua` - Documentation
5. ✅ `lua/utils/toolcheck.lua` - Tool checking (if needed)

Happy coding! 🚀
