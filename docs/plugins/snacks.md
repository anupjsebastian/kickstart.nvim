# 🍿 Snacks.nvim - Quality of Life Features

**13 lightweight modules that enhance your Neovim workflow.**

> **Startup Impact**: <5ms total - Extremely lightweight!
> **Terminal Module**: Disabled (external terminal workflow preferred)

---

## 📦 Active Modules

### 1. bufdelete - Smart Buffer Deletion
Delete buffers without closing windows.

**Keymaps**: `<Space>bd` (delete buffer)

### 2. rename - LSP-Aware File Renaming
Rename files and update all imports automatically.

**Keymaps**: `<Space>cR` (rename file)

### 3. scratch - Persistent Scratch Buffers
Context-aware note-taking per directory/branch.

**Keymaps**:
- `<Space>.` - Toggle scratch
- `<Space>S` - Select scratch
- `<Enter>` - Execute Lua (in scratch)

### 4. words - Word Reference Highlighting
Highlight word under cursor + navigate occurrences.

**Keymaps**:
- `]]` - Next word occurrence
- `[[` - Previous word occurrence

### 5. indent - Animated Indent Guides
Visual indent lines with scope highlighting. **Auto-enabled**.

### 6. gitbrowse - Open in Web Browser
Open file/line on GitHub/GitLab.

**Keymaps**:
- `<Space>gb` - Git browse
- `<Space>gB` - Git blame

### 7. gh - GitHub Integration
GitHub CLI integration for issues and PRs.

**Keymaps**:
- `<Space>gH` - GitHub menu
- `<Space>gI` - Issues
- `<Space>gP` - Pull requests

### 8. bigfile - Performance for Large Files
Auto-disable heavy features for files >1.5MB. **Auto-enabled**.

### 9. scroll - Smooth Scrolling
Animated smooth scrolling. **Auto-enabled**.

### 10. toggle - Unified Toggle System
**Keymaps**:
- `<Space>td` - Toggle diagnostics
- `<Space>tl` - Toggle line numbers
- `<Space>ts` - Toggle spelling
- `<Space>tw` - Toggle word wrap
- `<Space>th` - Toggle inlay hints

### 11. statuscolumn - Enhanced Gutter
Git signs, diagnostics, folds. **Auto-enabled**.

### 12. dashboard - Startup Screen
Beautiful startup screen with quick actions. **Auto-appears**.

### 13. notifier - Better Notifications
**Keymaps**:
- `<Space>un` - Dismiss all
- `<Space>uh` - Notification history

---

## 🚫 Terminal Module - Disabled

**Why**: External terminal workflow preferred (iTerm2, WezTerm, tmux).

**Re-enable**: Edit `lua/plugins/core/snacks.lua`:
```lua
terminal = { enabled = true },
```

---

## ⚡ Performance

- **Total overhead**: <5ms for all 13 modules
- **words**: 100ms debounce
- **bigfile**: Protects against large files
- **Verified**: `:Lazy profile` shows minimal impact

---

## 💡 Quick Examples

**Rename file + update imports**:
1. `<Space>cR`
2. Type new name
3. Enter

**Quick calc in scratch**:
1. `<Space>.`
2. Type: `print(123 * 456)`
3. `<Enter>`

**Navigate word occurrences**:
1. Cursor on word
2. `]]` next, `[[` previous

**Open line in GitHub**:
1. Cursor on line
2. `<Space>gb`

---

## 🔧 Configuration

**Location**: `lua/plugins/core/snacks.lua`

**Customize**:
```lua
bigfile = {
  size = 2 * 1024 * 1024, -- 2MB
},
scroll = {
  enabled = false, -- Disable
},
```

---

## 📖 Resources

- [Snacks.nvim GitHub](https://github.com/folke/snacks.nvim)
- [Which-key Guide](which-key.md)
- [Full Documentation](https://github.com/folke/snacks.nvim#-modules)

---

[← Back to Plugins](README.md)
