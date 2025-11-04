-- ========================================================================
-- WHICH-KEY LABELS FOR VIM BUILT-IN COMMANDS
-- ========================================================================
-- This module provides descriptive labels for built-in Vim commands that
-- would otherwise show as "+X keymaps" in which-key menus.
--
-- Goals:
-- 1. Improve discoverability - learn Vim as you type
-- 2. Provide visual feedback for every keystroke
-- 3. Cover common prefixes: g (go), z (fold/spell), [ ] (navigation)
--
-- Performance: Adding labels is lightweight - which-key only shows UI
-- when you pause on a prefix key, so this won't impact editing speed.
-- ========================================================================

local M = {}

-- Flag to enable/disable builtin labels (can be toggled via <leader>tk)
M.enabled = true

-- ========================================================================
-- G PREFIX - GO TO / MOTION COMMANDS
-- ========================================================================
-- The 'g' prefix is one of Vim's most powerful and commonly used prefixes.
-- It contains navigation, case manipulation, and various "go to" operations.
-- ========================================================================

M.g_prefix = {
    -- Navigation & Go-to commands
    { "gg", desc = "󰘕 Go to first line" },
    { "gd", desc = "󰼭 Go to Definition (LSP)" },
    { "gD", desc = "󰼭 Go to Declaration (vim/LSP)" },
    { "gf", desc = "󰈔 Go to File under cursor" },
    { "gF", desc = "󰈔 Go to File:line under cursor" },
    { "gi", desc = "󰆾 Go to last Insert position" },
    { "gv", desc = "󰒅 Reselect last Visual selection" },
    { "gx", desc = "󰖟 Open URL under cursor" },
    { "g;", desc = "󰕁 Go to older change position" },
    { "g,", desc = "󰕁 Go to newer change position" },
    { "gI", desc = "󰆾 Insert at column 1 (ignore indent)" },
    { "gn", desc = "󱎸 Search forward and select match" },
    { "gN", desc = "󱎸 Search backward and select match" },

    -- Display line movement (for wrapped lines)
    { "gj", desc = "󰜮 Move down by display line" },
    { "gk", desc = "󰜷 Move up by display line" },
    { "g0", desc = "󰜲 Go to first char of display line" },
    { "g$", desc = "󰜵 Go to last char of display line" },
    { "g^", desc = "󰜲 Go to first non-blank of display line" },
    { "gm", desc = "󰫽 Go to middle of screen line" },
    { "gM", desc = "󰫽 Go to middle of text in line" },

    -- Word boundary movement
    { "ge", desc = "󰆿 Go to end of previous word" },
    { "gE", desc = "󰆿 Go to end of previous WORD" },

    -- Case manipulation (operators - take a motion)
    { "gu", desc = "󰬴 Change to lowercase (motion)" },
    { "gU", desc = "󰬶 Change to UPPERCASE (motion)" },
    { "g~", desc = "󰬵 Toggle case (motion)" },
    { "guu", desc = "󰬴 Lowercase entire line" },
    { "gUU", desc = "󰬶 UPPERCASE entire line" },
    { "g~~", desc = "󰬵 Toggle case entire line" },

    -- Search with no word boundaries
    { "g*", desc = "󱎸 Search word forward (no boundary)" },
    { "g#", desc = "󱎸 Search word backward (no boundary)" },

    -- Information & inspection
    { "ga", desc = "󰉿 Show character info (ASCII/Unicode)" },
    { "g8", desc = "󰉿 Show UTF-8 bytes of char" },
    { "go", desc = "󰕁 Go to byte N in buffer" },

    -- Text objects and formatting
    { "gq", desc = "󰉶 Format text (motion)" },
    { "gw", desc = "󰉶 Format text keep cursor (motion)" },
    { "gqq", desc = "󰉶 Format current line" },
    { "gww", desc = "󰉶 Format line keep cursor" },

    -- Join lines
    { "gJ", desc = "󰗈 Join lines without space" },

    -- Increment/decrement
    { "g<C-a>", desc = "󰐖 Increment numbers sequentially" },
    { "g<C-x>", desc = "󰍴 Decrement numbers sequentially" },

    -- LSP-specific (if using new vim.lsp default keymaps)
    { "grn", desc = "󰑕 Rename symbol (LSP)" },
    { "gra", desc = "󰌵 Code action (LSP)" },
    { "grr", desc = "󰈇 References (LSP)" },
    { "gri", desc = "󰆧 Implementation (LSP)" },
    { "grd", desc = "󰼭 Definition (LSP alternative)" },
    { "grD", desc = "󰼭 Declaration (LSP alternative)" },

    -- Marks
    { "g'", desc = "󰃀 Jump to mark (no column change)" },
    { "g`", desc = "󰃀 Jump to mark (with column)" },

    -- Ctrl-G variants
    { "g<C-g>", desc = "󰉿 Show cursor position info" },
}

-- ========================================================================
-- Z PREFIX - FOLDS, SPELLING, AND VIEW CONTROL
-- ========================================================================
-- The 'z' prefix controls folds, spelling suggestions, and viewport positioning.
-- ========================================================================

M.z_prefix = {
    -- Fold operations
    { "za", desc = "󱃖 Toggle fold" },
    { "zA", desc = "󱃖 Toggle fold recursively" },
    { "zo", desc = "󱃔 Open fold" },
    { "zO", desc = "󱃔 Open fold recursively" },
    { "zc", desc = "󱃕 Close fold" },
    { "zC", desc = "󱃕 Close fold recursively" },
    { "zM", desc = "󱃕 Close all folds" },
    { "zR", desc = "󱃔 Open all folds" },
    { "zm", desc = "󱃕 Fold more (decrease foldlevel)" },
    { "zr", desc = "󱃔 Fold less (increase foldlevel)" },
    { "zx", desc = "󰁨 Update folds" },
    { "zX", desc = "󰁨 Undo manual fold commands" },

    -- Fold navigation
    { "zj", desc = "󰜮 Move to next fold" },
    { "zk", desc = "󰜷 Move to previous fold" },

    -- Fold creation/deletion
    { "zf", desc = "󱃖 Create fold (motion)" },
    { "zd", desc = "󰆴 Delete fold" },
    { "zD", desc = "󰆴 Delete fold recursively" },
    { "zE", desc = "󰆴 Eliminate all folds" },

    -- Fold visibility
    { "zn", desc = "󱃔 Disable folding (foldlevel=max)" },
    { "zN", desc = "󱃖 Enable folding (restore foldlevel)" },
    { "zi", desc = "󱃖 Toggle folding on/off" },

    -- Spelling
    { "z=", desc = "󰓆 Spelling suggestions" },
    { "zg", desc = "󰓆 Add word to spellfile (good)" },
    { "zG", desc = "󰓆 Add word temporarily (good)" },
    { "zw", desc = "󰓆 Mark word as wrong" },
    { "zW", desc = "󰓆 Mark word as wrong temporarily" },
    { "zug", desc = "󰓆 Undo 'zg' (remove from spellfile)" },
    { "zuw", desc = "󰓆 Undo 'zw' (unmark as wrong)" },
    { "]s", desc = "󰓆 Next misspelled word" },
    { "[s", desc = "󰓆 Previous misspelled word" },

    -- View positioning (viewport control)
    { "zt", desc = "󰜷 Position cursor at top of window" },
    { "zz", desc = "󰫽 Position cursor at center of window" },
    { "zb", desc = "󰜮 Position cursor at bottom of window" },
    { "z<CR>", desc = "󰜷 Cursor to top, first non-blank" },
    { "z.", desc = "󰫽 Cursor to center, first non-blank" },
    { "z-", desc = "󰜮 Cursor to bottom, first non-blank" },

    -- Horizontal scrolling
    { "zH", desc = "󰜱 Scroll half screen left" },
    { "zL", desc = "󰜴 Scroll half screen right" },
    { "zh", desc = "󰜱 Scroll one char left" },
    { "zl", desc = "󰜴 Scroll one char right" },
    { "zs", desc = "󰜴 Scroll cursor to start of line" },
    { "ze", desc = "󰜴 Scroll cursor to end of line" },

    -- Misc
    { "z+", desc = "󰜮 Cursor to next line at top" },
    { "z^", desc = "󰜷 Cursor to previous line at bottom" },
}

-- ========================================================================
-- CTRL-W PREFIX - WINDOW COMMANDS
-- ========================================================================
-- Window management commands. Most are covered by which-key's built-in
-- preset, but we add a few common ones for completeness.
-- ========================================================================

M.ctrl_w_prefix = {
    -- Already mostly covered by which-key preset: windows = true
    -- Adding a few that might be missing or commonly used:

    { "<C-w>gf", desc = "󰈔 Edit file in new tab" },
    { "<C-w>gF", desc = "󰈔 Edit file:line in new tab" },
    { "<C-w>]", desc = "󰓹 Split and jump to tag" },
    { "<C-w>}", desc = "󰖟 Preview tag" },
    { "<C-w>z", desc = "󰅖 Close preview window" },
}

-- ========================================================================
-- BRACKET PREFIXES - NAVIGATION
-- ========================================================================
-- Additional bracket navigation commands not already defined in editor.lua
-- ========================================================================

M.bracket_prefix = {
    -- These supplement the ones already in editor.lua
    -- Argument list, Buffer list, Location list, Quickfix, Tags are already defined

    -- Paragraph and section navigation
    { "]]", desc = "󰘕 Next section/function start" },
    { "[[", desc = "󰘕 Prev section/function start" },
    { "][", desc = "󰘕 Next section/function end" },
    { "[]", desc = "󰘕 Prev section/function end" },

    -- Method navigation (treesitter)
    { "]m", desc = "󰊕 Next method start" },
    { "[m", desc = "󰊕 Prev method start" },
    { "]M", desc = "󰊕 Next method end" },
    { "[M", desc = "󰊕 Prev method end" },

    -- Parenthesis/bracket matching
    { "[(", desc = "󰅲 Prev unmatched (" },
    { "[{", desc = "󰅲 Prev unmatched {" },
    { "])", desc = "󰅲 Next unmatched )" },
    { "]}", desc = "󰅲 Next unmatched }" },

    -- Line blank navigation
    { "]<Space>", desc = "󰘕 Add blank line below" },
    { "[<Space>", desc = "󰘕 Add blank line above" },
}

-- ========================================================================
-- OTHER USEFUL BUILT-IN COMMANDS
-- ========================================================================
-- Single-key commands that benefit from labels
-- ========================================================================

M.other_commands = {
    -- Standalone motion commands (work without any prefix)
    { "H", desc = "󰜷 Move to High (top of screen)" },
    { "M", desc = "󰫽 Move to Middle of screen" },
    { "L", desc = "󰜮 Move to Low (bottom of screen)" },
    { "K", desc = "󰋽 Show documentation/help" },
    { "G", desc = "󰘕 Go to last line" },
    { "gg", desc = "󰘕 Go to first line (same as in g menu)" },

    -- Word motions
    { "w", desc = "󰆿 Next word start" },
    { "W", desc = "󰆿 Next WORD start" },
    { "b", desc = "󰆿 Previous word start" },
    { "B", desc = "󰆿 Previous WORD start" },
    { "e", desc = "󰆿 Next word end" },
    { "E", desc = "󰆿 Next WORD end" },

    -- Line motions
    { "0", desc = "󰜲 Go to column 0" },
    { "^", desc = "󰜲 Go to first non-blank" },
    { "$", desc = "󰜵 Go to end of line" },
    { "_", desc = "󰜲 Go to first non-blank (down)" },
    { "+", desc = "󰜮 Next line first non-blank" },
    { "-", desc = "󰜷 Previous line first non-blank" },

    -- Character search
    { "f", desc = "󰜴 Find character forward" },
    { "F", desc = "󰜱 Find character backward" },
    { "t", desc = "󰜴 Till character forward" },
    { "T", desc = "󰜱 Till character backward" },
    { ";", desc = "󰑗 Repeat last f/t/F/T" },
    { ",", desc = "󰑘 Repeat last f/t/F/T reverse" },

    -- Scrolling
    { "<C-f>", desc = "󰜮 Scroll forward full page" },
    { "<C-b>", desc = "󰜷 Scroll backward full page" },
    { "<C-d>", desc = "󰜮 Scroll down half page" },
    { "<C-u>", desc = "󰜷 Scroll up half page" },
    { "<C-e>", desc = "󰜮 Scroll down one line" },
    { "<C-y>", desc = "󰜷 Scroll up one line" },
    { "zt", desc = "󰜷 Scroll cursor to top (same as z menu)" },
    { "zz", desc = "󰫽 Scroll cursor to center (same as z menu)" },
    { "zb", desc = "󰜮 Scroll cursor to bottom (same as z menu)" },

    -- Operators (take a motion)
    { "d", desc = "󰆴 Delete (motion/text object)" },
    { "c", desc = "󰏫 Change (motion/text object)" },
    { "y", desc = "󰆏 Yank/copy (motion/text object)" },
    { "v", desc = "󰒉 Visual mode (motion)" },
    { "V", desc = "󰒉 Visual line mode" },
    { "<C-v>", desc = "󰒉 Visual block mode" },

    -- Quick operators (double for line)
    { "dd", desc = "󰆴 Delete line" },
    { "cc", desc = "󰏫 Change line" },
    { "yy", desc = "󰆏 Yank/copy line" },
    { "D", desc = "󰆴 Delete to end of line" },
    { "C", desc = "󰏫 Change to end of line" },
    { "Y", desc = "󰆏 Yank to end of line" },

    -- Insert mode entries
    { "i", desc = "󰆾 Insert before cursor" },
    { "I", desc = "󰆾 Insert at line start" },
    { "a", desc = "󰆾 Append after cursor", mode = { "n", "v" } },
    { "A", desc = "󰆾 Append at line end" },
    { "o", desc = "󰆾 Open line below" },
    { "O", desc = "󰆾 Open line above" },
    { "gi", desc = "󰆾 Go to last insert position (same as g menu)" },

    -- Undo/Redo
    { "u", desc = "󰕌 Undo" },
    { "<C-r>", desc = "󰑎 Redo" },
    { "U", desc = "󰕌 Undo line changes" },

    -- Search
    { "/", desc = "󱎸 Search forward" },
    { "?", desc = "󱎸 Search backward" },
    { "n", desc = "󱎸 Next search result" },
    { "N", desc = "󱎸 Previous search result" },
    { "*", desc = "󱎸 Search word forward (boundaries)" },
    { "#", desc = "󱎸 Search word backward (boundaries)" },
    { "&", desc = "󰑗 Repeat last :s substitute" },

    -- Marks and jumps
    { "m", group = "󰃀 Mark" },
    { "'", group = "󰃀 Jump to mark (line)" },
    { "`", group = "󰃀 Jump to mark (exact)" },
    { "<C-o>", desc = "󰕁 Jump to older position (jumplist)" },
    { "<C-i>", desc = "󰕁 Jump to newer position (jumplist)" },
    { "<Tab>", desc = "󰕁 Jump to newer position (same as <C-i>)" },
    { "%", desc = "󰅲 Jump to matching bracket/paren" },
    { "``", desc = "󰃀 Jump to position before last jump" },
    { "''", desc = "󰃀 Jump to line before last jump" },

    -- Registers and macros
    { '"', group = "󰅍 Register" },
    { "@", group = "󰑮 Macro replay" },
    { "q", group = "󰑮 Macro record" },

    -- Indenting and formatting
    { "<", desc = "󰉵 Indent left (takes motion)" },
    { ">", desc = "󰉶 Indent right (takes motion)" },
    { "<<", desc = "󰉵 Indent line left" },
    { ">>", desc = "󰉶 Indent line right" },
    { "=", desc = "󰉶 Auto-indent (takes motion)" },
    { "==", desc = "󰉶 Auto-indent line" },

    -- Misc useful commands
    { ".", desc = "󰑗 Repeat last change" },
    { "p", desc = "󰆒 Paste after cursor" },
    { "P", desc = "󰆒 Paste before cursor" },
    { "gp", desc = "󰆒 Paste and move cursor (same as g menu)" },
    { "gP", desc = "󰆒 Paste before and move cursor (same as g menu)" },
    { "x", desc = "󰆴 Delete character" },
    { "X", desc = "󰆴 Delete character before" },
    { "r", desc = "󰛔 Replace character" },
    { "R", desc = "󰛔 Replace mode" },
    { "s", desc = "󰏫 Substitute character" },
    { "S", desc = "󰏫 Substitute line" },
    { "J", desc = "󰗈 Join lines" },
    { "gJ", desc = "󰗈 Join lines without space (same as g menu)" },
    { "~", desc = "󰬵 Toggle case and move" },
    { "ZZ", desc = "󰆓 Write file and quit" },
    { "ZQ", desc = "󰗼 Quit without writing" },
    { ":", desc = "󰘳 Enter command mode" },
    { "!", desc = "󰆍 Filter through external command" },

    -- Text objects (in visual/operator-pending mode)
    -- These are mostly handled by which-key presets, but we can add group labels
    { "a", group = "󰒅 Around text object", mode = { "o", "x" } },
    { "i", group = "󰒅 Inside text object", mode = { "o", "x" } },

    -- Paragraph and section navigation
    { "{", desc = "󰜷 Previous paragraph/block" },
    { "}", desc = "󰜮 Next paragraph/block" },
    { "(", desc = "󰜷 Previous sentence" },
    { ")", desc = "󰜮 Next sentence" },

    -- Line numbers and goto
    { ":<num>", desc = "󰆤 Go to line number (:42 = line 42)" },
    { "<num>G", desc = "󰆤 Go to line number (42G = line 42)" },
    { "<num>gg", desc = "󰆤 Go to line number (42gg = line 42)" },

    -- Special characters and digraphs
    { "<C-k>", desc = "󰌏 Insert digraph (in insert mode)" },
    { "<C-v>", desc = "󰒉 Insert literal/special char or visual block" },
    { "<C-a>", desc = "󰐖 Increment number" },
    { "<C-x>", desc = "󰍴 Decrement number" },
    { "<C-g>", desc = "󰉿 Show file info and position" },
    { "g<C-g>", desc = "󰉿 Show detailed position info (same as g menu)" },

    -- Shell and external commands
    { "!!", desc = "󰆍 Filter line through shell command" },
    { "K", desc = "󰋽 Run keywordprg on word (man page)" },
}

-- ========================================================================
-- REGISTER ALL MAPPINGS
-- ========================================================================

function M.setup()
    local ok, wk = pcall(require, "which-key")
    if not ok then
        vim.notify("which-key not found, skipping builtin command labels", vim.log.levels.WARN)
        return
    end

    -- Only register if enabled
    if not M.enabled then
        return
    end

    -- Register g prefix commands
    wk.add(M.g_prefix)

    -- Register z prefix commands
    wk.add(M.z_prefix)

    -- Register ctrl-w commands
    wk.add(M.ctrl_w_prefix)

    -- Register bracket commands (supplement existing ones)
    wk.add(M.bracket_prefix)

    -- Register other useful commands
    wk.add(M.other_commands)
end

return M
