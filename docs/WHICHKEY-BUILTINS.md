# Which-Key Labels for Built-in Vim Commands

This document explains the comprehensive which-key labels added for built-in Vim commands, helping you discover and learn Vim functionality as you type.

## Overview

**Goals:**
1. **Improve discoverability** - Learn Vim commands as you type and explore
2. **Provide visual feedback** - See what each keystroke does before completing a command
3. **Reduce "+X keymaps" clutter** - Replace generic "+X keymaps" messages with descriptive labels

**Performance Impact:**
Which-key labels are lightweight and only show UI when you pause on a prefix key. This won't impact your editing speed or Neovim's performance.

---

## What's Been Added

We've added descriptive labels for three main categories of built-in Vim commands:

### 1. G Prefix - Go To / Motion Commands

The `g` prefix is one of Vim's most powerful prefixes for navigation and text manipulation.

**Press `g` and wait** to see a comprehensive menu including:

#### Navigation & Go-to
- `gg` - Go to first line
- `gd` - Go to Definition (LSP)
- `gD` - Go to Declaration
- `gf` - Go to File under cursor
- `gF` - Go to File:line under cursor
- `gi` - Go to last Insert position
- `gv` - Reselect last Visual selection
- `gx` - Open URL under cursor
- `g;` - Go to older change position
- `g,` - Go to newer change position
- `gI` - Insert at column 1 (ignore indent)
- `gn` - Search forward and select match
- `gN` - Search backward and select match

#### Display Line Movement (for wrapped lines)
- `gj` - Move down by display line
- `gk` - Move up by display line
- `g0` - Go to first char of display line
- `g$` - Go to last char of display line
- `g^` - Go to first non-blank of display line
- `gm` - Go to middle of screen line
- `gM` - Go to middle of text in line

#### Word Boundary Movement
- `ge` - Go to end of previous word
- `gE` - Go to end of previous WORD

#### Case Manipulation (operators - take a motion)
- `gu{motion}` - Change to lowercase
- `gU{motion}` - Change to UPPERCASE
- `g~{motion}` - Toggle case
- `guu` - Lowercase entire line
- `gUU` - UPPERCASE entire line
- `g~~` - Toggle case entire line

#### Search
- `g*` - Search word forward (no word boundary)
- `g#` - Search word backward (no word boundary)

#### Information & Inspection
- `ga` - Show character info (ASCII/Unicode)
- `g8` - Show UTF-8 bytes of character
- `go` - Go to byte N in buffer
- `g<C-g>` - Show cursor position info

#### Text Formatting
- `gq{motion}` - Format text (moves cursor)
- `gw{motion}` - Format text (keeps cursor position)
- `gqq` - Format current line
- `gww` - Format line keep cursor

#### Other Useful Commands
- `gJ` - Join lines without space
- `g<C-a>` - Increment numbers sequentially
- `g<C-x>` - Decrement numbers sequentially

#### LSP-specific (if using vim.lsp keymaps)
- `grn` - Rename symbol
- `gra` - Code action
- `grr` - References
- `gri` - Implementation
- `grd` - Definition (alternative)
- `grD` - Declaration (alternative)

---

### 2. Z Prefix - Folds, Spelling, and View Control

The `z` prefix controls folds, spelling suggestions, and viewport positioning.

**Press `z` and wait** to see:

#### Fold Operations
- `za` - Toggle fold
- `zA` - Toggle fold recursively
- `zo` - Open fold
- `zO` - Open fold recursively
- `zc` - Close fold
- `zC` - Close fold recursively
- `zM` - Close all folds
- `zR` - Open all folds
- `zm` - Fold more (decrease foldlevel)
- `zr` - Fold less (increase foldlevel)
- `zx` - Update folds
- `zX` - Undo manual fold commands

#### Fold Navigation
- `zj` - Move to next fold
- `zk` - Move to previous fold

#### Fold Creation/Deletion
- `zf{motion}` - Create fold
- `zd` - Delete fold
- `zD` - Delete fold recursively
- `zE` - Eliminate all folds

#### Fold Visibility
- `zn` - Disable folding (foldlevel=max)
- `zN` - Enable folding (restore foldlevel)
- `zi` - Toggle folding on/off

#### Spelling
- `z=` - Spelling suggestions
- `zg` - Add word to spellfile (good)
- `zG` - Add word temporarily (good)
- `zw` - Mark word as wrong
- `zW` - Mark word as wrong temporarily
- `zug` - Undo 'zg' (remove from spellfile)
- `zuw` - Undo 'zw' (unmark as wrong)
- `]s` - Next misspelled word
- `[s` - Previous misspelled word

#### View Positioning (viewport control)
- `zt` - Position cursor at top of window
- `zz` - Position cursor at center of window
- `zb` - Position cursor at bottom of window
- `z<CR>` - Cursor to top, first non-blank
- `z.` - Cursor to center, first non-blank
- `z-` - Cursor to bottom, first non-blank

#### Horizontal Scrolling
- `zH` - Scroll half screen left
- `zL` - Scroll half screen right
- `zh` - Scroll one char left
- `zl` - Scroll one char right
- `zs` - Scroll cursor to start of line
- `ze` - Scroll cursor to end of line

---

### 3. Ctrl-W Prefix - Window Commands

Window management commands are mostly covered by which-key's built-in preset, but we've added a few extras:

**Press `<C-w>` (Ctrl+W) and wait** to see window commands including:

- `<C-w>gf` - Edit file in new tab
- `<C-w>gF` - Edit file:line in new tab
- `<C-w>]` - Split and jump to tag
- `<C-w>}` - Preview tag
- `<C-w>z` - Close preview window

---

### 4. Bracket Prefixes - Navigation

Enhanced navigation commands using `[` and `]` prefixes.

**Already defined in your config:**
- Buffer navigation: `]b`, `[b`, `]B`, `[B`
- Diagnostic navigation: `]d`, `[d`
- Git hunks: `]h`, `[h`, `]c`, `[c`
- Location list: `]l`, `[l`, `]L`, `[L`
- Quickfix: `]q`, `[q`, `]Q`, `[Q`
- Tags: `]t`, `[t`, `]T`, `[T`
- Arguments: `]a`, `[a`, `]A`, `[A`
- Spelling: `]s`, `[s`

**Additional bracket commands:**
- `]]` / `[[` - Next/prev section or function start
- `][` / `[]` - Next/prev section or function end
- `]m` / `[m` - Next/prev method start
- `]M` / `[M` - Next/prev method end
- `]c` / `[c` - Next/prev comment
- `[(` / `])` - Prev/next unmatched parenthesis
- `[{` / `]}` - Prev/next unmatched brace

---

### 5. Other Useful Commands

**Marks and Jumps:**
- Press `m` to see mark commands
- Press `'` to jump to mark (line)
- Press `` ` `` to jump to mark (exact position)

**Registers and Macros:**
- Press `"` to see register commands
- Press `@` to replay macro
- Press `q` to record macro

**Text Objects (in visual/operator-pending mode):**
- Press `a` for "around" text objects
- Press `i` for "inside" text objects

---

## File Structure

The implementation is organized as follows:

```
~/.config/nvim/
├── lua/
│   ├── config/
│   │   └── whichkey_builtins.lua   # Built-in vim command labels
│   └── plugins/
│       └── core/
│           └── editor.lua           # Loads the builtin labels
```

---

## Customization

### Adding More Commands

To add more builtin command labels, edit `lua/config/whichkey_builtins.lua`:

```lua
-- Add to M.g_prefix for g-commands
M.g_prefix = {
    { "gp", desc = "󰆒 Your custom g command" },
    -- ... existing commands
}

-- Add to M.z_prefix for z-commands
M.z_prefix = {
    { "zp", desc = "󰆒 Your custom z command" },
    -- ... existing commands
}
```

### Disabling Builtin Labels

If you want to disable the builtin labels (and go back to "+X keymaps"), comment out this line in `lua/plugins/core/editor.lua`:

```lua
-- Load built-in vim command labels (g, z, ctrl-w, etc.)
-- require('config.whichkey_builtins').setup()  -- Comment this line
```

### Adjusting Which-Key Delay

The current delay is set to `0` (instant popup). If you prefer a delay before which-key appears:

```lua
-- In lua/plugins/core/editor.lua, which-key setup:
wk.setup {
    delay = 500,  -- Wait 500ms before showing which-key menu
    -- ...
}
```

---

## Tips for Learning Vim

1. **Explore Prefixes:** Press `g`, `z`, `[`, `]`, or `<C-w>` and wait - read through the available commands
2. **Use Frequently:** The more you see these labels, the faster you'll internalize the commands
3. **Combine with Motions:** Many `g` and `z` commands take motions (e.g., `guw` = lowercase word, `guf` = lowercase to end of line)
4. **Practice:** Try commands you haven't used before - that's how you expand your Vim vocabulary

---

## Performance Notes

- **No impact on editing speed:** Which-key only activates when you pause on a prefix key
- **Minimal memory overhead:** Labels are just strings stored in memory
- **Lazy-loaded:** Which-key loads with `VeryLazy` event, so startup time is unaffected
- **Can be disabled:** If you experience any issues, simply comment out the setup call

---

## Common Questions

**Q: Why do I still see "+X keymaps" for some keys?**

A: We've covered the most common built-in commands. If you see "+X keymaps" for a specific prefix, it means:
1. Those are plugin-defined keys (not built-in Vim commands)
2. They're less commonly used Vim commands we haven't labeled yet
3. You can add labels yourself by editing `whichkey_builtins.lua`

**Q: Can I change the icons?**

A: Yes! Edit the `desc` fields in `whichkey_builtins.lua`. Icons use Nerd Font symbols. Find more at [nerdfonts.com](https://www.nerdfonts.com/cheat-sheet).

**Q: Will this slow down Neovim?**

A: No. Which-key is purely a UI feature that only activates when you pause. The labels themselves are lightweight strings with zero performance impact.

**Q: I want to learn Vim commands without which-key. Should I disable this?**

A: That's a valid learning approach! Some people prefer to learn by reading `:help` and memorizing commands. If that's you, comment out the `require('config.whichkey_builtins').setup()` line. However, many find that seeing commands in context (as you type) accelerates learning.

---

## Related Documentation

- [Which-key Plugin](https://github.com/folke/which-key.nvim) - Official which-key documentation
- [Vim Help](vim:help) - Type `:help g`, `:help z`, etc. in Neovim for built-in command documentation
- [Keymaps Guide](../README.md#keybindings) - Overview of all custom keybindings in this config

---

**Happy Vim-ing! 🚀**