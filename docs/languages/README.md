# 🌐 Language Support

Complete language-specific setup and configuration guides.

---

## 📋 Supported Languages

This configuration provides first-class support for multiple programming languages with dedicated LSP servers, formatters, linters, and custom keymaps.

### Currently Configured

- **[Flutter & Dart](flutter-dart.md)** - Complete Flutter development environment
- **[Python](python.md)** - Python with ruff, black, and debugging
- **[Rust](rust.md)** - Rust with rust-analyzer and cargo integration
- **[Svelte](svelte.md)** - Svelte with TypeScript support

### Additional LSP Support

The configuration automatically supports 40+ languages through Mason and nvim-lspconfig:
- **Web**: TypeScript/JavaScript, HTML, CSS, JSON
- **Systems**: C/C++, Go, Zig
- **Scripting**: Bash, Lua, Python, Ruby
- **Markup**: Markdown, YAML, TOML
- **And many more!**

---

## 🚀 Quick Start

### Opening Language-Specific Files

Language-specific plugins are **lazy-loaded** - they only activate when you open a file of that type:

```bash
# Open a Dart file - Flutter tools automatically load
nvim lib/main.dart

# Open a Python file - Python tools automatically load
nvim src/main.py

# Open a Rust file - Rust analyzer automatically loads
nvim src/main.rs
```

### First Time Setup

When you open a file in a supported language:

1. **LSP Server Auto-Install**: Mason will prompt to install the language server
2. **Wait for Installation**: First time setup takes 1-2 minutes
3. **Restart Optional**: Reload the file (`:e`) or restart Neovim
4. **Verify**: Run `:LspInfo` to see active language servers

---

## ⌨️ Universal Language Keymaps

These keymaps work across **all** languages with LSP support:

### Code Navigation
| Key | Description |
|-----|-------------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references (Telescope) |
| `gi` | Go to implementation |
| `gt` | Go to type definition |
| `K` | Show hover documentation |
| `<C-k>` | Show signature help (insert mode) |

### Code Actions
| Key | Description |
|-----|-------------|
| `<Leader>.` | Code actions at cursor |
| `gra` | Code actions (alternative) |
| `grn` | Rename symbol |
| `grr` | Go to references |

### Diagnostics
| Key | Description |
|-----|-------------|
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |
| `<Leader>sd` | Search all diagnostics (Telescope) |
| `<Leader>q` | Toggle diagnostic quickfix |

### Formatting
| Key | Description |
|-----|-------------|
| `<Leader>cf` | Format current file |
| Format on save | Automatic (if formatter available) |

---

## 📦 Adding New Languages

### Using Mason

1. **Open Mason UI**:
   ```vim
   :Mason
   ```

2. **Install Language Server**:
   - Press `/` to search
   - Navigate to the server
   - Press `i` to install

3. **Configure LSP** (if needed):
   ```lua
   -- In lua/plugins/lsp/init.lua
   servers = {
     your_language_server = {},
   }
   ```

### Creating Language-Specific Config

For complex setups (like Flutter), create a dedicated file:

```bash
# Create language config
touch ~/.config/nvim/lua/plugins/lang/your-language.lua
```

**Template**:
```lua
return {
  -- Language-specific plugins
  {
    'plugin/name',
    ft = 'your-filetype', -- Lazy load on filetype
    opts = {
      -- Configuration
    },
  },
}
```

---

## 🔧 Language Server Protocol (LSP)

### What is LSP?

LSP provides IDE-like features:
- **Autocomplete**: Intelligent code completion
- **Diagnostics**: Real-time error/warning detection
- **Go to Definition**: Jump to symbol definitions
- **Find References**: Find all usages of a symbol
- **Rename**: Rename symbols across your project
- **Hover Docs**: Show documentation on hover
- **Code Actions**: Quick fixes and refactorings

### Checking LSP Status

```vim
:LspInfo          " Show active LSP servers
:LspLog           " View LSP log
:Mason            " Manage language servers
:checkhealth lsp  " Diagnose LSP issues
```

### Common Issues

**LSP not starting?**
1. Check file type: `:set filetype?`
2. Verify server installed: `:Mason`
3. Check logs: `:LspLog`
4. Restart LSP: `:LspRestart`

**Autocomplete not working?**
1. Verify nvim-cmp is loaded: `:Lazy`
2. Check sources: `:CmpStatus`
3. Try manual trigger: `<C-Space>` in insert mode

---

## 📚 Language-Specific Guides

Click any language below for detailed setup, features, and keymaps:

<div align="center">

| Language | Guide | LSP Server | Formatter |
|----------|-------|------------|-----------|
| **Flutter/Dart** | [→ Guide](flutter-dart.md) | dartls (via flutter-tools) | dart format |
| **Python** | [→ Guide](python.md) | pyright / ruff | black / ruff |
| **Rust** | [→ Guide](rust.md) | rust-analyzer | rustfmt |
| **Svelte** | [→ Guide](svelte.md) | svelte-language-server | prettier |

</div>

---

## 🎯 Language Configuration Files

All language-specific configs are in `lua/plugins/lang/`:

```
lua/plugins/lang/
├── flutter.lua    # Flutter & Dart setup (444 lines)
├── python.lua     # Python setup with ruff
├── rust.lua       # Rust with cargo integration
└── svelte.lua     # Svelte with TypeScript
```

**Why separate files?**
- **Lazy Loading**: Only loads when you need it
- **Organization**: Easy to find and modify
- **Performance**: Minimal impact on startup time
- **Modularity**: Enable/disable entire languages easily

---

## 💡 Tips

### Startup Performance

Language plugins use `ft = 'filetype'` for lazy loading:
- **Before opening a Dart file**: 38ms startup
- **After opening a Dart file**: Flutter tools load on-demand
- **No penalty**: Other languages remain unloaded

### Multiple Languages

Open files in different languages - each gets its own LSP:
```bash
nvim lib/main.dart src/app.py main.rs
# Dart, Python, and Rust LSPs all active!
```

### Disabling a Language

Comment out the language file in your plugin manager or remove it from `lua/plugins/lang/`.

---

## 🔍 Debugging Language Issues

### LSP Not Working?

1. **Check Health**:
   ```vim
   :checkhealth lsp
   :checkhealth mason
   ```

2. **Verify Installation**:
   ```vim
   :Mason
   " Press 'i' on the language server to install
   ```

3. **Check Logs**:
   ```vim
   :LspLog
   " Look for connection errors or crashes
   ```

4. **Restart LSP**:
   ```vim
   :LspRestart
   ```

### Formatter Not Working?

1. **Check if formatter is installed**:
   ```vim
   :Mason
   " Search for formatter (e.g., black, prettier)
   ```

2. **Try manual format**:
   ```vim
   :Format
   " Or <Leader>cf
   ```

3. **Check conform.nvim**:
   ```vim
   :checkhealth conform
   ```

### Autocompletion Issues?

1. **Verify nvim-cmp sources**:
   ```vim
   :CmpStatus
   ```

2. **Check LSP capabilities**:
   ```vim
   :lua print(vim.inspect(vim.lsp.get_active_clients()[1].server_capabilities))
   ```

3. **Manual trigger**:
   ```vim
   " In insert mode
   <C-Space>
   ```

---

## 📖 Resources

### Learning LSP
- [LSP Specification](https://microsoft.github.io/language-server-protocol/)
- [nvim-lspconfig Docs](https://github.com/neovim/nvim-lspconfig)
- [Mason.nvim Guide](https://github.com/williamboman/mason.nvim)

### Language-Specific
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Python PEP 8](https://pep8.org/)
- [Rust Book](https://doc.rust-lang.org/book/)
- [Svelte Tutorial](https://svelte.dev/tutorial)

---

<div align="center">

**Choose your language and start coding!**

[Flutter/Dart →](flutter-dart.md) | [Python →](python.md) | [Rust →](rust.md) | [Svelte →](svelte.md)

[Back to Documentation](../README.md)

</div>
