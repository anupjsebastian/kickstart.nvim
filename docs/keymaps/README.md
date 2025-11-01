# ⌨️ Keymaps Reference

Complete guide to all keymaps in this configuration, organized by category.

---

## 📋 Quick Navigation

- **[Core Keymaps](core.md)** - Leader-key organization (buffer, window, search, git, etc.)
- **[LSP Keymaps](lsp.md)** - Language Server Protocol commands
- **[Plugin Keymaps](plugins.md)** - Telescope, Neo-tree, Git, Debug
- **[Duplicates Guide](duplicates.md)** - Understanding multiple keys for same action
- **[Consistency Guide](consistency.md)** - Cross-plugin key patterns

---

## 🎯 Keymap Philosophy

### 1. Leader-Based Organization
Almost all custom keymaps start with `<Leader>` (Space key):
- `<Leader>b` - **Buffer** operations
- `<Leader>s` - **Search** (Telescope)
- `<Leader>f` - **Flutter** (Dart files)
- `<Leader>r` - **Rust** operations
- `<Leader>d` - **Debug** commands
- `<Leader>g` - **Git** operations
- And more...

### 2. Mnemonic Design
Keys are chosen to be memorable:
- `<Leader>sf` = **S**earch **F**iles
- `<Leader>bb` = **B**uffer **B**rowse
- `<Leader>gg` = Open Lazy**G**it
- `<Leader>db` = **D**ebug **B**reakpoint

### 3. Which-key Discovery
Press `<Leader>` and wait - a menu shows all available commands!

### 4. Consistent Across Plugins
Same keys work the same way everywhere:
- `Ctrl-x` = Horizontal split (Telescope, Neo-tree)
- `Ctrl-v` = Vertical split (Telescope, Neo-tree)
- `Ctrl-t` = New tab (Telescope, Neo-tree)
- `?` = Show help (Telescope, Neo-tree)

---

## 🗺️ Keymap Categories

### Buffer Workflow 📂

**What are Buffers?**
Buffers = open files in memory. When you open a file, it becomes a buffer.

**Opening Files/Buffers:**
| Command | Action |
|---------|--------|
| `<Leader>sf` | Telescope: Find and open file |
| `\` | Neo-tree: Navigate and open file |
| `:e filename` | Edit/open a file by path |
| `nvim file1 file2` | Open multiple files from terminal |
| `gf` | Go to file under cursor (imports/paths) |

**Switching Between Buffers:**
| Command | Action |
|---------|--------|
| `<Leader><space>` | **Telescope buffer picker** (with icons & modified indicators) |
| `]b` | Next buffer |
| `[b` | Previous buffer |
| `:ls` | List all buffers |

**Closing Buffers:**
| Command | Action |
|---------|--------|
| `<Leader>bd` | Delete/close current buffer (smart - keeps window) |
| `:bd` | Delete buffer (native) |
| `:bd!` | Force delete without saving |
| `<Leader>bo` | Close other buffers (when using bufferline) |

**Buffer Facts:**
- No practical limit (thousands possible, limited by RAM)
- Typical workflow: 5-50 buffers open
- Hidden buffers stay in memory (fast switching!)
- Sessions auto-save your buffer state

**Workflow Example:**
```
1. <Leader>sf → Open file1.py → Becomes buffer
2. <Leader>sf → Open file2.py → Becomes another buffer
3. <Leader><space> → See both buffers with icons
4. ]b / [b → Quick switch between them
5. <Leader>bd → Close buffer when done
```

### Core Editor
| Prefix | Category | Example |
|--------|----------|---------|
| `<Leader>b` | Buffer operations | `<Leader>bd` = Delete buffer |
| `<Leader>w` | Window operations | `<Leader>wv` = Vertical split |
| `<Leader>u` | UI toggles | `<Leader>uw` = Toggle wrap |
| `<Leader>s` | Search/Telescope | `<Leader>sf` = Find files |
| `<Leader>g` | Git operations | `<Leader>gg` = LazyGit |

### LSP (Language Features)
| Prefix | Category | Example |
|--------|----------|---------|
| `gr*` | Go to... | `grd` = Go to definition |
| `K` | Hover | `K` = Show documentation |
| `<Leader>c` | Code | `<Leader>ca` = Code actions |

### Debug
| Prefix | Category | Example |
|--------|----------|---------|
| `<Leader>d` | Debug commands | `<Leader>db` = Breakpoint |
| `F5-F12` | Debug quick keys | `F5` = Continue |

### Language-Specific
| Prefix | Language | Example |
|--------|----------|---------|
| `<Leader>f` | Flutter/Dart | `<Leader>fr` = Run app |
| `<Leader>r` | Rust | `<Leader>ra` = Code actions |
| `<Leader>rc` | Rust Crates | `<Leader>rct` = Toggle |
| `<Leader>p` | Python | `<Leader>pr` = Run |
| `<Leader>v` | Svelte | `<Leader>vf` = Format |

---

## 📚 Detailed Documentation

### [Core Keymaps](core.md)
Complete reference for all leader-key bindings:
- Buffer management
- Window operations
- Search/Telescope
- Git integration
- UI toggles
- Session management

### [LSP Keymaps](lsp.md)
Language Server Protocol commands that work in all languages:
- Go to definition, references, implementation
- Hover documentation
- Rename symbol
- Code actions
- Signature help
- Diagnostics navigation

### [Plugin Keymaps](plugins.md)
Plugin-specific keymaps:
- **Telescope**: Fuzzy finding, live grep, file browser
- **Neo-tree**: File explorer navigation and operations
- **Git**: Gitsigns hunks, staging, blame
- **Debug**: nvim-dap debugging commands
- **Mini.nvim**: Surround, comments, pairs

### [Duplicates Guide](duplicates.md)
Understanding why some actions have multiple keymaps:
- Vim defaults + modern alternatives
- Function keys + leader keys for debugging
- Single keys + Ctrl combos for consistency
- Default plugin keys + consistent alternatives

### [Consistency Guide](consistency.md)
Cross-plugin key patterns:
- Same split/tab keys in Telescope and Neo-tree
- Consistent navigation patterns
- Unified help access

---

## 🎓 Learning Strategy

### Week 1: Essential Commands
Focus on these 10 keymaps:
1. `<Leader>sf` - Find files
2. `<Leader>sg` - Search text (grep)
3. `<Leader>bb` - Browse buffers
4. `\` - Toggle file explorer
5. `gd` - Go to definition
6. `K` - Show documentation
7. `<Leader>ca` - Code actions
8. `<Leader>gg` - Git interface
9. `<C-h/l>` - Switch windows
10. `<Leader>sc` - Open cheatsheet!

### Week 2: Expand Your Arsenal
Add these:
- `<Leader>s/` - Search in open files
- `<Leader>bd` - Delete buffer
- `<Leader>wv` - Split vertical
- `gr` - Find references
- `[d` / `]d` - Next/prev diagnostic

### Ongoing: One Per Week
Pick ONE new keymap each week from the [full documentation](core.md) and practice it until it's muscle memory.

---

## 🔍 Finding Keymaps

### In-Editor Tools
```vim
" Comprehensive searchable cheatsheet
<Leader>sc

" Search all keymaps with Telescope
<Leader>sk

" Which-key command palette
<Leader>sK

" Quick fuzzy search
<Leader>?

" Press any prefix and wait
<Leader>  " Shows all leader keymaps
g         " Shows all 'go to' commands
[         " Shows all 'next' commands
]         " Shows all 'previous' commands
```

### By Category
- **Buffer commands**: `<Leader>b` (then wait for menu)
- **Search commands**: `<Leader>s` (then wait)
- **Git commands**: `<Leader>g` (then wait)
- **Debug commands**: `<Leader>d` (then wait)

### By Plugin
Inside a plugin (like Telescope or Neo-tree), press `?` for help.

---

## � Bracket Navigation (`]` and `[`)

Vim's powerful bracket operators for jumping between locations. Press `]` or `[` to see all options in which-key.

### Word Navigation (snacks.nvim)
| Key  | Description | Source |
|------|-------------|--------|
| `]]` | Next word occurrence | snacks.words |
| `[[` | Previous word occurrence | snacks.words |

**How it works**: Place cursor on any word, press `]]` to jump to next occurrence with auto-highlighting.

### Argument List (Files from Startup)
| Key  | Description | Vim Command |
|------|-------------|-------------|
| `]a` | Next arg | `:next` |
| `[a` | Previous arg | `:prev` |
| `]A` | Last arg | `:last` |
| `[A` | First arg | `:first` |

**Usage**: When you start Vim with multiple files (`nvim file1.lua file2.lua`), use these to navigate.

### Buffer List (All Open Files)
| Key  | Description | Vim Command |
|------|-------------|-------------|
| `]b` | Next buffer | `:bnext` |
| `[b` | Previous buffer | `:bprev` |
| `]B` | Last buffer | `:blast` |
| `[B` | First buffer | `:bfirst` |

**Most useful for day-to-day navigation!** Also see `<Leader><Leader>` for Telescope buffer picker.

### Location List (LSP Locations)
| Key  | Description | Vim Command |
|------|-------------|-------------|
| `]l` | Next location | `:lnext` |
| `[l` | Previous location | `:lprev` |
| `]L` | Last location | `:llast` |
| `[L` | First location | `:lfirst` |

**When used**: After `:lvimgrep`, LSP references, or other location list operations.

### Quickfix List (Search/Errors)
| Key  | Description | Vim Command |
|------|-------------|-------------|
| `]q` | Next quickfix | `:cnext` |
| `[q` | Previous quickfix | `:cprev` |
| `]Q` | Last quickfix | `:clast` |
| `[Q` | First quickfix | `:cfirst` |

**Integrated with Trouble**: If Trouble is open, these navigate Trouble items instead!

### Tags (ctags Navigation)
| Key  | Description | Vim Command |
|------|-------------|-------------|
| `]t` | Next tag | `:tnext` |
| `[t` | Previous tag | `:tprev` |
| `]T` | Last tag | `:tlast` |
| `[T` | First tag | `:tfirst` |

**When used**: After `Ctrl-]` on a symbol with multiple tag matches.

### Git Changes (gitsigns)
| Key  | Description | Source |
|------|-------------|--------|
| `]c` | Next git change | gitsigns |
| `[c` | Previous git change | gitsigns |
| `]h` | Next git hunk | gitsigns |
| `[h` | Previous git hunk | gitsigns |

**Visual feedback**: Git signs appear in the sign column showing added/changed/deleted lines.

### Diagnostics (LSP)
| Key  | Description | Source |
|------|-------------|--------|
| `]d` | Next diagnostic | LSP |
| `[d` | Previous diagnostic | LSP |

**Also see**: `<Leader>sd` to search all diagnostics in Telescope.

### Spelling
| Key  | Description | Vim Feature |
|------|-------------|-------------|
| `]s` | Next misspelled word | `:set spell` |
| `[s` | Previous misspelled word | `:set spell` |

**Enable spelling**: `:set spell` or `<Leader>ts` (toggle spelling).

### Quick Reference Card

```
Navigation Type    Next    Prev    Last    First
─────────────────────────────────────────────────
Word (snacks)      ]]      [[      -       -
Arguments          ]a      [a      ]A      [A
Buffers            ]b      [b      ]B      [B
Location List      ]l      [l      ]L      [L
Quickfix           ]q      [q      ]Q      [Q
Tags               ]t      [t      ]T      [T
Git Changes        ]c      [c      -       -
Git Hunks          ]h      [h      -       -
Diagnostics        ]d      [d      -       -
Spelling           ]s      [s      -       -
```

**Pro Tip**: Press `]` or `[` and wait - which-key shows all available options!

---

## �💡 Tips

### Discovering Features
1. Press `<Leader>` and wait - explore the which-key menu
2. Open cheatsheet with `<Leader>sc` and search
3. Check plugin-specific help with `?`

### Customizing Keymaps
See [Customization Guide](../customization.md) to:
- Change existing keymaps
- Add your own keymaps
- Disable unwanted keymaps

### Resolving Conflicts
If a keymap doesn't work:
```vim
:verbose map <Leader>sf
:checkhealth which-key
```

---

## 📖 External Resources

- [Vim Cheat Sheet](https://vim.rtorr.com/)
- [Interactive Vim Tutorial](https://www.openvim.com/)
- [Practical Vim Book](https://pragprog.com/titles/dnvim2/practical-vim-second-edition/)

---

<div align="center">

**Master your keymaps, master your editor!**

[Core Keymaps →](core.md) | [LSP Keymaps →](lsp.md) | [Plugin Keymaps →](plugins.md)

[Back to Documentation](../README.md)

</div>
