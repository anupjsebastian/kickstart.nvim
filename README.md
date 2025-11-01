# 🚀 Kickstart.nvim - Professional Edition

> A powerful, modular Neovim configuration built on kickstart.nvim, enhanced with LazyVim-style organization and comprehensive language support.

[![Neovim](https://img.shields.io/badge/Neovim-0.11.4+-57A143?style=for-the-badge&logo=neovim&logoColor=white)](https://neovim.io/)
[![Lua](https://img.shields.io/badge/Lua-5.1+-2C2D72?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org/)
[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](./LICENSE.md)

---

## ✨ Features

### 🎨 **LazyVim-Style Interface**
- Beautiful which-key menu with icons and intuitive groupings
- Consistent keybindings across all plugins (Telescope, Neo-tree, etc.)
- Comprehensive searchable cheatsheet with 200+ keymaps (`<Leader>sc`)

### 🛠️ **Language Support**
- **Flutter/Dart**: Full Flutter tools integration with device management
- **Rust**: rust-analyzer + Crates.io integration for dependency management
- **Python**: Pyright LSP with virtual environment support
- **Svelte**: Complete web development setup
- **Go, TypeScript, Lua**: Pre-configured LSP servers

### 🔍 **Advanced Tooling**
- **Telescope**: Fuzzy finder for files, git, LSP, and more
- **Neo-tree**: File explorer with git integration
- **nvim-dap**: Full debugging support for all languages
- **Gitsigns**: Git integration with blame, hunk navigation, and staging
- **Snacks.nvim**: Quality of life features (terminal, scratch buffers, word highlights, GitHub CLI)
- **Mini.nvim**: Surround, autopairs, comments, and more

### 📚 **Comprehensive Documentation**
- In-editor cheatsheet accessible anytime
- Progressive learning path from basics to advanced
- Vim mastery tips to build your skills over time

---

## 📋 Requirements

### Core Dependencies
- **Neovim** 0.11.4+ (stable or nightly)
- **Git** for plugin management
- **C Compiler** (gcc/clang) for TreeSitter
- **Make** and **unzip**

### Recommended Tools
- **ripgrep** - Fast file searching (required for Telescope)
- **fd** - Fast file finding
- **Nerd Font** - Icons support (set `vim.g.have_nerd_font = true`)
- **Clipboard tool** - xclip (Linux), pbcopy (macOS), win32yank (Windows)

### Language-Specific
- **Node.js** & **npm** - TypeScript, Svelte, web development
- **Python 3** - Python development
- **Rust** & **Cargo** - Rust development
- **Flutter SDK** - Flutter/Dart development
- **Go** - Go development

---

## 🚀 Quick Start

### 1. Backup Existing Config
```bash
# macOS/Linux
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.local/share/nvim ~/.local/share/nvim.backup
mv ~/.local/state/nvim ~/.local/state/nvim.backup
mv ~/.cache/nvim ~/.cache/nvim.backup
```

### 2. Clone This Configuration
```bash
git clone https://github.com/anupjsebastian/kickstart.nvim.git ~/.config/nvim
cd ~/.config/nvim
```

### 3. Install Dependencies
```bash
# macOS (using Homebrew)
brew install neovim ripgrep fd

# Ubuntu/Debian
sudo apt install neovim ripgrep fd-find

# Arch Linux
sudo pacman -S neovim ripgrep fd
```

### 4. Launch Neovim
```bash
nvim
```

On first launch:
- Lazy.nvim will automatically install all plugins
- TreeSitter will compile language parsers
- LSP servers will be installed via Mason
- Wait for all installations to complete (check bottom right)

### 5. Verify Installation
```vim
:checkhealth
```

---

## � Version & Stability

### Tested Configuration
- **Neovim Version**: `v0.11.4`
- **Last Tested**: November 2025
- **Plugin Lock**: `lazy-lock.json` (commit-pinned versions)

This configuration is tested and confirmed working with the versions specified above. The `lazy-lock.json` file locks all plugins to specific commits, ensuring reproducible installations.

### Restoring After Updates Break

If a plugin update causes issues, you can restore to the last known-good state:

#### Quick Restore (Recommended)
```vim
" Inside Neovim
:Lazy restore
```

This restores all plugins to the exact commits specified in `lazy-lock.json`.

#### Full Reset to This Configuration
```bash
# 1. Backup your current state
cd ~/.config/nvim
git commit -am "Before restore"

# 2. Reset to the last stable commit
git log --oneline  # Find the commit hash you want
git reset --hard <commit-hash>

# 3. Restore plugins
nvim -c "Lazy restore" -c "qa"

# 4. Verify everything works
nvim -c "checkhealth"
```

#### Install Specific Neovim Version (macOS)
```bash
# If you need to downgrade/upgrade Neovim
brew unlink neovim
brew install neovim  # Latest stable

# Or install specific version
brew tap neovim/neovim
brew install neovim --HEAD  # Development version
```

### Before Updating

Always create a safety checkpoint before updating:

```bash
# 1. Commit current state
cd ~/.config/nvim
git add -A
git commit -m "Pre-update checkpoint $(date +%Y-%m-%d)"

# 2. Backup lock file
cp lazy-lock.json lazy-lock.json.backup

# 3. Update
nvim -c "Lazy update" -c "qa"

# 4. Test thoroughly before committing
```

If issues occur, restore with:
```bash
cp lazy-lock.json.backup lazy-lock.json
nvim -c "Lazy restore" -c "qa"
```

---

## �📖 Documentation

### Essential Reading
- **[Getting Started](docs/getting-started/README.md)** - First-time setup and orientation
- **[Installation Guide](docs/getting-started/installation.md)** - Detailed installation steps
- **[Quick Reference](docs/getting-started/quick-reference.md)** - Most common commands

### Core Guides
- **[Keymaps Reference](docs/keymaps/README.md)** - Complete keymap documentation
  - [Core Keymaps](docs/keymaps/core.md) - Leader key organization
  - [LSP Keymaps](docs/keymaps/lsp.md) - Language Server Protocol commands
  - [Plugin Keymaps](docs/keymaps/plugins.md) - Telescope, Neo-tree, etc.
  - [Duplicates Guide](docs/keymaps/duplicates.md) - Understanding multiple keys for same action

- **[Plugins Guide](docs/plugins/README.md)** - Plugin documentation
  - [Core Plugins](docs/plugins/core.md) - Essential plugins (Telescope, Neo-tree, which-key)
  - [Editor Plugins](docs/plugins/editor.md) - Editing enhancements
  - [LSP & Completion](docs/plugins/lsp.md) - Language features
  - [Debug Adapter](docs/plugins/debug.md) - Debugging setup

- **[Language Setup](docs/languages/README.md)** - Language-specific configuration
  - [Flutter/Dart](docs/languages/flutter.md)
  - [Rust](docs/languages/rust.md)
  - [Python](docs/languages/python.md)
  - [Svelte](docs/languages/svelte.md)
  - [Other Languages](docs/languages/others.md)

### Advanced Topics
- **[Vim Mastery](docs/vim-mastery/README.md)** - Progressive skill building
  - [Week 1: Motion Basics](docs/vim-mastery/week-01-motions.md)
  - [Week 2: Text Objects](docs/vim-mastery/week-02-text-objects.md)
  - [Week 3: Advanced Editing](docs/vim-mastery/week-03-advanced.md)
  - [Week 4: Macros & Registers](docs/vim-mastery/week-04-macros.md)
  - [Tips & Tricks](docs/vim-mastery/tips-and-tricks.md)
  - [Workflow Optimization](docs/vim-mastery/workflows.md)

- **[Customization](docs/customization.md)** - Making it your own
- **[Troubleshooting](docs/troubleshooting.md)** - Common issues and solutions
- **[FAQ](docs/faq.md)** - Frequently asked questions

---

## 🎯 Quick Access Cheatsheet

### In-Editor Help
- `<Leader>sc` - Open comprehensive cheatsheet (searchable!)
- `<Leader>sk` - Search all keymaps with Telescope
- `<Leader>?` - Quick keymap search
- `<Leader>sK` - Which-key command palette

### Essential Keymaps
| Keymap | Action | Category |
|--------|--------|----------|
| `<Leader>sf` | Find files | Search |
| `<Leader>sg` | Live grep | Search |
| `<Leader>bb` | List buffers | Buffer |
| `\` | Toggle Neo-tree | Files |
| `<Leader>gg` | LazyGit | Git |
| `<Leader>dc` or `F5` | Start debugging | Debug |
| `K` | Hover documentation | LSP |
| `gra` | Code actions | LSP |

> **Pro Tip**: Press `<Leader>` and wait - which-key will show you all available keymaps!

---

## 🏗️ Project Structure

```
~/.config/nvim/
├── init.lua                    # Entry point
├── lua/
│   ├── config/
│   │   ├── keymaps.lua        # Global keymaps
│   │   ├── lazy.lua           # Plugin manager setup
│   │   └── options.lua        # Neovim options
│   ├── plugins/
│   │   ├── core/              # Essential plugins
│   │   │   ├── editor.lua     # Telescope, which-key
│   │   │   ├── neo-tree.lua   # File explorer
│   │   │   ├── debug.lua      # Debug adapter
│   │   │   └── cheatsheet.lua # In-editor help
│   │   └── lang/              # Language-specific
│   │       ├── flutter.lua
│   │       ├── rust.lua
│   │       ├── python.lua
│   │       └── svelte.lua
│   └── kickstart/
│       └── plugins/           # Additional plugins
└── docs/                      # Documentation
    ├── getting-started/
    ├── keymaps/
    ├── plugins/
    ├── languages/
    └── vim-mastery/
```

---

## 🎨 Philosophy

This configuration follows these principles:

1. **Modular**: Each plugin in its own file, easy to enable/disable
2. **Discoverable**: Comprehensive which-key menus and cheatsheet
3. **Consistent**: Same keys work the same way across plugins
4. **Progressive**: Learn at your own pace with structured guides
5. **Documented**: Every keymap and feature explained
6. **Extensible**: Easy to customize and add your own plugins

---

## 🤝 Contributing

Found a bug? Have a suggestion? Contributions are welcome!

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

---

## 🙏 Acknowledgments

- **[kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)** - The foundation of this config
- **[LazyVim](https://www.lazyvim.org/)** - Inspiration for keybinding organization
- **[AstroVim](https://astronvim.com/)** - Cheatsheet inspiration
- **Neovim Community** - Amazing plugins and support

---

## 📚 Learn More

- [Neovim Documentation](https://neovim.io/doc/)
- [Lua Guide for Neovim](https://github.com/nanotee/nvim-lua-guide)
- [Awesome Neovim Plugins](https://github.com/rockerBOO/awesome-neovim)
- [This Configuration's Full Documentation](docs/README.md)

---

<div align="center">

**Built with ❤️ using Neovim**

[Get Started](docs/getting-started/README.md) • [Keymaps](docs/keymaps/README.md) • [Plugins](docs/plugins/README.md) • [Languages](docs/languages/README.md)

</div>
