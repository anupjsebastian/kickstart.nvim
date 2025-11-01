# 🔌 Plugins Overview

Complete guide to all plugins in this configuration, organized by category.

---

## 📋 Plugin Categories

### Core Plugins
Essential plugins loaded on startup:
- **[Telescope](#telescope)** - Fuzzy finder for everything
- **[Neo-tree](#neo-tree)** - File explorer sidebar
- **[which-key](#which-key)** - Key binding discovery
- **[Snacks.nvim](snacks.md)** - 13 quality of life modules

### Editor Enhancement
Plugins that improve editing experience:
- **[Treesitter](#treesitter)** - Better syntax highlighting
- **[mini.nvim](#mini-nvim)** - Collection of small plugins
- **[Gitsigns](#gitsigns)** - Git integration in gutter
- **[Autopairs](#autopairs)** - Auto-close brackets/quotes

### LSP & Completion
Language intelligence:
- **[nvim-lspconfig](#lsp)** - LSP client configuration
- **[Mason](#mason)** - LSP/tool installer
- **[blink.cmp](#completion)** - Fast autocompletion
- **[conform.nvim](#formatting)** - Code formatting

### Debugging
Debug your code:
- **[nvim-dap](#debugging)** - Debug Adapter Protocol
- **[nvim-dap-ui](#debugging)** - Debug UI

### Language-Specific
- **[Flutter Tools](#flutter)** - Flutter/Dart development
- **[rustaceanvim](#rust)** - Enhanced Rust support
- **Python/Svelte** - See [Languages](../languages/README.md)

---

## 🎯 Core Plugins

### Telescope
**Purpose**: Fuzzy finder for files, text, symbols, and more

**Key Features**:
- Find files by name
- Live grep through codebase
- Search LSP symbols
- Browse git commits
- Search keymaps
- And 40+ built-in pickers!

**Essential Keymaps**:
| Key | Action |
|-----|--------|
| `<Space>sf` | Search files |
| `<Space>sg` | Search by grep (live) |
| `<Space>sw` | Search current word |
| `<Space>sd` | Search diagnostics |
| `<Space><Space>` | Find buffers |
| `<Space>sh` | Search help |
| `<Space>sk` | Search keymaps |

**Inside Telescope**:
| Key | Action |
|-----|--------|
| `<C-x>` | Open in horizontal split |
| `<C-v>` | Open in vertical split |
| `<C-t>` | Open in new tab |
| `<C-j>`/`<C-k>` | Navigate up/down |
| `?` | Show help |

**Configuration**: `lua/plugins/core/editor.lua`

---

### Neo-tree
**Purpose**: Modern file explorer sidebar

**Key Features**:
- Tree view of files/folders
- Git status indicators
- Diagnostic indicators
- Fuzzy file search
- File operations (add, delete, rename, copy, move)

**Keymaps**:
| Key | Action |
|-----|--------|
| `\` | Toggle Neo-tree |
| `a` | Add file/folder |
| `d` | Delete |
| `r` | Rename |
| `x` | Cut |
| `c` | Copy |
| `p` | Paste |
| `?` | Show all keymaps |

**Inside Neo-tree**:
- `<CR>` - Open file/expand folder
- `<C-x>` - Open in split
- `<C-v>` - Open in vsplit
- `<C-t>` - Open in new tab
- `/` - Search files
- `H` - Toggle hidden files

**Configuration**: `lua/plugins/core/neo-tree.lua`

---

### which-key
**Purpose**: Discover keymaps as you type

**Key Features**:
- Shows available keymaps after leader key
- Groups related commands
- Customizable descriptions
- Bottom-right floating window

**How to Use**:
1. Press `<Space>` (leader)
2. Wait ~300ms
3. See menu with all available commands
4. Press letter to execute or see submenu

**Examples**:
- `<Space>` → See all leader commands
- `<Space>g` → See all git commands
- `<Space>s` → See all search commands
- `<Space>d` → See all debug commands
- `]` → See all "next" navigation
- `[` → See all "previous" navigation

**Configuration**: `lua/plugins/core/editor.lua`

---

### Snacks.nvim
**Purpose**: Collection of 13 small, useful features

See **[Full Snacks Documentation](snacks.md)** for details on:
- Buffer deletion
- File renaming
- Scratch buffers
- Word highlighting
- Git browsing
- Notifications
- Dashboard
- And 6 more!

**Most Used**:
- `<Space>bd` - Delete buffer
- `<Space>.` - Scratch buffer
- `]]` / `[[` - Navigate word occurrences
- `<Space>gb` - Open in GitHub

---

## ✏️ Editor Enhancement

### Treesitter
**Purpose**: Advanced syntax highlighting and text objects

**Features**:
- Accurate syntax highlighting
- Incremental selection
- Text objects (functions, classes, etc.)
- Code folding support
- 40+ languages supported

**Text Objects**:
| Key | Action |
|-----|--------|
| `vaf` | Select around function |
| `vif` | Select inside function |
| `vac` | Select around class |
| `vic` | Select inside class |

**Incremental Selection**:
- Start with visual mode
- Expand selection intelligently
- Contract to previous

**Configuration**: `lua/plugins/core/treesitter.lua`

---

### mini.nvim
**Purpose**: Collection of independent Lua modules

**Active Modules**:

**mini.ai** - Extended text objects:
- `vai"` - Around quoted text including quotes
- `vi"` - Inside quoted text
- Works with (), [], {}, <>, and more

**mini.surround** - Surround operations:
- `sa` - Add surrounding
- `sd` - Delete surrounding
- `sr` - Replace surrounding
- Example: `saiw"` - Surround word with quotes

**mini.animate** - Smooth animations:
- Cursor movement animation
- Window resize animation
- Window open/close animation
- Scroll disabled (conflicts with snacks.scroll)

**Configuration**: `lua/plugins/core/extras.lua`

---

### Gitsigns
**Purpose**: Git integration in the sign column

**Features**:
- Visual git diff in gutter (+, ~, -)
- Hunk navigation
- Stage/unstage hunks
- Blame current line
- Preview changes

**Keymaps**:
| Key | Action |
|-----|--------|
| `]h` | Next git hunk |
| `[h` | Previous git hunk |
| `<Space>hs` | Stage hunk |
| `<Space>hr` | Reset hunk |
| `<Space>hS` | Stage buffer |
| `<Space>hu` | Undo stage hunk |
| `<Space>hp` | Preview hunk |
| `<Space>hb` | Blame line |

**Configuration**: `lua/kickstart/plugins/gitsigns.lua`

---

### Autopairs
**Purpose**: Auto-close brackets, quotes, and tags

**Features**:
- Auto-close `(`, `[`, `{`
- Auto-close `"`, `'`, `` ` ``
- Auto-close HTML tags
- Fast-wrap with Alt key
- Smart deletion

**Examples**:
- Type `(` → Inserts `()`  with cursor inside
- Type `"` → Inserts `""` with cursor inside
- Type `<div` → Completes `<div></div>`

**Configuration**: `lua/kickstart/plugins/autopairs.lua`

---

## 🧠 LSP & Completion

### LSP (Language Server Protocol)
**Purpose**: Language intelligence (autocomplete, diagnostics, navigation)

**Features**:
- 40+ language servers via Mason
- Automatic server detection
- Configuration per language
- Diagnostic display

**Universal LSP Keymaps**:
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Find references |
| `gi` | Go to implementation |
| `gt` | Go to type definition |
| `K` | Hover documentation |
| `<Space>.` | Code actions |
| `grn` | Rename symbol |

**Configuration**: `lua/plugins/lsp/init.lua`

---

### Mason
**Purpose**: LSP server and tool installer

**Features**:
- One-click LSP installation
- Manage formatters and linters
- Auto-install on demand
- 200+ tools available

**Usage**:
```vim
:Mason                    " Open Mason UI
" Navigate with j/k
" Press 'i' to install
" Press 'u' to update
" Press 'X' to uninstall
```

**Configuration**: `lua/plugins/lsp/init.lua`

---

### Completion (blink.cmp)
**Purpose**: Fast autocompletion engine

**Features**:
- LSP completions
- Snippet support
- Path completions
- Buffer word completions
- Ultra-fast performance

**In Insert Mode**:
| Key | Action |
|-----|--------|
| `<C-Space>` | Trigger completion |
| `<C-n>` | Next suggestion |
| `<C-p>` | Previous suggestion |
| `<CR>` | Confirm |
| `<C-e>` | Close |

**Configuration**: `lua/plugins/lsp/init.lua`

---

### Formatting (conform.nvim)
**Purpose**: Code formatting with multiple formatters

**Features**:
- Format on save (configurable)
- Multiple formatters per language
- Fallback to LSP formatting
- 50+ formatters supported

**Keymaps**:
| Key | Action |
|-----|--------|
| `<Space>cf` | Format current file |

**Formatters by Language**:
- **Lua**: stylua
- **Python**: ruff
- **Rust**: rustfmt
- **JavaScript/TypeScript**: prettier
- **And many more!**

**Configuration**: `lua/plugins/lsp/formatting.lua`

---

## 🐛 Debugging

### nvim-dap
**Purpose**: Debug Adapter Protocol client

**Features**:
- Set breakpoints
- Step through code
- Inspect variables
- Debug console/REPL
- Multiple language support

**Keymaps**:
| Key | Action |
|-----|--------|
| `<F5>` | Start/continue |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<Space>db` | Toggle breakpoint |
| `<Space>dB` | Conditional breakpoint |
| `<Space>dc` | Continue to cursor |

**Supported Languages**:
- Python (debugpy)
- Rust (lldb/gdb)
- Flutter/Dart (flutter-tools)
- JavaScript/TypeScript (coming soon)

**Configuration**: Language-specific (see language guides)

---

## 🎨 UI & Appearance

### Color scheme: Tokyonight
**Features**:
- Night/storm/day variants
- Treesitter support
- LSP highlight groups
- Terminal colors

**Toggle dark/light**: `<Space>tb`

### Statusline & Tabline
**Powered by**: mini.statusline

**Shows**:
- Mode indicator
- File name and status
- Git branch
- Diagnostics count
- LSP status
- Line/column position

### Dashboard
**Powered by**: snacks.dashboard

**Shows**:
- ASCII art header
- Recent files
- Quick actions
- Session restore
- Git status

**Auto-appears** when opening Neovim without arguments.

---

## 📊 Plugin Statistics

### Total Plugins: ~40
- **Core**: 8 plugins
- **Editor**: 6 plugins
- **LSP/Completion**: 5 plugins
- **Language-specific**: 4 plugins
- **Utilities**: 15+ plugins

### Startup Time: 38ms
- **Lazy-loaded**: 30+ plugins
- **Eager-loaded**: 8 plugins
- **On-demand**: Language plugins

### Memory Usage
- **Base**: ~50MB
- **With LSP**: ~150MB
- **Per language**: +20-50MB

---

## 🔧 Managing Plugins

### Lazy.nvim Commands

```vim
:Lazy                     " Open Lazy UI
:Lazy sync                " Install/update/clean plugins
:Lazy update              " Update all plugins
:Lazy clean               " Remove unused plugins
:Lazy profile             " Profile startup time
:Lazy log                 " View recent changes
:Lazy check               " Check for updates
```

### Adding New Plugins

1. **Create file** in `lua/plugins/`:
   ```bash
   nvim ~/.config/nvim/lua/plugins/my-plugin.lua
   ```

2. **Add plugin spec**:
   ```lua
   return {
     'author/plugin-name',
     opts = {
       -- configuration
     },
   }
   ```

3. **Restart Neovim** - Lazy automatically detects new files!

### Disabling Plugins

**Method 1**: Set `enabled = false`
```lua
return {
  'author/plugin',
  enabled = false,
}
```

**Method 2**: Delete or rename the file
```bash
mv lua/plugins/my-plugin.lua lua/plugins/my-plugin.lua.disabled
```

---

## 💡 Tips

### Discovering Features
1. Press `<Space>` and explore which-key menu
2. Open `:Lazy` to see all plugins
3. Check `:checkhealth` for status
4. Search cheatsheet: `<Space>sc`

### Performance
- Use `:Lazy profile` to check startup time
- Language plugins are lazy-loaded (`ft = 'python'`)
- Disable unused plugins
- Use `:checkhealth lazy` to diagnose issues

### Updating
```vim
:Lazy sync       " Recommended: sync everything
:Lazy update     " Update only
```

Run weekly or when you see issues!

---

## 📖 Resources

### Plugin Documentation
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- [Neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim)
- [which-key](https://github.com/folke/which-key.nvim)
- [Snacks](https://github.com/folke/snacks.nvim)
- [mini.nvim](https://github.com/echasnovski/mini.nvim)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)

### Plugin Managers
- [lazy.nvim](https://github.com/folke/lazy.nvim) - What we use!
- [Awesome Neovim](https://github.com/rockerBOO/awesome-neovim) - Plugin directory

---

<div align="center">

**Master your plugins, master your editor!**

[Snacks Guide →](snacks.md) | [Languages →](../languages/README.md) | [LSP →](../lsp/README.md)

[Back to Documentation](../README.md)

</div>
