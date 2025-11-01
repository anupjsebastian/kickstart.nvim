# 🐍 Python Development Guide

Complete Python development setup with LSP, formatting, linting, and debugging.

---

## 📋 Overview

This configuration provides a modern Python development environment with:

- **LSP Server**: Pyright for intelligent code completion
- **Formatter**: Ruff (ultra-fast Python formatter and linter)
- **Auto-install**: Tools automatically installed via Mason
- **Virtual Environment**: Automatic venv detection
- **Debug Support**: Python debugging with nvim-dap
- **Format on Save**: Automatic code formatting

**Startup Time**: Python tools only load when you open a `.py` file - zero impact on startup!

---

## 🚀 Quick Start

### First Time Setup

1. **Open a Python file**:
   ```bash
   nvim myproject/main.py
   ```

2. **Auto-installation begins**:
   - Pyright LSP server installs automatically
   - Ruff formatter/linter installs automatically
   - Wait 30-60 seconds for completion

3. **Verify installation**:
   ```vim
   :Mason
   " Check that 'pyright' and 'ruff' show as installed
   ```

4. **Start coding**:
   - Type `import ` and see autocomplete suggestions!
   - Errors and warnings appear inline
   - Format with `<Leader>cf` or save (auto-format)

---

## ⚙️ Features

### Intelligent Code Completion

Pyright provides:
- **Import suggestions**: Auto-complete module imports
- **Method completion**: See available methods as you type
- **Type hints**: Type information for parameters and return values
- **Documentation**: Hover docs with `K`
- **Signature help**: Function signatures while typing

**Trigger**: Autocomplete appears automatically, or press `<C-Space>`

### Real-Time Diagnostics

See errors and warnings as you type:
- **Syntax errors**: Red underlines and error messages
- **Type errors**: Type checking via Pyright
- **Style issues**: PEP 8 violations via Ruff
- **Unused imports**: Highlighted and can be auto-removed

**Navigate errors**:
- `]d` - Next diagnostic
- `[d` - Previous diagnostic
- `<Leader>sd` - Search all diagnostics (Telescope)

### Code Formatting

Ruff formatter:
- **Ultra-fast**: 10-100x faster than Black
- **PEP 8 compliant**: Follows Python style guide
- **Auto-fix**: Fixes many linting issues automatically
- **On-save formatting**: Automatic (configurable)

**Manual format**: `<Leader>cf`

### Virtual Environment Detection

Automatically detects and uses your venv:
- `.venv/` - Standard Python venv
- `venv/` - Alternative location
- `Pipenv` - Pipenv environments
- `Poetry` - Poetry environments
- `conda` - Conda environments

**Check active Python**:
```vim
:lua print(vim.lsp.get_active_clients()[1].config.settings.python.pythonPath)
```

---

## ⌨️ Python Keymaps

### LSP Navigation
| Key | Description |
|-----|-------------|
| `gd` | Go to definition |
| `gr` | Find references (Telescope) |
| `gi` | Go to implementation |
| `gt` | Go to type definition |
| `K` | Show hover documentation |
| `<C-k>` | Signature help (insert mode) |

### Code Actions
| Key | Description |
|-----|-------------|
| `<Leader>.` | Show code actions |
| `grn` | Rename symbol |
| `<Leader>cf` | Format file (Ruff) |

### Diagnostics
| Key | Description |
|-----|-------------|
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |
| `<Leader>sd` | Search diagnostics (Telescope) |
| `<Leader>q` | Toggle diagnostic quickfix |

### Python-Specific (coming soon)
| Key | Description |
|-----|-------------|
| `<Leader>pr` | Run Python file |
| `<Leader>pt` | Run pytest |
| `<Leader>pd` | Start Python debugger |

---

## 🔧 Configuration

### LSP Server (Pyright)

**Location**: `lua/plugins/lang/python.lua`

```lua
-- Pyright configuration
settings = {
  python = {
    analysis = {
      typeCheckingMode = "basic", -- off/basic/strict
      autoSearchPaths = true,
      useLibraryCodeForTypes = true,
      diagnosticMode = "workspace", -- openFilesOnly/workspace
    }
  }
}
```

**Customization**:
- Change type checking strictness
- Configure import analysis
- Set Python path manually

### Formatter (Ruff)

**Location**: `lua/plugins/lsp/formatting.lua` (conform.nvim)

```lua
python = { "ruff" },
```

**Options**:
- Enable/disable format on save
- Configure line length
- Add custom Ruff rules

---

## 🐛 Debugging Python

### Setup

Python debugging uses `nvim-dap` with `debugpy`:

```bash
# Install debugpy in your venv
pip install debugpy
```

### Debug Keymaps (available when DAP is configured)

| Key | Description |
|-----|-------------|
| `<F5>` | Start/continue debugging |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<Leader>db` | Toggle breakpoint |
| `<Leader>dB` | Set conditional breakpoint |
| `<Leader>dc` | Continue to cursor |

### Debug Workflow

1. **Set breakpoints**: `<Leader>db` on a line
2. **Start debugging**: `<F5>`
3. **Navigate**: Use F10/F11/F12 to step through code
4. **Inspect variables**: Hover over variables or check debug sidebar
5. **REPL**: Evaluate expressions in debug console

---

## 📦 Tools & Versions

### Installed Tools

| Tool | Purpose | Auto-Install |
|------|---------|--------------|
| **pyright** | LSP server for Python | ✅ Yes |
| **ruff** | Formatter & linter | ✅ Yes |
| **debugpy** | Python debugger | ⚠️ Manual (`pip install debugpy`) |

### Checking Installations

```vim
:Mason                    " See all installed tools
:LspInfo                  " Check active LSP servers
:checkhealth mason        " Diagnose Mason issues
:checkhealth lsp          " Diagnose LSP issues
```

---

## 🎯 Common Tasks

### Setting Up a New Python Project

```bash
# Create project
mkdir myproject && cd myproject

# Create virtual environment
python3 -m venv .venv

# Activate venv
source .venv/bin/activate  # macOS/Linux
# or
.venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements.txt

# Open in Neovim
nvim main.py
```

Neovim will automatically:
1. Detect the `.venv` directory
2. Start Pyright with the venv Python
3. Enable autocomplete and diagnostics

### Type Checking Strictness

Edit Pyright settings in `lua/plugins/lang/python.lua`:

```lua
typeCheckingMode = "basic"   -- Recommended
-- or
typeCheckingMode = "strict"  -- Very strict, like mypy
-- or
typeCheckingMode = "off"     -- Disable type checking
```

### Format on Save

**Enable** (in `lua/plugins/lsp/formatting.lua`):
```lua
format_on_save = {
  timeout_ms = 500,
  lsp_fallback = true,
}
```

**Disable**:
```lua
format_on_save = false,
```

### Using Alternative Formatters

Prefer Black over Ruff? Edit `lua/plugins/lsp/formatting.lua`:

```lua
python = { "black", "isort" },  -- Black + isort
-- or
python = { "ruff" },            -- Ruff (default)
```

Then install: `:MasonInstall black isort`

---

## 🔍 Troubleshooting

### LSP Not Starting

**Check active clients**:
```vim
:LspInfo
" Should show 'pyright' as active
```

**If not active**:
1. Ensure pyright is installed: `:Mason`
2. Check file type: `:set filetype?` (should be "python")
3. Restart LSP: `:LspRestart`
4. Check logs: `:LspLog`

### Wrong Python Interpreter

**Check current Python**:
```vim
:lua print(vim.lsp.get_active_clients()[1].config.settings.python.pythonPath)
```

**Force specific Python**:
Edit `lua/plugins/lang/python.lua` and set:
```lua
pythonPath = "/path/to/your/python"
```

### Autocomplete Not Working

1. **Check nvim-cmp**: `:Lazy` (should show blink.cmp loaded)
2. **Check LSP capabilities**: `:lua print(vim.inspect(vim.lsp.get_active_clients()[1].server_capabilities))`
3. **Manual trigger**: `<C-Space>` in insert mode
4. **Check source**: `:lua print(vim.inspect(require('blink.cmp').get_lsp_capabilities()))`

### Formatting Not Working

1. **Check Ruff installed**: `:Mason` (look for "ruff")
2. **Manual format**: `<Leader>cf` or `:Format`
3. **Check conform**: `:checkhealth conform`
4. **Check formatter**: `:lua print(require('conform').list_formatters(0)[1].name)`

### Virtual Environment Not Detected

**Manual activation**:
```vim
:lua vim.lsp.stop_client(vim.lsp.get_active_clients())
" Then edit settings in lua/plugins/lang/python.lua to set pythonPath
:e  " Reload file
```

---

## 💡 Tips & Tricks

### Import Sorting

Ruff automatically sorts imports on format:
- Standard library imports first
- Third-party imports second
- Local imports last
- Alphabetically within each group

### Type Hints

Add type hints for better completions:
```python
def greet(name: str) -> str:
    return f"Hello, {name}!"

# Pyright knows the return type!
result = greet("World")  # result is str
```

### Quick Fixes

Use code actions for quick fixes:
1. Place cursor on error/warning
2. Press `<Leader>.`
3. Select fix from menu

Common fixes:
- Add missing imports
- Remove unused imports
- Fix indentation
- Add type annotations

### Documentation Strings

Pyright shows docstrings in hover:
```python
def my_function():
    """This documentation appears when you hover!"""
    pass
```

Hover with `K` to see your docs.

---

## 📖 Resources

### Python Documentation
- [Python Docs](https://docs.python.org/)
- [PEP 8 Style Guide](https://pep8.org/)
- [Type Hints Guide](https://docs.python.org/3/library/typing.html)

### Tool Documentation
- [Pyright Documentation](https://github.com/microsoft/pyright)
- [Ruff Documentation](https://docs.astral.sh/ruff/)
- [nvim-dap Python](https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#python)

### Learning Resources
- [Real Python](https://realpython.com/)
- [Python Tutorial](https://docs.python.org/3/tutorial/)
- [Type Hints Tutorial](https://realpython.com/python-type-checking/)

---

<div align="center">

**Happy Python coding!** 🐍

[← Back to Languages](README.md) | [Rust →](rust.md) | [Svelte →](svelte.md)

</div>
