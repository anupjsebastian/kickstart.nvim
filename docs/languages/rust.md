# 🦀 Rust Development Guide

Complete Rust development setup with rust-analyzer, cargo integration, and debugging.

---

## 📋 Overview

This configuration provides a professional Rust development environment with:

- **LSP Server**: rust-analyzer for intelligent code completion
- **Rust Tools**: rustaceanvim for enhanced Rust features
- **Cargo Integration**: Run, test, and build from within Neovim
- **Clippy Lints**: Real-time linting with Clippy
- **Debugging**: Full DAP integration for Rust debugging
- **Inlay Hints**: Type hints and parameter names inline
- **Format on Save**: Automatic rustfmt formatting

**Startup Time**: Rust tools only load when you open a `.rs` file!

---

## 🚀 Quick Start

### First Time Setup

1. **Install Rust toolchain** (if not already):
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```

2. **Open a Rust file**:
   ```bash
   nvim src/main.rs
   ```

3. **Auto-installation**:
   - rust-analyzer installs automatically via Mason
   - Wait 30-60 seconds for first-time setup

4. **Verify**:
   ```vim
   :LspInfo
   " Should show 'rust_analyzer' as active
   ```

---

## ⚙️ Features

### Intelligent Completion

rust-analyzer provides:
- **Struct/enum completion**: Auto-complete with field names
- **Method suggestions**: See available methods on types
- **Import assistance**: Auto-import missing types
- **Macro expansion**: Understand macro-generated code
- **Type inference**: See inferred types inline

### Real-Time Diagnostics

- **Compiler errors**: See errors as you type
- **Clippy lints**: Best practice suggestions
- **Unused code warnings**: Highlighted unused imports/variables
- **Type mismatches**: Immediate feedback on type errors

### Cargo Integration

Run cargo commands without leaving Neovim:
- **Build**: Compile your project
- **Run**: Execute binaries and examples
- **Test**: Run test suites
- **Check**: Fast syntax checking
- **Clippy**: Lint your code

### Inlay Hints

See type information inline:
- Parameter names in function calls
- Inferred types for variables
- Return types for closures
- Chain method types

Toggle with `<Leader>th`

---

## ⌨️ Rust Keymaps

### Standard LSP Navigation
| Key | Description |
|-----|-------------|
| `gd` | Go to definition |
| `gr` | Find references (Telescope) |
| `gi` | Go to implementation |
| `gt` | Go to type definition |
| `K` | Show hover documentation |
| `<C-k>` | Signature help (insert mode) |

### Rust-Specific Actions (`<Leader>r`)
| Key | Description |
|-----|-------------|
| `<Leader>rr` | Show runnables (run/test/bench) |
| `<Leader>rd` | Show debuggables |
| `<Leader>ra` | Code actions |
| `<Leader>rh` | Hover actions |
| `<Leader>re` | Explain error under cursor |
| `<Leader>rm` | Expand macro |
| `<Leader>rj` | Join lines smartly |
| `<Leader>rp` | Go to parent module |
| `<Leader>rC` | Open Cargo.toml |

### Code Actions
| Key | Description |
|-----|-------------|
| `<Leader>.` | Show code actions |
| `grn` | Rename symbol |
| `<Leader>cf` | Format file (rustfmt) |

### Diagnostics
| Key | Description |
|-----|-------------|
| `]d` | Next diagnostic |
| `[d` | Previous diagnostic |
| `<Leader>sd` | Search diagnostics (Telescope) |

---

## 🔧 Cargo Integration

### Runnables (`<Leader>rr`)

Press `<Leader>rr` to see:
- **Run main**: Execute `src/main.rs`
- **Run examples**: Execute files in `examples/`
- **Run tests**: Individual test functions
- **Run benches**: Benchmark tests
- **Custom commands**: Any `cargo run` command

**Example**:
```rust
// Place cursor in main() and press <Leader>rr
fn main() {
    println!("Hello, world!");
}
// Menu shows: "Run main"
```

### Testing

**Run specific test**:
```rust
#[test]
fn test_addition() {
    // Place cursor here, press <Leader>rr
    assert_eq!(2 + 2, 4);
}
// Menu shows: "Run test test_addition"
```

**Run all tests**:
```bash
# In terminal
:!cargo test
```

### Building

```vim
:!cargo build           " Debug build
:!cargo build --release " Release build
:!cargo check           " Fast syntax check
:!cargo clippy          " Run clippy lints
```

---

## 🐛 Debugging Rust

### Setup

Rust debugging uses `lldb` (macOS/Linux) or `msvc` (Windows):

```bash
# macOS (Xcode Command Line Tools includes lldb)
xcode-select --install

# Linux
sudo apt install lldb  # Debian/Ubuntu
```

### Debug Keymaps

| Key | Description |
|-----|-------------|
| `<F5>` | Start/continue debugging |
| `<F10>` | Step over |
| `<F11>` | Step into |
| `<F12>` | Step out |
| `<Leader>db` | Toggle breakpoint |
| `<Leader>dB` | Conditional breakpoint |
| `<Leader>dc` | Continue to cursor |

### Debug Workflow

1. **Open debuggables**: `<Leader>rd`
2. **Select target**: Choose binary or test
3. **Set breakpoints**: `<Leader>db` on lines
4. **Start debugging**: Selected from menu
5. **Step through**: Use F10/F11/F12
6. **Inspect**: Hover over variables

---

## 🎯 Common Tasks

### Creating a New Rust Project

```bash
# Create binary project
cargo new myproject
cd myproject

# Open in Neovim
nvim src/main.rs

# Or create library
cargo new --lib mylib
```

### Adding Dependencies

1. **Open Cargo.toml**: `<Leader>rC` (from any Rust file)
2. **Add dependency**:
   ```toml
   [dependencies]
   serde = "1.0"
   ```
3. **Save and build**: `:!cargo build`

rust-analyzer will automatically recognize new dependencies!

### Macro Expansion

Curious what a macro does?

```rust
println!("Hello");  // Place cursor here
// Press <Leader>rm
// See: std::io::_print(format_args!("Hello\n"));
```

### Explain Errors

Confused by a compiler error?

```rust
let x: i32 = "hello";  // Type error
// Place cursor on error, press <Leader>re
// See detailed explanation with examples!
```

### Code Actions

Press `<Leader>.` or `<Leader>ra` to:
- Add missing imports
- Implement missing trait methods
- Fill in struct fields
- Generate `Debug`, `Clone`, etc.
- Extract functions/variables
- Inline variables

---

## ⚙️ Configuration

### rust-analyzer Settings

**Location**: `lua/plugins/lang/rust.lua`

```lua
['rust-analyzer'] = {
  cargo = {
    allFeatures = true,    -- Enable all features
    loadOutDirsFromCheck = true,
  },
  checkOnSave = {
    command = 'clippy',    -- Use clippy instead of check
    extraArgs = { '--no-deps' },
  },
  procMacro = {
    enable = true,         -- Expand procedural macros
  },
}
```

### Customization Options

**Clippy strictness**:
```lua
checkOnSave = {
  command = 'clippy',
  extraArgs = { '--', '-W', 'clippy::pedantic' },  -- More strict
}
```

**Inlay hints**:
```lua
inlayHints = {
  enable = true,
  showParameterNames = true,
  parameterHintsPrefix = "<- ",
  otherHintsPrefix = "=> ",
}
```

**Format on save**:
Rustfmt runs automatically via conform.nvim (already configured).

---

## 🔍 Troubleshooting

### rust-analyzer Not Starting

**Check installation**:
```vim
:LspInfo
" Should show rust_analyzer

:Mason
" Check if rust-analyzer is installed
```

**Manual install**:
```vim
:MasonInstall rust-analyzer
```

**Check Rust installation**:
```bash
rustc --version
cargo --version
```

### Slow Performance

rust-analyzer can be resource-intensive on large projects.

**Optimize**:
```lua
-- In rust.lua
checkOnSave = {
  command = 'check',  -- Faster than clippy
}
```

**Disable features temporarily**:
```vim
:lua vim.lsp.buf.inlay_hint(0, false)  " Disable inlay hints
```

### Macro Errors

If macros aren't expanding:
1. Wait for project to build once
2. Restart LSP: `:LspRestart`
3. Check proc-macro is enabled in config

### Dependencies Not Found

```vim
" Reload after adding dependencies
:e  " Reload file

" Or rebuild
:!cargo build
```

---

## 💡 Tips & Tricks

### Quick Documentation

- **Hover**: Press `K` on any type/function
- **Signature**: Press `<C-k>` in insert mode while typing function
- **Go to docs**: Use `gd` then read comments

### Error Navigation

```vim
]d  " Next error/warning
[d  " Previous error/warning
<Leader>sd  " Search all errors in Telescope
```

### Workspace Symbols

```vim
<Leader>ss  " Search symbols in project
" Type struct/function name
" Press Enter to jump
```

### Import Assistance

Type a type name, see red error, then:
```vim
<Leader>.  " Code actions
" Select "Import Xyz"
```

### Refactoring

rust-analyzer offers many refactorings via `<Leader>.`:
- Extract variable
- Extract function
- Inline variable
- Convert to guarded return
- Fill match arms
- And more!

---

## 📦 Tools & Versions

### Installed Tools

| Tool | Purpose | Source |
|------|---------|--------|
| **rust-analyzer** | LSP server | Mason (auto) |
| **rustfmt** | Code formatter | Rust toolchain |
| **clippy** | Linter | Rust toolchain |
| **lldb/gdb** | Debugger | System |

### Checking Versions

```bash
rustc --version        # Rust compiler
cargo --version        # Cargo build tool
rustfmt --version      # Formatter
cargo clippy --version # Linter
```

---

## 📖 Resources

### Rust Learning
- [The Rust Book](https://doc.rust-lang.org/book/)
- [Rust by Example](https://doc.rust-lang.org/rust-by-example/)
- [Rustlings](https://github.com/rust-lang/rustlings) - Interactive exercises

### Tool Documentation
- [rust-analyzer Manual](https://rust-analyzer.github.io/manual.html)
- [rustaceanvim Docs](https://github.com/mrcjkb/rustaceanvim)
- [Clippy Lints](https://rust-lang.github.io/rust-clippy/master/)

### Advanced Topics
- [Async Rust](https://rust-lang.github.io/async-book/)
- [Cargo Book](https://doc.rust-lang.org/cargo/)
- [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/)

---

<div align="center">

**Happy Rust coding!** 🦀

[← Back to Languages](README.md) | [Python →](python.md) | [Svelte →](svelte.md)

</div>
