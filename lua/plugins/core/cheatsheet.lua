-- ========================================================================
-- CHEATSHEET - Comprehensive keymap reference (700+ keybindings)
-- ========================================================================
-- 
-- KEYMAPS:
--   <leader>sc  - Search complete cheatsheet (all keymaps)
--   <leader>sC  - Browse cheatsheet categories (table of contents)
--
-- MAINTENANCE INSTRUCTIONS:
--   When adding/removing categories, update this header's category list!
--   Categories are defined by the 'category' field in each entry.
--   Keep categories organized and use consistent naming (see existing patterns).
--
-- CATEGORY ORGANIZATION (76 categories):
--
-- ┌─ VIM ESSENTIALS (Built-in Vim commands)
-- │  ├─ Vim: Motion - h/j/k/l, w/b/e, f/F, t/T, gg/G, {/}, etc.
-- │  ├─ Vim: Editing - i/a/o, d/c/y/p, u/redo, ., r, J, ~, >/<, =, gU/gu
-- │  ├─ Vim: Comments - gcc, gc{motion}, gbc, gb{motion} (built-in)
-- │  ├─ Vim: Lines - dd, yy, cc, D/C/Y/S, :m, :t, :5,10d/y
-- │  ├─ Vim: Visual - v/V/Ctrl-v, o, gv, >/<, I/A, U/u, ~, J, :sort, :!
-- │  ├─ Vim: Search - /{pattern}, ?{pattern}, n/N, */# :noh
-- │  ├─ Vim: Replace - :s/old/new/g, :%s, :5,10s, confirm flags (y/n/a/q/l)
-- │  ├─ Vim: Macros - q{letter}, @{letter}, @@, {count}@, :reg
-- │  ├─ Vim: Marks - m{letter}, '{letter}, `{letter}, '', `., :marks, :delmarks
-- │  ├─ Vim: Registers - "{letter}y/p, "0p, "+y/p (clipboard), :reg
-- │  ├─ Vim: Jumps - Ctrl-o/i, :jumps, g;/g,, :changes
-- │  ├─ Vim: Windows - Ctrl-w s/v/c/o/=, Ctrl-h/j/k/l
-- │  ├─ Vim: Tabs - :tabnew, :tabc, gt/gT, {count}gt
-- │  ├─ Vim: Buffers - :bn/:bp, :bd, :b {name}, :ls, Ctrl-^
-- │  ├─ Vim: Folding - za, zo/zc, zR/zM, zj/zk, zf, zd
-- │  ├─ Vim: Spell - :set spell, z=, zg, zw, ]s/[s
-- │  ├─ Vim: Files - :w, :w !sudo, :q, :wq/:q!, :e, :e!, :saveas
-- │  └─ Vim: Command - :, q:, Ctrl-f, :!, :r !, :{range}!, :shell
--
-- ┌─ WORKFLOWS (Common patterns and multi-step operations)
-- │  ├─ Workflow: Multi-File - Grep→quickfix, :cdo/:cfdo replace
-- │  ├─ Workflow: Multi-Edit - *cgn, macros, visual block insert
-- │  ├─ Workflow: Navigate - grd→Ctrl-o, <Space>sw→]q, K→K→q
-- │  ├─ Workflow: Refactor - grn (rename), <Space>cR (file), gra (actions)
-- │  └─ Workflow: Git - ]c→hp→hs (stage), hb→gb (blame→browser)
--
-- ┌─ LEADER KEYMAPS (<Space> prefix)
-- │  ├─ Core: Quit - <Space>Q
-- │  ├─ Core: Files - \ (neo-tree), Esc (close float/clear highlight)
-- │  ├─ Core: Terminal - Esc Esc (exit terminal mode)
-- │  ├─ Code - <Space>cq (quickfix), <Space>cf (format), <Space>cR (rename file)
-- │  ├─ Buffer - <Space>bd/bD/bu/bo (delete/force/unload/others)
-- │  ├─ Buffer: Open - <Space>sf, \, :e, gf
-- │  ├─ Buffer: Switch - <Space><Space>, ]b/[b, ]B/[B, :ls
-- │  ├─ Buffer: Close - <Space>bd/bD/bu/bo
-- │  ├─ Buffer: Info - Ctrl-g, <Space>sn
-- │  ├─ Window - <Space>ww/wc/ws/wv/wm/w=, Ctrl-h/j/k/l
-- │  ├─ Tab - <Space>wn/wo/w]/w[/w>/w</wf/wL, gt/gT
-- │  ├─ Search - <Space>sh/sk/sf/ss/sw/sg/sd/sr/s./s//sn/sc/sK, <Space>/
-- │  ├─ Session - <Space>Ss/Sr/Sd/Sf (save/restore/delete/find)
-- │  ├─ UI - <Space>ul/um/ui/uI/un/uh (lazy/mason/inspect/history)
-- │  ├─ Toggle - <Space>ta/tr/tv/th/td/tl/ts/tw/ti (copilot/relative/virtual-text/hints/diagnostics)
-- │  ├─ Diagnostics - <Space>xx/xX/xs (trouble: all/buffer/symbols)
-- │  ├─ Quickfix - :copen/cclose, :cnext/cprev, :cfirst/clast, :cnfile/cpfile, :cdo/:cfdo
-- │  └─ Location List - :lopen/lclose, :lnext/lprev, :lfirst/llast, :lnfile/lpfile, :ldo/:lfdo
--
-- ┌─ GIT (Gitsigns + Snacks)
-- │  ├─ Git - <Space>hs/hr/hS/hu/hR/hp/hb/hd/hD, ]c/[c, ]h/[h
-- │  └─ Git: Snacks - <Space>gb/gB/gH/gI/gP (browse/blame/gh/issues/prs)
--
-- ┌─ LSP & CODE (All languages)
-- │  ├─ LSP - K, grd/grD/gri/grr/grt/grn/gra, <Space>., <Space>cf, gO/gW, <Space>th
-- │  └─ Debug - F5/F10/F11/F12, <Space>db/dB/dc/di/do/dO/dt/dr/dl/dC/du/de
--
-- ┌─ LANGUAGE-SPECIFIC (Auto-loaded by filetype)
-- │  ├─ Flutter - <Space>lfr/lfh/lfR/lfq/lfa/lfd/lfe/lft/lfi/lfD/lfC/lfp/lfb/lfT/lfl, <Space>.
-- │  ├─ Rust (buffer-local: .rs) - <Space>lrh/lra/lre/lrC/lrp/lrj/lrr/lrd/lrm
-- │  ├─ Rust: Cargo (GLOBAL) - <Space>lrb/lrR/lrt/lrk/lrl/lrf/lrx/lrA/lrX/lrU/lrD
-- │  ├─ Rust: Crates - <Space>lrct/lrcr/lrcv/lrcf/lrcd/lrcu/lrca/lrcU/lrcA/lrce/lrcE/lrcH/lrcR/lrcD/lrcC
-- │  ├─ Python (GLOBAL) - <Space>lpr/lpR/lpC/lpS/lpX/lpi/lpa/lpA/lpu/lpe/lpv/lpt/lpc/lpl
-- │  ├─ Svelte/JS/TS (buffer) - <Space>lsf/lsl/lso
-- │  ├─ Web Dev (GLOBAL) - <Space>lsr/lsb/lsp/lsc/lse/lsT/lsi/lsa/lsA/lsx/lsu/lst
-- │  └─ HTML/CSS (GLOBAL) - <Space>lho/lhb/lhl
--
-- ┌─ PLUGINS (UI, Navigation, Editing)
-- │  ├─ Telescope - Ctrl-j/k, Ctrl-d/u, Ctrl-n/p, Enter, Ctrl-x/v/t, Ctrl-c/q, Tab, Ctrl-q, ?
-- │  ├─ Neo-tree - \, Enter, Ctrl-x/v/t, w, Ctrl-j/k, P, R, H, -, ., C, z, a/A/d/r/y/x/p/c/m, ?
-- │  ├─ Text Objects - a/i+obj, an/in, al/il, daw/ciw/yap, daf/cif/daa/cia (mini.ai)
-- │  ├─ Surround - sa/sd/sr/sf/sF/sh (mini.surround + vim-repeat)
-- │  ├─ Copilot - Tab, Ctrl-], Alt-]/[, Alt-\, <Space>ta, :Copilot
-- │  ├─ Emmet - Ctrl-e, (expand/update/balance/navigate/remove/comment/anchor)
-- │  ├─ Emmet: Patterns - div.class#id, ul>li*5, div+p, ^, (), $, [], {}, lorem
-- │  ├─ Snacks: Dashboard - f/n/g/r/c/s/l/q (startup screen)
-- │  ├─ Snacks: Buffers - <Space>bd/bo (smart delete/others)
-- │  ├─ Snacks: Files - <Space>cR (rename with LSP)
-- │  ├─ Snacks: Scratch - <Space>bS/bs (toggle/select scratch buffer)
-- │  ├─ Snacks: Words - ]]/[[ (jump word occurrences)
-- │  ├─ Snacks: Git - <Space>gb/gB/gH/gI/gP
-- │  ├─ Snacks: Notify - <Space>un/uh (dismiss/history)
-- │  └─ Snacks: Toggle - <Space>td/tl/ts/tw/ti
--
-- └─ NAVIGATION (Bracket commands)
--    ├─ Navigation: Args - ]a/[a, ]A/[A (argument list)
--    ├─ Navigation: Buffers - ]b/[b, ]B/[B (open files)
--    ├─ Navigation: Quickfix - ]q/[q, ]Q/[Q (global list)
--    ├─ Navigation: Location List - ]l/[l, ]L/[L (window-local)
--    ├─ Navigation: Tags - ]t/[t, ]T/[T (definition stack)
--    ├─ Navigation: Git - ]c/[c, ]h/[h (changes/hunks)
--    ├─ Navigation: Diagnostics - ]d/[d (LSP diagnostics)
--    └─ Navigation: Spelling - ]s/[s (misspelled words)
--
-- ========================================================================

-- Lazy-loaded cheatsheet data generator
-- This function is only called when you press <leader>sc or <leader>sC
-- Prevents allocating a massive table at startup (huge performance win!)
local function get_cheatsheet_data()
  return {
            -- ============================================================
            -- VIM ESSENTIALS
            -- ============================================================
            { category = 'Vim: Motion', key = 'h/j/k/l', desc = 'Left/Down/Up/Right' },
            { category = 'Vim: Motion', key = 'w/b/e', desc = 'Word forward/backward/end' },
            { category = 'Vim: Motion', key = '0/$', desc = 'Start/end of line' },
            { category = 'Vim: Motion', key = 'gg/G', desc = 'First/last line' },
            { category = 'Vim: Motion', key = '{/}', desc = 'Previous/next paragraph' },
            { category = 'Vim: Motion', key = '%', desc = 'Jump to matching bracket' },
            { category = 'Vim: Motion', key = 'f/F{char}', desc = 'Find char forward/backward' },
            { category = 'Vim: Motion', key = 't/T{char}', desc = 'Till char forward/backward' },
            { category = 'Vim: Motion', key = ';/,', desc = 'Repeat f/t forward/backward' },
            { category = 'Vim: Motion', key = '*/#', desc = 'Search word under cursor' },
            { category = 'Vim: Motion', key = 'n/N', desc = 'Next/previous search result' },

            { category = 'Vim: Editing', key = 'i/a', desc = 'Insert before/after cursor' },
            { category = 'Vim: Editing', key = 'I/A', desc = 'Insert at line start/end' },
            { category = 'Vim: Editing', key = 'o/O', desc = 'New line below/above' },
            { category = 'Vim: Editing', key = 'x/X', desc = 'Delete char under/before cursor' },
            { category = 'Vim: Editing', key = 'd{motion}', desc = 'Delete (dw, dd, d$)' },
            { category = 'Vim: Editing', key = 'c{motion}', desc = 'Change (cw, cc, c$)' },
            { category = 'Vim: Editing', key = 'y{motion}', desc = 'Yank/copy (yw, yy, y$)' },
            { category = 'Vim: Editing', key = 'p/P', desc = 'Paste after/before cursor' },
            { category = 'Vim: Editing', key = 'u/Ctrl-r', desc = 'Undo/redo' },
            { category = 'Vim: Editing', key = '.', desc = 'Repeat last change' },
            { category = 'Vim: Editing', key = 'r{char}', desc = 'Replace character' },
            { category = 'Vim: Editing', key = 'J', desc = 'Join lines' },
            { category = 'Vim: Editing', key = '~', desc = 'Toggle case' },
            { category = 'Vim: Editing', key = '>>/<<', desc = 'Indent/unindent line' },
            { category = 'Vim: Editing', key = '={motion}', desc = 'Auto-indent (==, =G)' },
            { category = 'Vim: Editing', key = 'gU{motion}', desc = 'Uppercase (gUiw, gUU)' },
            { category = 'Vim: Editing', key = 'gu{motion}', desc = 'Lowercase (guiw, guu)' },
            { category = 'Vim: Editing', key = 'g~{motion}', desc = 'Toggle case (g~iw, g~~)' },
            { category = 'Vim: Editing', key = 'gq{motion}', desc = 'Format text (gqip)' },
            { category = 'Vim: Editing', key = 'gJ', desc = 'Join lines without space' },
            { category = 'Vim: Editing', key = 'Ctrl-a/Ctrl-x', desc = 'Increment/decrement number' },
            
            -- Comments (Neovim 0.10+ built-in)
            { category = 'Vim: Comments', key = 'gcc', desc = 'Toggle comment line' },
            { category = 'Vim: Comments', key = 'gc{motion}', desc = 'Toggle comment (gcap, gcip)' },
            { category = 'Vim: Comments', key = 'gc (visual)', desc = 'Toggle comment selection' },
            { category = 'Vim: Comments', key = 'gbc', desc = 'Toggle block comment line' },
            { category = 'Vim: Comments', key = 'gb{motion}', desc = 'Toggle block comment (gbap)' },
            { category = 'Vim: Comments', key = 'gb (visual)', desc = 'Toggle block comment selection' },
            { category = 'Vim: Comments', key = 'gcO', desc = 'Add comment above' },
            { category = 'Vim: Comments', key = 'gco', desc = 'Add comment below' },
            { category = 'Vim: Comments', key = 'gcA', desc = 'Add comment at end of line' },
            
            -- Line operations
            { category = 'Vim: Lines', key = 'dd', desc = 'Delete line' },
            { category = 'Vim: Lines', key = 'yy', desc = 'Yank/copy line' },
            { category = 'Vim: Lines', key = 'cc', desc = 'Change line' },
            { category = 'Vim: Lines', key = 'D', desc = 'Delete to end of line' },
            { category = 'Vim: Lines', key = 'C', desc = 'Change to end of line' },
            { category = 'Vim: Lines', key = 'Y', desc = 'Yank to end of line' },
            { category = 'Vim: Lines', key = 'S', desc = 'Substitute line (same as cc)' },
            { category = 'Vim: Lines', key = ':m {line}', desc = 'Move line to line number' },
            { category = 'Vim: Lines', key = ':t {line}', desc = 'Copy line to line number' },
            { category = 'Vim: Lines', key = ':5,10d', desc = 'Delete lines 5-10' },
            { category = 'Vim: Lines', key = ':5,10y', desc = 'Yank lines 5-10' },

            { category = 'Vim: Visual', key = 'v/V/Ctrl-v', desc = 'Visual/line/block mode' },
            { category = 'Vim: Visual', key = 'o', desc = 'Go to other end of selection' },
            { category = 'Vim: Visual', key = 'gv', desc = 'Reselect last visual' },
            { category = 'Vim: Visual', key = '>/<', desc = 'Indent/unindent selection' },
            { category = 'Vim: Visual', key = 'I/A (block)', desc = 'Insert at start/end of block' },
            { category = 'Vim: Visual', key = 'U/u', desc = 'Uppercase/lowercase selection' },
            { category = 'Vim: Visual', key = '~', desc = 'Toggle case of selection' },
            { category = 'Vim: Visual', key = 'J', desc = 'Join selected lines' },
            { category = 'Vim: Visual', key = 'y/d/c', desc = 'Yank/delete/change selection' },
            { category = 'Vim: Visual', key = 'p', desc = 'Replace selection with paste' },
            { category = 'Vim: Visual', key = ':sort', desc = 'Sort selected lines' },
            { category = 'Vim: Visual', key = ':!{cmd}', desc = 'Filter selection through command' },
            { category = 'Vim: Visual', key = ':norm {cmd}', desc = 'Execute normal command on each line' },
            { category = 'Vim: Visual', key = 'g Ctrl-a', desc = 'Increment numbers sequentially' },
            { category = 'Vim: Visual', key = 'Ctrl-a/x', desc = 'Increment/decrement all numbers' },

            -- ============================================================
            -- COMMON WORKFLOWS & PATTERNS
            -- ============================================================
            -- Multi-file search (project-wide)
            { category = 'Workflow: Multi-File Search', key = '<leader>/', desc = 'Live grep - search all files in project' },
            { category = 'Workflow: Multi-File Search', key = '<leader>sg', desc = 'Live grep - search all files (alt)' },
            { category = 'Workflow: Multi-File Search', key = '<leader>sw', desc = 'Search word under cursor across project' },
            { category = 'Workflow: Multi-File Search', key = '<leader>/ → Ctrl-q', desc = 'Grep search → send results to quickfix' },
            { category = 'Workflow: Multi-File Search', key = '<leader>sw → Ctrl-q', desc = 'Word search → send to quickfix' },
            { category = 'Workflow: Multi-File Search', key = ':vimgrep /pattern/ **/*', desc = 'Vim native grep (all files)' },
            { category = 'Workflow: Multi-File Search', key = ':vimgrep /pattern/ **/*.js', desc = 'Grep specific file types' },
            
            -- Multi-file replace (no confirmation)
            { category = 'Workflow: Multi-File Replace', key = '<leader>/ → Ctrl-q → :cdo s/old/new/g | update', desc = '1. Grep → 2. Quickfix → 3. Replace all' },
            { category = 'Workflow: Multi-File Replace', key = '<leader>sw → Ctrl-q → :cfdo %s/old/new/g | update', desc = 'Word search → Replace per file (faster)' },
            { category = 'Workflow: Multi-File Replace', key = ':vimgrep /old/ ** | cdo s/old/new/g | update', desc = 'One-liner: grep + replace all' },
            { category = 'Workflow: Multi-File Replace', key = ':bufdo %s/old/new/ge | update', desc = 'Replace in all open buffers (e=no error)' },
            
            -- Multi-file replace (with confirmation)
            { category = 'Workflow: Multi-File Replace', key = '<leader>/ → Ctrl-q → :cdo s/old/new/gc | update', desc = 'Grep → Replace with confirmation (each match)' },
            { category = 'Workflow: Multi-File Replace', key = '<leader>/ → Ctrl-q → :cfdo %s/old/new/gc | update', desc = 'Grep → Confirm once per file' },
            { category = 'Workflow: Multi-File Replace', key = ':vimgrep /old/ ** | cdo s/old/new/gc | update', desc = 'Grep + confirm each replacement' },
            
            -- Interactive multi-file replace workflow
            { category = 'Workflow: Multi-File Replace', key = '*cgn{new}<Esc> → ]q → .', desc = 'Change next → jump to next match → repeat' },
            { category = 'Workflow: Multi-File Replace', key = '<leader>sw → ]q → cgn{new}<Esc> → ]q → .', desc = 'Search → jump → change → repeat (visual feedback)' },
            { category = 'Workflow: Multi-File Replace', key = ':cdo normal! @a | update', desc = 'Run macro on all quickfix entries' },
            
            -- Quickfix navigation for multi-file operations
            { category = 'Workflow: Multi-File Replace', key = ':copen', desc = 'Open quickfix window (review before replace)' },
            { category = 'Workflow: Multi-File Replace', key = ']q / [q', desc = 'Jump next/prev quickfix result' },
            { category = 'Workflow: Multi-File Replace', key = ':cnext / :cprev', desc = 'Next/prev quickfix (command form)' },
            { category = 'Workflow: Multi-File Replace', key = ':clist', desc = 'List all quickfix results' },
            
            -- Replace command reference
            { category = 'Workflow: Multi-File Replace', key = ':cdo', desc = 'Execute command on each quickfix ENTRY' },
            { category = 'Workflow: Multi-File Replace', key = ':cfdo', desc = 'Execute command on each quickfix FILE (faster)' },
            { category = 'Workflow: Multi-File Replace', key = ':bufdo', desc = 'Execute command on each open BUFFER' },
            { category = 'Workflow: Multi-File Replace', key = '| update', desc = 'Chain: save after each replacement' },
            { category = 'Workflow: Multi-File Replace', key = '/gc', desc = 'Flag: confirm each replacement (y/n/a/q/l)' },
            { category = 'Workflow: Multi-File Replace', key = '/ge', desc = 'Flag: no error if pattern not found' },
            
            -- Multi-cursor simulation
            { category = 'Workflow: Multi-Edit', key = '*cgn{text}<Esc>', desc = 'Change next occurrence, then . to repeat' },
            { category = 'Workflow: Multi-Edit', key = 'qayiw/<C-r>"<CR>cw{text}<Esc>q', desc = 'Record macro, then @a and @@' },
            { category = 'Workflow: Multi-Edit', key = 'Ctrl-v select → I{text}<Esc>', desc = 'Visual block insert' },
            
            -- Code navigation workflow
            { category = 'Workflow: Navigate', key = 'grd → Ctrl-o', desc = 'Go to definition, jump back' },
            { category = 'Workflow: Navigate', key = '<Space>sw → ]q', desc = 'Search word → jump through results' },
            { category = 'Workflow: Navigate', key = 'K → K → q', desc = 'Hover → follow link → close' },
            
            -- Refactoring workflow
            { category = 'Workflow: Refactor', key = 'grn', desc = 'Rename symbol (LSP)' },
            { category = 'Workflow: Refactor', key = '<Space>cR', desc = 'Rename file (updates imports)' },
            { category = 'Workflow: Refactor', key = 'gra', desc = 'Code actions (extract, inline, etc.)' },
            
            -- Git workflow
            { category = 'Workflow: Git', key = ']c → <Space>hp → <Space>hs', desc = 'Next change → preview → stage' },
            { category = 'Workflow: Git', key = '<Space>hb → <Space>gb', desc = 'Blame line → open in browser' },
            { category = 'Workflow: Git', key = 'Select → <Space>hs', desc = 'Visual select → stage hunk' },

            -- Search & Replace (comprehensive)
            { category = 'Vim: Search', key = '/{pattern}', desc = 'Search forward' },
            { category = 'Vim: Search', key = '?{pattern}', desc = 'Search backward' },
            { category = 'Vim: Search', key = 'n/N', desc = 'Next/previous match' },
            { category = 'Vim: Search', key = '*/#', desc = 'Search word under cursor fwd/back' },
            { category = 'Vim: Search', key = ':noh', desc = 'Clear search highlight' },
            
            -- Replace variations (flags: g=global, c=confirm, i=ignore case)
            { category = 'Vim: Replace', key = ':s/old/new/', desc = 'Replace first in line' },
            { category = 'Vim: Replace', key = ':s/old/new/g', desc = 'Replace all in line' },
            { category = 'Vim: Replace', key = ':s/old/new/gc', desc = 'Replace in line (confirm each)' },
            { category = 'Vim: Replace', key = ':%s/old/new/g', desc = 'Replace all in file' },
            { category = 'Vim: Replace', key = ':%s/old/new/gc', desc = 'Replace in file (confirm each)' },
            { category = 'Vim: Replace', key = ':%s/old/new/gi', desc = 'Replace all (case insensitive)' },
            { category = 'Vim: Replace', key = ":'<,'>s/old/new/g", desc = 'Replace in visual selection' },
            { category = 'Vim: Replace', key = ':5,10s/old/new/g', desc = 'Replace in line range' },
            { category = 'Vim: Replace', key = ':.,+5s/old/new/g', desc = 'Replace current + 5 lines' },
            { category = 'Vim: Replace', key = ':%s//new/g', desc = 'Replace last search pattern' },
            
            -- Confirm prompts: y=yes, n=no, a=all, q=quit, l=this and quit
            { category = 'Vim: Replace', key = 'y/n/a/q/l', desc = 'Confirm: yes/no/all/quit/last' },
            
            -- Macro recording
            { category = 'Vim: Macros', key = 'q{letter}', desc = 'Start recording macro' },
            { category = 'Vim: Macros', key = 'q', desc = 'Stop recording macro' },
            { category = 'Vim: Macros', key = '@{letter}', desc = 'Play macro' },
            { category = 'Vim: Macros', key = '@@', desc = 'Replay last macro' },
            { category = 'Vim: Macros', key = '{count}@{letter}', desc = 'Repeat macro N times' },
            { category = 'Vim: Macros', key = ':reg', desc = 'View all macros/registers' },
            
            -- Marks (navigate to locations)
            { category = 'Vim: Marks', key = 'm{letter}', desc = 'Set mark (a-z local, A-Z global)' },
            { category = 'Vim: Marks', key = "'{letter}", desc = 'Jump to mark line' },
            { category = 'Vim: Marks', key = '`{letter}', desc = 'Jump to mark exact position' },
            { category = 'Vim: Marks', key = "''", desc = 'Jump to last jump position' },
            { category = 'Vim: Marks', key = "`.`", desc = 'Jump to last edit position' },
            { category = 'Vim: Marks', key = ':marks', desc = 'List all marks' },
            { category = 'Vim: Marks', key = ':delmarks a-z', desc = 'Delete marks' },
            
            -- Registers (copy/paste storage)
            { category = 'Vim: Registers', key = '"{letter}y', desc = 'Yank to register' },
            { category = 'Vim: Registers', key = '"{letter}p', desc = 'Paste from register' },
            { category = 'Vim: Registers', key = '"0p', desc = 'Paste last yank (not delete)' },
            { category = 'Vim: Registers', key = '"+y', desc = 'Yank to system clipboard' },
            { category = 'Vim: Registers', key = '"+p', desc = 'Paste from system clipboard' },
            { category = 'Vim: Registers', key = ':reg', desc = 'View all registers' },
            
            -- Jump list navigation
            { category = 'Vim: Jumps', key = 'Ctrl-o', desc = 'Jump to older position' },
            { category = 'Vim: Jumps', key = 'Ctrl-i', desc = 'Jump to newer position' },
            { category = 'Vim: Jumps', key = ':jumps', desc = 'View jump list' },
            { category = 'Vim: Jumps', key = 'g;', desc = 'Go to older change position' },
            { category = 'Vim: Jumps', key = 'g,', desc = 'Go to newer change position' },
            { category = 'Vim: Jumps', key = ':changes', desc = 'View change list' },

            { category = 'Vim: Windows', key = 'Ctrl-w s', desc = 'Split horizontal' },
            { category = 'Vim: Windows', key = 'Ctrl-w v', desc = 'Split vertical' },
            { category = 'Vim: Windows', key = 'Ctrl-w c', desc = 'Close window' },
            { category = 'Vim: Windows', key = 'Ctrl-w o', desc = 'Close other windows' },
            { category = 'Vim: Windows', key = 'Ctrl-w =', desc = 'Balance windows' },
            { category = 'Vim: Windows', key = 'Ctrl-h/j/k/l', desc = 'Navigate windows' },

            { category = 'Vim: Tabs', key = ':tabnew', desc = 'New tab' },
            { category = 'Vim: Tabs', key = ':tabc', desc = 'Close tab' },
            { category = 'Vim: Tabs', key = 'gt/gT', desc = 'Next/previous tab' },
            { category = 'Vim: Tabs', key = '{count}gt', desc = 'Go to tab number' },

            { category = 'Vim: Buffers', key = ':bn/:bp', desc = 'Next/previous buffer' },
            { category = 'Vim: Buffers', key = ':bd', desc = 'Delete buffer' },
            { category = 'Vim: Buffers', key = ':b {name}', desc = 'Switch to buffer by name' },
            { category = 'Vim: Buffers', key = ':ls or :buffers', desc = 'List all buffers' },
            { category = 'Vim: Buffers', key = 'Ctrl-^', desc = 'Switch to alternate buffer' },
            
            { category = 'Vim: Folding', key = 'za', desc = 'Toggle fold' },
            { category = 'Vim: Folding', key = 'zo/zc', desc = 'Open/close fold' },
            { category = 'Vim: Folding', key = 'zR/zM', desc = 'Open/close all folds' },
            { category = 'Vim: Folding', key = 'zj/zk', desc = 'Move to next/previous fold' },
            { category = 'Vim: Folding', key = 'zf{motion}', desc = 'Create fold' },
            { category = 'Vim: Folding', key = 'zd', desc = 'Delete fold' },
            
            { category = 'Vim: Spell', key = ':set spell', desc = 'Enable spell check' },
            { category = 'Vim: Spell', key = ':set nospell', desc = 'Disable spell check' },
            { category = 'Vim: Spell', key = 'z=', desc = 'Suggest corrections' },
            { category = 'Vim: Spell', key = 'zg', desc = 'Add word to dictionary' },
            { category = 'Vim: Spell', key = 'zw', desc = 'Mark word as wrong' },
            { category = 'Vim: Spell', key = ']s/[s', desc = 'Next/previous misspelled word' },

            { category = 'Vim: Files', key = ':w', desc = 'Save file' },
            { category = 'Vim: Files', key = ':w !sudo tee %', desc = 'Save with sudo' },
            { category = 'Vim: Files', key = ':q', desc = 'Quit' },
            { category = 'Vim: Files', key = ':wq or ZZ', desc = 'Save and quit' },
            { category = 'Vim: Files', key = ':q! or ZQ', desc = 'Quit without saving' },
            { category = 'Vim: Files', key = ':e {file}', desc = 'Edit file' },
            { category = 'Vim: Files', key = ':e!', desc = 'Reload file (discard changes)' },
            { category = 'Vim: Files', key = ':saveas {file}', desc = 'Save as new file' },
            
            { category = 'Vim: Command', key = ':', desc = 'Enter command mode' },
            { category = 'Vim: Command', key = 'q:', desc = 'Open command history window' },
            { category = 'Vim: Command', key = 'Ctrl-f (in :)', desc = 'Edit command in window' },
            { category = 'Vim: Command', key = ':!{cmd}', desc = 'Run shell command' },
            { category = 'Vim: Command', key = ':r !{cmd}', desc = 'Insert command output' },
            { category = 'Vim: Command', key = ':{range}!{cmd}', desc = 'Filter lines through command' },
            { category = 'Vim: Command', key = ':shell', desc = 'Open shell (exit to return)' },

            -- ============================================================
            -- LEADER KEYMAPS (CORE)
            -- ============================================================
            { category = 'Core: Quit', key = '<Space>Q', desc = 'Quit all' },
            { category = 'Core: Files', key = '\\', desc = 'Toggle Neo-tree' },
            { category = 'Core: Files', key = 'Esc', desc = 'Close floating windows or clear highlight' },
            { category = 'Core: Terminal', key = 'Esc Esc', desc = 'Exit terminal mode (in terminal)' },
            
            -- Code operations
            { category = 'Code', key = '<Space>cq', desc = 'Toggle diagnostic quickfix' },
            { category = 'Code', key = '<Space>cf', desc = 'Format buffer/selection (conform.nvim)' },

            -- ============================================================
            -- BUFFER WORKFLOW
            -- ============================================================
            -- Opening files/buffers
            { category = 'Buffer: Open', key = '<Space>sf', desc = 'Find and open file (Telescope)' },
            { category = 'Buffer: Open', key = '\\', desc = 'Browse and open file (Neo-tree)' },
            { category = 'Buffer: Open', key = ':e filename', desc = 'Edit/open file by path' },
            { category = 'Buffer: Open', key = 'gf', desc = 'Go to file under cursor' },
            { category = 'Buffer: Open', key = ':e %:h/file', desc = 'Open file in current directory' },
            
            -- Switching between buffers
            { category = 'Buffer: Switch', key = '<Space><Space>', desc = 'Buffer picker (enhanced with icons/diagnostics)' },
            { category = 'Buffer: Switch', key = ']b', desc = 'Next buffer' },
            { category = 'Buffer: Switch', key = '[b', desc = 'Previous buffer' },
            { category = 'Buffer: Switch', key = ']B', desc = 'Last buffer' },
            { category = 'Buffer: Switch', key = '[B', desc = 'First buffer' },
            { category = 'Buffer: Switch', key = ':ls', desc = 'List all buffers' },
            
            -- Closing/deleting buffers
            { category = 'Buffer: Close', key = '<Space>bd', desc = 'Delete buffer (smart - closes window if last)' },
            { category = 'Buffer: Close', key = '<Space>bD', desc = 'Force delete buffer' },
            { category = 'Buffer: Close', key = '<Space>bu', desc = 'Unload buffer (keep in list)' },
            { category = 'Buffer: Close', key = '<Space>bo', desc = 'Delete other buffers' },
            { category = 'Buffer: Close', key = ':bd', desc = 'Delete buffer (native)' },
            { category = 'Buffer: Close', key = ':bd!', desc = 'Force delete without saving' },
            { category = 'Buffer: Close', key = ':bd 3', desc = 'Delete buffer number 3' },
            { category = 'Buffer: Close', key = ':bunload', desc = 'Unload buffer (native)' },
            
            -- Buffer info
            { category = 'Buffer: Info', key = 'Ctrl-g', desc = 'Show buffer info' },
            { category = 'Buffer: Info', key = '<Space>sn', desc = 'Find in Neovim config' },

            -- ============================================================
            -- BUFFER OPERATIONS (Additional)
            -- ============================================================
            { category = 'Buffer', key = '<Space>bn', desc = 'Next buffer (prefer ]b)' },
            { category = 'Buffer', key = '<Space>bp', desc = 'Previous buffer (prefer [b)' },
            { category = 'Buffer', key = '<Space>bS', desc = 'Toggle scratch buffer (snacks)' },
            { category = 'Buffer', key = '<Space>bs', desc = 'Select scratch buffer (snacks)' },

            -- ============================================================
            -- WINDOW OPERATIONS
            -- ============================================================
            { category = 'Window', key = '<Space>ww', desc = 'Other window' },
            { category = 'Window', key = '<Space>wc', desc = 'Close window/tab' },
            { category = 'Window', key = '<Space>ws', desc = 'Split window below' },
            { category = 'Window', key = '<Space>wv', desc = 'Split window right' },
            { category = 'Window', key = '<Space>wm', desc = 'Maximize window' },
            { category = 'Window', key = '<Space>w=', desc = 'Balance windows' },
            { category = 'Window', key = '<Space>wh', desc = 'Go to left window' },
            { category = 'Window', key = '<Space>wj', desc = 'Go to lower window' },
            { category = 'Window', key = '<Space>wk', desc = 'Go to upper window' },
            { category = 'Window', key = '<Space>wl', desc = 'Go to right window' },
            { category = 'Window', key = 'Ctrl-h', desc = 'Move focus to left window' },
            { category = 'Window', key = 'Ctrl-j', desc = 'Move focus to lower window' },
            { category = 'Window', key = 'Ctrl-k', desc = 'Move focus to upper window' },
            { category = 'Window', key = 'Ctrl-l', desc = 'Move focus to right window' },

            -- ============================================================
            -- TAB OPERATIONS (under Window menu)
            -- ============================================================
            { category = 'Tab', key = '<Space>wn', desc = 'New tab' },
            { category = 'Tab', key = '<Space>wo', desc = 'Close other tabs' },
            { category = 'Tab', key = '<Space>w]', desc = 'Next tab' },
            { category = 'Tab', key = '<Space>w[', desc = 'Previous tab' },
            { category = 'Tab', key = '<Space>w>', desc = 'Move tab right' },
            { category = 'Tab', key = '<Space>w<', desc = 'Move tab left' },
            { category = 'Tab', key = '<Space>wf', desc = 'First tab' },
            { category = 'Tab', key = '<Space>wL', desc = 'Last tab' },
            { category = 'Tab', key = 'gt', desc = 'Next tab (Vim native)' },
            { category = 'Tab', key = 'gT', desc = 'Previous tab (Vim native)' },
            { category = 'Tab', key = ':tabnew', desc = 'New tab (command)' },

            -- ============================================================
            -- SEARCH (TELESCOPE)
            -- ============================================================
            { category = 'Search', key = '<Space>sh', desc = 'Help' },
            { category = 'Search', key = '<Space>sk', desc = 'Keymaps' },
            { category = 'Search', key = '<Space>sf', desc = 'Files' },
            { category = 'Search', key = '<Space>ss', desc = 'Select Telescope' },
            { category = 'Search', key = '<Space>sw', desc = 'Current word' },
            { category = 'Search', key = '<Space>sg', desc = 'Grep' },
            { category = 'Search', key = '<Space>sd', desc = 'Diagnostics' },
            { category = 'Search', key = '<Space>sr', desc = 'Resume' },
            { category = 'Search', key = '<Space>s.', desc = 'Recent files' },
            { category = 'Search', key = '<Space>s/', desc = 'In open files' },
            { category = 'Search', key = '<Space>sn', desc = 'Neovim config' },
            { category = 'Search', key = '<Space>sc', desc = 'Cheatsheet (this!)' },
            { category = 'Search', key = '<Space>sK', desc = 'All keymaps (which-key)' },
            { category = 'Search', key = '<Space>/', desc = 'Fuzzy find in buffer' },

            -- ============================================================
            -- SESSION (Auto-saves on exit, manual restore)
            -- ============================================================
            { category = 'Session', key = '<Space>Ss', desc = 'Save session manually' },
            { category = 'Session', key = '<Space>Sr', desc = 'Restore session (or use dashboard "s")' },
            { category = 'Session', key = '<Space>Sd', desc = 'Delete session' },
            { category = 'Session', key = '<Space>Sf', desc = 'Find/browse all sessions' },

            -- ============================================================
            -- UI OPERATIONS
            -- ============================================================
            { category = 'UI', key = '<Space>ul', desc = 'Open Lazy' },
            { category = 'UI', key = '<Space>um', desc = 'Open Mason' },
            { category = 'UI', key = '<Space>ui', desc = 'Inspect position (treesitter)' },
            { category = 'UI', key = '<Space>uI', desc = 'Inspect tree (treesitter)' },
            { category = 'UI', key = '<Space>un', desc = 'Dismiss all notifications' },
            { category = 'UI', key = '<Space>uh', desc = 'Notification history' },

            -- ============================================================
            -- TOGGLE
            -- ============================================================
            { category = 'Toggle', key = '<Space>ta', desc = 'Copilot Autocomplete' },
            { category = 'Toggle', key = '<Space>tr', desc = 'Relative line numbers' },
            { category = 'Toggle', key = '<Space>tv', desc = 'Virtual text (inline diagnostic messages)' },
            { category = 'Toggle', key = '<Space>th', desc = 'Inlay hints (LSP)' },
            { category = 'Toggle', key = '<Space>td', desc = 'ALL Diagnostics - gutter + virtual text (snacks)' },
            { category = 'Toggle', key = '<Space>tl', desc = 'Line numbers (snacks)' },
            { category = 'Toggle', key = '<Space>ts', desc = 'Smooth scroll (snacks)' },
            { category = 'Toggle', key = '<Space>tw', desc = 'Word highlights (snacks)' },
            { category = 'Toggle', key = '<Space>ti', desc = 'Indent guides (snacks)' },

            -- ============================================================
            -- DIAGNOSTICS
            -- ============================================================
            { category = 'Diagnostics', key = '<Space>xx', desc = 'Toggle diagnostics (Trouble)' },
            { category = 'Diagnostics', key = '<Space>xX', desc = 'Buffer diagnostics (Trouble)' },
            { category = 'Diagnostics', key = '<Space>xs', desc = 'Symbols (Trouble)' },

            -- ============================================================
            -- QUICKFIX & LOCATION LIST OPERATIONS
            -- ============================================================
            -- Quickfix (global list - shared across windows)
            { category = 'Quickfix', key = ':copen', desc = 'Open quickfix window' },
            { category = 'Quickfix', key = ':cclose', desc = 'Close quickfix window' },
            { category = 'Quickfix', key = ':cnext', desc = 'Next item in quickfix' },
            { category = 'Quickfix', key = ':cprev', desc = 'Previous item in quickfix' },
            { category = 'Quickfix', key = ':cfirst', desc = 'First item in quickfix' },
            { category = 'Quickfix', key = ':clast', desc = 'Last item in quickfix' },
            { category = 'Quickfix', key = ':cnfile', desc = 'First item in next file' },
            { category = 'Quickfix', key = ':cpfile', desc = 'Last item in previous file' },
            { category = 'Quickfix', key = ':cdo {cmd}', desc = 'Execute command on each quickfix entry' },
            { category = 'Quickfix', key = ':cfdo {cmd}', desc = 'Execute command on each file in quickfix' },
            
            -- Location list (window-local - each window has its own)
            { category = 'Location List', key = ':lopen', desc = 'Open location list window' },
            { category = 'Location List', key = ':lclose', desc = 'Close location list window' },
            { category = 'Location List', key = ':lnext', desc = 'Next item in location list' },
            { category = 'Location List', key = ':lprev', desc = 'Previous item in location list' },
            { category = 'Location List', key = ':lfirst', desc = 'First item in location list' },
            { category = 'Location List', key = ':llast', desc = 'Last item in location list' },
            { category = 'Location List', key = ':lnfile', desc = 'First item in next file' },
            { category = 'Location List', key = ':lpfile', desc = 'Last item in previous file' },
            { category = 'Location List', key = ':ldo {cmd}', desc = 'Execute command on each location entry' },
            { category = 'Location List', key = ':lfdo {cmd}', desc = 'Execute command on each file in location list' },

            -- ============================================================
            -- COPILOT (AI CODE COMPLETION)
            -- ============================================================
            { category = 'Copilot', key = 'Tab (insert)', desc = 'Accept Copilot suggestion' },
            { category = 'Copilot', key = 'Ctrl-]', desc = 'Dismiss Copilot suggestion' },
            { category = 'Copilot', key = 'Alt-]', desc = 'Next Copilot suggestion' },
            { category = 'Copilot', key = 'Alt-[', desc = 'Previous Copilot suggestion' },
            { category = 'Copilot', key = 'Alt-\\', desc = 'Trigger Copilot manually' },
            { category = 'Copilot', key = '<Space>ta', desc = 'Toggle Copilot on/off' },
            { category = 'Copilot', key = ':Copilot setup', desc = 'Setup/auth Copilot' },
            { category = 'Copilot', key = ':Copilot status', desc = 'Check Copilot status' },
            { category = 'Copilot', key = ':Copilot panel', desc = 'Open Copilot panel' },

            -- ============================================================
            -- EMMET (HTML/CSS ABBREVIATIONS)
            -- ============================================================
            -- Available in: HTML, CSS, JavaScript, TypeScript, Svelte files
            { category = 'Emmet', key = 'Ctrl-e,', desc = 'Expand abbreviation (div.class>ul>li*3)' },
            { category = 'Emmet', key = 'Ctrl-e;', desc = 'Expand word (w100 → width:100px)' },
            { category = 'Emmet', key = 'Ctrl-e u', desc = 'Update tag' },
            { category = 'Emmet', key = 'Ctrl-e d', desc = 'Balance tag outward' },
            { category = 'Emmet', key = 'Ctrl-e D', desc = 'Balance tag inward' },
            { category = 'Emmet', key = 'Ctrl-e n', desc = 'Go to next edit point' },
            { category = 'Emmet', key = 'Ctrl-e N', desc = 'Go to previous edit point' },
            { category = 'Emmet', key = 'Ctrl-e k', desc = 'Remove tag' },
            { category = 'Emmet', key = 'Ctrl-e /', desc = 'Toggle comment' },
            { category = 'Emmet', key = 'Ctrl-e a', desc = 'Make anchor from URL' },
            { category = 'Emmet', key = 'Ctrl-e A', desc = 'Make quoted text from URL' },
            
            -- Common Emmet patterns
            { category = 'Emmet: Patterns', key = 'div.class#id', desc = '<div class="class" id="id"></div>' },
            { category = 'Emmet: Patterns', key = 'ul>li*5', desc = 'ul with 5 li children' },
            { category = 'Emmet: Patterns', key = 'div+p+bq', desc = 'Siblings: div, p, blockquote' },
            { category = 'Emmet: Patterns', key = 'div>ul>li^div', desc = 'Climb up with ^' },
            { category = 'Emmet: Patterns', key = '(div>h1)+footer', desc = 'Grouping with ()' },
            { category = 'Emmet: Patterns', key = 'ul>li.item$*3', desc = 'Numbering: item1, item2, item3' },
            { category = 'Emmet: Patterns', key = 'a[href="#"]', desc = 'Custom attributes' },
            { category = 'Emmet: Patterns', key= 'p{Click me}', desc = 'Text content' },
            { category = 'Emmet: Patterns', key = 'lorem', desc = 'Lorem ipsum text' },
            { category = 'Emmet: Patterns', key = 'lorem5', desc = '5 words of lorem' },

            -- ============================================================
            -- GIT (GITSIGNS)
            -- ============================================================
            { category = 'Git', key = '<Space>hs', desc = 'Stage hunk (gitsigns)' },
            { category = 'Git', key = '<Space>hr', desc = 'Reset hunk (gitsigns)' },
            { category = 'Git', key = '<Space>hS', desc = 'Stage buffer (gitsigns)' },
            { category = 'Git', key = '<Space>hu', desc = 'Undo stage hunk (gitsigns)' },
            { category = 'Git', key = '<Space>hR', desc = 'Reset buffer (gitsigns)' },
            { category = 'Git', key = '<Space>hp', desc = 'Preview hunk (gitsigns)' },
            { category = 'Git', key = '<Space>hb', desc = 'Blame line (gitsigns)' },
            { category = 'Git', key = '<Space>hd', desc = 'Diff this (gitsigns)' },
            { category = 'Git', key = '<Space>hD', desc = 'Diff this ~ (gitsigns)' },
            { category = 'Git', key = ']c or ]h', desc = 'Next git change/hunk (gitsigns)' },
            { category = 'Git', key = '[c or [h', desc = 'Previous git change/hunk (gitsigns)' },
            
            -- ============================================================
            -- GIT (SNACKS)
            -- ============================================================
            { category = 'Git: Snacks', key = '<Space>gb', desc = 'Git browse (open in web)' },
            { category = 'Git: Snacks', key = '<Space>gB', desc = 'Git blame line' },
            { category = 'Git: Snacks', key = '<Space>gH', desc = 'GitHub CLI' },
            { category = 'Git: Snacks', key = '<Space>gI', desc = 'GitHub issues' },
            { category = 'Git: Snacks', key = '<Space>gP', desc = 'GitHub PRs' },

            -- ============================================================
            -- LSP (ALL LANGUAGES)
            -- ============================================================
            { category = 'LSP', key = 'K', desc = 'Hover documentation' },
            { category = 'LSP', key = 'grd', desc = 'Go to definition' },
            { category = 'LSP', key = 'grD', desc = 'Go to declaration' },
            { category = 'LSP', key = 'gri', desc = 'Go to implementation' },
            { category = 'LSP', key = 'grr', desc = 'Go to references' },
            { category = 'LSP', key = 'grt', desc = 'Go to type definition' },
            { category = 'LSP', key = 'grn', desc = 'Rename symbol' },
            { category = 'LSP', key = 'gra', desc = 'Code action' },
            { category = 'LSP', key = '<Space>.', desc = 'Code action (VSCode-style)' },
            { category = 'LSP', key = '<Space>cf', desc = 'Format buffer (conform.nvim)' },
            { category = 'LSP', key = 'gO', desc = 'Document symbols (Telescope)' },
            { category = 'LSP', key = 'gW', desc = 'Workspace symbols (Telescope)' },
            { category = 'LSP', key = '<Space>th', desc = 'Toggle inlay hints' },
            { category = 'LSP', key = 'q (in hover)', desc = 'Close LSP floating window' },
            { category = 'LSP', key = 'Esc', desc = 'Close all floating windows' },

            -- ============================================================
            -- DEBUG (ALL LANGUAGES)
            -- ============================================================
            { category = 'Debug', key = 'F5 or <Space>dc', desc = 'Start/Continue' },
            { category = 'Debug', key = 'F10 or <Space>dO', desc = 'Step over' },
            { category = 'Debug', key = 'F11 or <Space>di', desc = 'Step into' },
            { category = 'Debug', key = 'F12 or <Space>do', desc = 'Step out' },
            { category = 'Debug', key = '<Space>db', desc = 'Toggle breakpoint' },
            { category = 'Debug', key = '<Space>dB', desc = 'Conditional breakpoint' },
            { category = 'Debug', key = '<Space>dc or F5', desc = 'Continue' },
            { category = 'Debug', key = '<Space>di or F11', desc = 'Step into' },
            { category = 'Debug', key = '<Space>do or F12', desc = 'Step out' },
            { category = 'Debug', key = '<Space>dO or F10', desc = 'Step over' },
            { category = 'Debug', key = '<Space>dt', desc = 'Terminate' },
            { category = 'Debug', key = '<Space>dr', desc = 'Toggle REPL' },
            { category = 'Debug', key = '<Space>dl', desc = 'Run last' },
            { category = 'Debug', key = '<Space>dC', desc = 'Run to cursor' },
            { category = 'Debug', key = '<Space>du', desc = 'Toggle UI' },
            { category = 'Debug', key = '<Space>de', desc = 'Eval expression' },

            -- ============================================================
            -- FLUTTER (TERMINAL-BASED WORKFLOW)
            -- ============================================================
            -- Development
            { category = 'Flutter', key = '<Space>lfr', desc = 'Run app (select device if needed)' },
            { category = 'Flutter', key = '<Space>lfh', desc = 'Hot reload (works from anywhere)' },
            { category = 'Flutter', key = '<Space>lfR', desc = 'Hot restart (works from anywhere)' },
            { category = 'Flutter', key = '<Space>lfq', desc = 'Quit app (works from anywhere)' },
            { category = 'Flutter', key = '<Space>lfa', desc = 'Toggle auto-reload on save' },
            
            -- Device Management
            { category = 'Flutter', key = '<Space>lfd', desc = 'Select device (attached only, no wireless)' },
            { category = 'Flutter', key = '<Space>lfe', desc = 'Launch emulator' },
            
            -- DevTools
            { category = 'Flutter', key = '<Space>lft', desc = 'Open DevTools (sends v command)' },
            
            -- Project Commands
            { category = 'Flutter', key = '<Space>lfi', desc = 'Init Flutter project (with confirmation)' },
            { category = 'Flutter', key = '<Space>lfD', desc = 'Flutter doctor' },
            { category = 'Flutter', key = '<Space>lfC', desc = 'Flutter clean' },
            { category = 'Flutter', key = '<Space>lfp', desc = 'Flutter pub get' },
            { category = 'Flutter', key = '<Space>lfb', desc = 'Flutter build (select target)' },
            { category = 'Flutter', key = '<Space>lfT', desc = 'Flutter test' },
            
            -- LSP & Code Actions
            { category = 'Flutter', key = '<Space>lfl', desc = 'Restart LSP' },
            { category = 'Flutter', key = '<Space>. or gra', desc = 'Code actions (Cmd+.) - Dart files' },

            -- ============================================================
            -- RUST (BUFFER-LOCAL: .rs files only - rustaceanvim commands)
            -- ============================================================
            { category = 'Rust', key = '<Space>lrh', desc = 'Hover actions' },
            { category = 'Rust', key = '<Space>lra', desc = 'Code actions' },
            { category = 'Rust', key = '<Space>lre', desc = 'Explain error' },
            { category = 'Rust', key = '<Space>lrC', desc = 'Open Cargo.toml' },
            { category = 'Rust', key = '<Space>lrp', desc = 'Parent module' },
            { category = 'Rust', key = '<Space>lrj', desc = 'Join lines' },
            { category = 'Rust', key = '<Space>lrr', desc = 'Runnables' },
            { category = 'Rust', key = '<Space>lrd', desc = 'Debuggables' },
            { category = 'Rust', key = '<Space>lrm', desc = 'Expand macro' },

            -- ============================================================
            -- RUST CARGO WORKFLOW (GLOBAL - available in all buffers)
            -- ============================================================
            { category = 'Rust: Cargo', key = '<Space>lrb', desc = 'Build project (cargo build)' },
            { category = 'Rust: Cargo', key = '<Space>lrR', desc = 'Run project (cargo run)' },
            { category = 'Rust: Cargo', key = '<Space>lrt', desc = 'Test project (cargo test)' },
            { category = 'Rust: Cargo', key = '<Space>lrk', desc = 'Check project (cargo check - fast)' },
            { category = 'Rust: Cargo', key = '<Space>lrl', desc = 'Lint with Clippy (cargo clippy)' },
            { category = 'Rust: Cargo', key = '<Space>lrf', desc = 'Format code (cargo fmt)' },
            { category = 'Rust: Cargo', key = '<Space>lrx', desc = 'Clean artifacts (cargo clean)' },
            { category = 'Rust: Cargo', key = '<Space>lrA', desc = 'Add dependency (cargo add + prompt)' },
            { category = 'Rust: Cargo', key = '<Space>lrX', desc = 'Remove dependency (cargo remove + prompt)' },
            { category = 'Rust: Cargo', key = '<Space>lrU', desc = 'Update dependencies (cargo update)' },
            { category = 'Rust: Cargo', key = '<Space>lrD', desc = 'Build & open docs (cargo doc --open)' },

            -- ============================================================
            -- RUST CRATES (CARGO.TOML)
            -- ============================================================
            { category = 'Rust: Crates', key = '<Space>lrct', desc = 'Toggle crates popup' },
            { category = 'Rust: Crates', key = '<Space>lrcr', desc = 'Reload crates' },
            { category = 'Rust: Crates', key = '<Space>lrcv', desc = 'Show versions popup' },
            { category = 'Rust: Crates', key = '<Space>lrcf', desc = 'Show features popup' },
            { category = 'Rust: Crates', key = '<Space>lrcd', desc = 'Show dependencies popup' },
            { category = 'Rust: Crates', key = '<Space>lrcu', desc = 'Update crate under cursor' },
            { category = 'Rust: Crates', key = '<Space>lrcu (visual)', desc = 'Update selected crates' },
            { category = 'Rust: Crates', key = '<Space>lrca', desc = 'Update all crates' },
            { category = 'Rust: Crates', key = '<Space>lrcU', desc = 'Upgrade crate under cursor' },
            { category = 'Rust: Crates', key = '<Space>lrcU (visual)', desc = 'Upgrade selected crates' },
            { category = 'Rust: Crates', key = '<Space>lrcA', desc = 'Upgrade all crates' },
            { category = 'Rust: Crates', key = '<Space>lrce', desc = 'Expand to inline table' },
            { category = 'Rust: Crates', key = '<Space>lrcE', desc = 'Extract to table' },
            { category = 'Rust: Crates', key = '<Space>lrcH', desc = 'Open homepage' },
            { category = 'Rust: Crates', key = '<Space>lrcR', desc = 'Open repository' },
            { category = 'Rust: Crates', key = '<Space>lrcD', desc = 'Open documentation' },
            { category = 'Rust: Crates', key = '<Space>lrcC', desc = 'Open crates.io' },

            -- ============================================================
            -- PYTHON (GLOBAL - available in all buffers)
            -- ============================================================
            { category = 'Python', key = '<Space>lpr', desc = 'Run current file (uses custom command if set)' },
            { category = 'Python', key = '<Space>lpR', desc = 'Set custom run command (e.g., uvicorn main:app)' },
            { category = 'Python', key = '<Space>lpC', desc = 'Clear custom run command (reset to default)' },
            { category = 'Python', key = '<Space>lpS', desc = 'Open Python Shell (REPL)' },
            { category = 'Python', key = '<Space>lpX', desc = 'Execute visual selection (Python code)' },
            { category = 'Python', key = '<Space>lpi', desc = 'Initialize project (uv init)' },
            { category = 'Python', key = '<Space>lpa', desc = 'Add dependency (uv add)' },
            { category = 'Python', key = '<Space>lpA', desc = 'Remove dependency (uv remove)' },
            { category = 'Python', key = '<Space>lpu', desc = 'Sync dependencies (uv sync)' },
            { category = 'Python', key = '<Space>lpe', desc = 'Reload environment & LSP (after package changes)' },
            { category = 'Python', key = '<Space>lpv', desc = 'View installed packages' },
            { category = 'Python', key = '<Space>lpt', desc = 'Run tests (pytest)' },
            { category = 'Python', key = '<Space>lpc', desc = 'Check code style (ruff check)' },
            { category = 'Python', key = '<Space>lpl', desc = 'Lint and fix (ruff check --fix)' },

            -- ============================================================
            -- SVELTE/JS/TS (BUFFER-LOCAL: LSP & FORMATTING)
            -- ============================================================
            { category = 'Svelte/JS/TS', key = '<Space>lsf', desc = 'Format with prettier (Svelte only)' },
            { category = 'Svelte/JS/TS', key = '<Space>lsl', desc = 'Restart Svelte LSP (Svelte only)' },
            { category = 'Svelte/JS/TS', key = '<Space>lso', desc = 'Open component in split (Svelte only)' },
            { category = 'Svelte/JS/TS', key = 'Ctrl-e,', desc = 'Expand Emmet abbreviation' },

            -- ============================================================
            -- WEB DEV WORKFLOW (GLOBAL: SVELTE/JS/TS)
            -- ============================================================
            { category = 'Web Dev: Workflow', key = '<Space>lsr', desc = 'Run dev server (bun run dev)' },
            { category = 'Web Dev: Workflow', key = '<Space>lsb', desc = 'Build project (bun run build)' },
            { category = 'Web Dev: Workflow', key = '<Space>lsp', desc = 'Preview build (bun run preview)' },
            { category = 'Web Dev: Workflow', key = '<Space>lsc', desc = 'Type check (bun run check)' },
            { category = 'Web Dev: Workflow', key = '<Space>lse', desc = 'Lint (bun run lint)' },
            { category = 'Web Dev: Workflow', key = '<Space>lsT', desc = 'Run tests (bun test)' },
            { category = 'Web Dev: Workflow', key = '<Space>lsi', desc = 'Install deps (bun install)' },
            { category = 'Web Dev: Workflow', key = '<Space>lsa', desc = 'Add package (bun add + prompt)' },
            { category = 'Web Dev: Workflow', key = '<Space>lsA', desc = 'Add dev package (bun add -d + prompt)' },
            { category = 'Web Dev: Workflow', key = '<Space>lsx', desc = 'Remove package (bun remove + prompt)' },
            { category = 'Web Dev: Workflow', key = '<Space>lsu', desc = 'Update deps (bun update)' },
            { category = 'Web Dev: Workflow', key = '<Space>lst', desc = 'Restart TypeScript LSP' },

            -- ============================================================
            -- HTML/CSS (GLOBAL)
            -- ============================================================
            { category = 'HTML/CSS', key = '<Space>lho', desc = 'Open in preferred browser (HTML files only)' },
            { category = 'HTML/CSS', key = '<Space>lhb', desc = 'Set browser preference (menu, persists with session)' },
            { category = 'HTML/CSS', key = '<Space>lhl', desc = 'Start live-server (auto-reload in preferred browser)' },
            { category = 'HTML/CSS', key = 'Ctrl-e,', desc = 'Expand Emmet abbreviation' },

            -- ============================================================
            -- TELESCOPE (INSIDE TELESCOPE)
            -- ============================================================
            { category = 'Telescope', key = 'Ctrl-j/k', desc = 'Next/previous item' },
            { category = 'Telescope', key = 'j/k (normal)', desc = 'Next/previous item' },
            { category = 'Telescope', key = 'Ctrl-d/u', desc = 'Scroll preview down/up' },
            { category = 'Telescope', key = 'Ctrl-n/p', desc = 'Cycle history next/prev' },
            { category = 'Telescope', key = 'Enter', desc = 'Open in current window' },
            { category = 'Telescope', key = 'Ctrl-x', desc = 'Open in horizontal split' },
            { category = 'Telescope', key = 'Ctrl-v', desc = 'Open in vertical split' },
            { category = 'Telescope', key = 'Ctrl-t', desc = 'Open in new tab' },
            { category = 'Telescope', key = 'Ctrl-c/Esc/q', desc = 'Close' },
            { category = 'Telescope', key = 'Tab/Shift-Tab', desc = 'Toggle selection & move' },
            { category = 'Telescope', key = 'Ctrl-q', desc = 'Send all to quickfix' },
            { category = 'Telescope', key = 'Alt-q', desc = 'Send selected to quickfix' },
            { category = 'Telescope', key = '? (normal)', desc = 'Show help' },
            { category = 'Telescope', key = 'gg/G (normal)', desc = 'First/last item' },

            -- ============================================================
            -- NEO-TREE (INSIDE NEO-TREE)
            -- ============================================================
            { category = 'Neo-tree', key = '\\, q, or Esc', desc = 'Close Neo-tree' },
            { category = 'Neo-tree', key = 'Enter, o, or 2-click', desc = 'Open file' },
            { category = 'Neo-tree', key = 'Ctrl-x or S', desc = 'Open in horizontal split' },
            { category = 'Neo-tree', key = 'Ctrl-v or s', desc = 'Open in vertical split' },
            { category = 'Neo-tree', key = 'Ctrl-t or t', desc = 'Open in new tab' },
            { category = 'Neo-tree', key = 'w', desc = 'Open with window picker' },
            { category = 'Neo-tree', key = 'Ctrl-j or >', desc = 'Next source (files/buffers/git)' },
            { category = 'Neo-tree', key = 'Ctrl-k or <', desc = 'Previous source' },
            { category = 'Neo-tree', key = 'P', desc = 'Toggle preview (float)' },
            { category = 'Neo-tree', key = 'l', desc = 'Focus preview' },
            { category = 'Neo-tree', key = 'R', desc = 'Refresh' },
            { category = 'Neo-tree', key = 'H', desc = 'Toggle hidden files' },
            { category = 'Neo-tree', key = '-', desc = 'Navigate up (parent dir)' },
            { category = 'Neo-tree', key = '.', desc = 'Set root (cd into directory)' },
            { category = 'Neo-tree', key = 'C', desc = 'Close node (collapse folder)' },
            { category = 'Neo-tree', key = 'z', desc = 'Close all nodes' },
            { category = 'Neo-tree', key = 'e', desc = 'Toggle auto expand width' },
            { category = 'Neo-tree', key = 'a', desc = 'Add file' },
            { category = 'Neo-tree', key = 'A', desc = 'Add directory' },
            { category = 'Neo-tree', key = 'd', desc = 'Delete' },
            { category = 'Neo-tree', key = 'r', desc = 'Rename' },
            { category = 'Neo-tree', key = 'y', desc = 'Copy to clipboard' },
            { category = 'Neo-tree', key = 'x', desc = 'Cut to clipboard' },
            { category = 'Neo-tree', key = 'p', desc = 'Paste from clipboard' },
            { category = 'Neo-tree', key = 'c', desc = 'Copy (with path input)' },
            { category = 'Neo-tree', key = 'm', desc = 'Move (with path input)' },
            { category = 'Neo-tree', key = '?', desc = 'Show help (in Neo-tree)' },
            { category = 'Neo-tree', key = '/', desc = 'Telescope find from root dir' },
            { category = 'Neo-tree', key = '<Space>sf', desc = 'Telescope find from current dir' },
            { category = 'Neo-tree', key = '<Space>sg', desc = 'Telescope grep from current dir' },

            -- ============================================================
            -- SNACKS.NVIM (QOL FEATURES)
            -- ============================================================
            -- Dashboard (startup screen)
            { category = 'Snacks: Dashboard', key = 'f', desc = 'Find File (dashboard)' },
            { category = 'Snacks: Dashboard', key = 'n', desc = 'New File (dashboard)' },
            { category = 'Snacks: Dashboard', key = 'g', desc = 'Find Text (dashboard)' },
            { category = 'Snacks: Dashboard', key = 'r', desc = 'Recent Files (dashboard)' },
            { category = 'Snacks: Dashboard', key = 'c', desc = 'Config (dashboard)' },
            { category = 'Snacks: Dashboard', key = 's', desc = 'Restore Session (dashboard)' },
            { category = 'Snacks: Dashboard', key = 'l', desc = 'Lazy (dashboard)' },
            { category = 'Snacks: Dashboard', key = 'q', desc = 'Quit (dashboard)' },
            
            -- Buffers
            { category = 'Snacks: Buffers', key = '<Space>bd', desc = 'Delete buffer (smart)' },
            { category = 'Snacks: Buffers', key = '<Space>bo', desc = 'Delete other buffers' },
            
            -- Files
            { category = 'Snacks: Files', key = '<Space>cR', desc = 'Rename file (LSP-aware)' },
            
            -- Scratch buffers
            { category = 'Snacks: Scratch', key = '<Space>bS', desc = 'Toggle scratch buffer' },
            { category = 'Snacks: Scratch', key = '<Space>bs', desc = 'Select scratch buffer' },
            { category = 'Snacks: Scratch', key = 'Enter (in scratch)', desc = 'Execute Lua line' },
            
            -- Word references
            { category = 'Snacks: Words', key = ']]', desc = 'Jump to next word occurrence' },
            { category = 'Snacks: Words', key = '[[', desc = 'Jump to previous word occurrence' },
            
            -- ============================================================
            -- BRACKET NAVIGATION OVERVIEW
            -- ============================================================
            -- Vim has several "lists" for navigation. Use ] and [ to jump:
            --
            -- BUFFERS - Files you have opened (:ls to view)
            --   ]b/[b - Next/Previous buffer (like browser tabs)
            --   ]B/[B - Last/First buffer (jump to ends)
            --
            -- QUICKFIX - Global list shared across windows (:copen to view)
            --   What fills it: :grep, :make, :vimgrep, Telescope send to QF
            --   ]q/[q - Next/Previous file with results (:cnfile/:cpfile)
            --   ]Q/[Q - Last/First item in list (:clast/:cfirst)
            --   Use: Find all TODOs, compile errors, search results
            --
            -- LOCATION LIST - Per-window list (:lopen to view)
            --   What fills it: LSP references, :lvimgrep, location-specific searches
            --   ]l/[l - Next/Previous file with results (:lnfile/:lpfile)
            --   ]L/[L - Last/First item in list (:llast/:lfirst)
            --   Use: LSP find references, buffer-specific searches
            --
            -- TAGS - Jump stack for definitions (Ctrl-] creates entries)
            --   What fills it: ctags, LSP go-to-definition, :tag commands
            --   ]t/[t - Next/Previous tag match (:tnext/:tprev)
            --   ]T/[T - Last/First tag in stack (:tlast/:tfirst)
            --   Use: Navigate multiple definitions of same symbol
            --
            -- ARGUMENTS - Files passed to nvim at startup (:args to view)
            --   ]a/[a - Next/Previous file in argument list
            --   ]A/[A - Last/First file in argument list
            --
            -- KEY DIFFERENCES:
            -- • Quickfix = global (all windows share it)
            -- • Location = local (each window has its own)
            -- • lowercase (]q, ]l) = jump to next FILE (cnfile, lnfile)
            -- • uppercase (]Q, ]L) = jump to last ITEM (clast, llast)
            -- ============================================================
            
            -- Bracket Navigation: Argument List (files passed to nvim on startup)
            { category = 'Navigation: Args', key = ']a', desc = 'Next arg (:next)' },
            { category = 'Navigation: Args', key = '[a', desc = 'Previous arg (:prev)' },
            { category = 'Navigation: Args', key = ']A', desc = 'Last arg (:last)' },
            { category = 'Navigation: Args', key = '[A', desc = 'First arg (:first)' },
            
            -- Bracket Navigation: Buffer List (all opened files in session)
            { category = 'Navigation: Buffers', key = ']b', desc = 'Next buffer (:bnext - cycle to next open file)' },
            { category = 'Navigation: Buffers', key = '[b', desc = 'Previous buffer (:bprev - cycle to previous open file)' },
            { category = 'Navigation: Buffers', key = ']B', desc = 'Last buffer (:blast - jump to last open file)' },
            { category = 'Navigation: Buffers', key = '[B', desc = 'First buffer (:bfirst - jump to first open file)' },
            
            -- Bracket Navigation: Location List (window-local list for LSP, :lvimgrep)
            { category = 'Navigation: Location List', key = ']l', desc = 'Next location (:lnfile - jump to next file in location list)' },
            { category = 'Navigation: Location List', key = '[l', desc = 'Previous location (:lpfile - jump to previous file in location list)' },
            { category = 'Navigation: Location List', key = ']L', desc = 'Last location (:llast - jump to last item)' },
            { category = 'Navigation: Location List', key = '[L', desc = 'First location (:lfirst - jump to first item)' },
            
            -- Bracket Navigation: Quickfix List (global list for :grep, :make, :vimgrep)
            { category = 'Navigation: Quickfix', key = ']q', desc = 'Next quickfix (:cnfile - jump to next file in quickfix)' },
            { category = 'Navigation: Quickfix', key = '[q', desc = 'Previous quickfix (:cpfile - jump to previous file in quickfix)' },
            { category = 'Navigation: Quickfix', key = ']Q', desc = 'Last quickfix (:clast - jump to last item)' },
            { category = 'Navigation: Quickfix', key = '[Q', desc = 'First quickfix (:cfirst - jump to first item)' },
            
            -- Bracket Navigation: Tags (ctags stack for definition jumps)
            { category = 'Navigation: Tags', key = ']t', desc = 'Next tag (:tnext - next matching tag in stack)' },
            { category = 'Navigation: Tags', key = '[t', desc = 'Previous tag (:tprev - previous matching tag)' },
            { category = 'Navigation: Tags', key = ']T', desc = 'Last tag (:tlast - last tag in stack)' },
            { category = 'Navigation: Tags', key = '[T', desc = 'First tag (:tfirst - first tag in stack)' },
            
            -- Bracket Navigation: Git & Diagnostics
            { category = 'Navigation: Git', key = ']c', desc = 'Next git change (gitsigns)' },
            { category = 'Navigation: Git', key = '[c', desc = 'Previous git change (gitsigns)' },
            { category = 'Navigation: Git', key = ']h', desc = 'Next git hunk (gitsigns)' },
            { category = 'Navigation: Git', key = '[h', desc = 'Previous git hunk (gitsigns)' },
            { category = 'Navigation: Diagnostics', key = ']d', desc = 'Next diagnostic (LSP)' },
            { category = 'Navigation: Diagnostics', key = '[d', desc = 'Previous diagnostic (LSP)' },
            
            -- Bracket Navigation: Spelling
            { category = 'Navigation: Spelling', key = ']s', desc = 'Next misspelled word (spell)' },
            { category = 'Navigation: Spelling', key = '[s', desc = 'Previous misspelled word (spell)' },
            
            -- Git
            { category = 'Snacks: Git', key = '<Space>gb', desc = 'Git browse (open in web)' },
            { category = 'Snacks: Git', key = '<Space>gB', desc = 'Git blame line' },
            { category = 'Snacks: Git', key = '<Space>gH', desc = 'GitHub' },
            { category = 'Snacks: Git', key = '<Space>gI', desc = 'GitHub issues' },
            { category = 'Snacks: Git', key = '<Space>gP', desc = 'GitHub PRs' },
            
            -- Notifications
            { category = 'Snacks: Notify', key = '<Space>un', desc = 'Dismiss all notifications' },
            { category = 'Snacks: Notify', key = '<Space>uh', desc = 'Notification history' },
            
            -- Toggles
            { category = 'Snacks: Toggle', key = '<Space>td', desc = 'Toggle diagnostics' },
            { category = 'Snacks: Toggle', key = '<Space>tl', desc = 'Toggle line numbers' },
            { category = 'Snacks: Toggle', key = '<Space>ts', desc = 'Toggle smooth scroll' },
            { category = 'Snacks: Toggle', key = '<Space>tw', desc = 'Toggle word highlights' },
            { category = 'Snacks: Toggle', key = '<Space>ti', desc = 'Toggle indent guides' },

            -- ============================================================
            -- CODE ACTIONS
            -- ============================================================
            { category = 'Code', key = '<Space>.', desc = 'Code actions (VSCode-style)' },
            { category = 'Code', key = 'gra', desc = 'Code actions (LSP)' },
            { category = 'Code', key = '<Space>cR', desc = 'Rename file (LSP-aware, snacks)' },

            -- ============================================================
            -- MINI.AI (TEXT OBJECTS)
            -- ============================================================
            -- Enhanced text objects with next/last support
            { category = 'Text Objects', key = 'a/i + object', desc = "Around/inside: w(word) s(sentence) p(paragraph) []{}<>() \"'` t(tag)" },
            { category = 'Text Objects', key = 'an/in', desc = 'Around/inside next - an) goes to next ), cin changes inside next )' },
            { category = 'Text Objects', key = 'al/il', desc = 'Around/inside last - al" goes to previous ", vil selects inside last "' },
            
            -- Common text object operations (repeatable with .)
            { category = 'Text Objects', key = 'daw', desc = 'Delete around word (repeatable)' },
            { category = 'Text Objects', key = 'ciw', desc = 'Change inside word (repeatable)' },
            { category = 'Text Objects', key = 'yap', desc = 'Yank around paragraph (repeatable)' },
            { category = 'Text Objects', key = 'di"', desc = 'Delete inside quotes (repeatable)' },
            { category = 'Text Objects', key = 'da(', desc = 'Delete around parentheses (repeatable)' },
            { category = 'Text Objects', key = 'ci{', desc = 'Change inside braces (repeatable)' },
            { category = 'Text Objects', key = 'da[', desc = 'Delete around brackets (repeatable)' },
            { category = 'Text Objects', key = 'dit', desc = 'Delete inside HTML/XML tag (repeatable)' },
            { category = 'Text Objects', key = 'vit', desc = 'Visual inside tag - select content between tags' },
            { category = 'Text Objects', key = 'vis', desc = 'Visual inside sentence' },
            
            -- Function/call text objects (mini.ai)
            { category = 'Text Objects', key = 'daf', desc = 'Delete around function call - includes name + ()' },
            { category = 'Text Objects', key = 'cif', desc = 'Change inside function call - only arguments' },
            { category = 'Text Objects', key = 'daa', desc = 'Delete around argument - including commas' },
            { category = 'Text Objects', key = 'cia', desc = 'Change inside argument - current arg only' },

            -- ============================================================
            -- MINI.SURROUND (works with vim-repeat!)
            -- ============================================================
            -- Note: All surround operations are repeatable with . command
            
            -- Add surroundings (sa = surround add) [REPEATABLE]
            { category = 'Surround', key = 'saiw"', desc = 'Surround word with " - then press . to repeat on next word' },
            { category = 'Surround', key = 'sa2w)', desc = 'Surround 2 words with () - use . to repeat' },
            { category = 'Surround', key = 'sap}', desc = 'Surround paragraph with {} - use . to repeat' },
            { category = 'Surround', key = 'sa$]', desc = 'Surround to end of line with [] - use . to repeat' },
            { category = 'Surround', key = 'saW<q>', desc = 'Surround WORD with <q> tag - use . to repeat' },
            { category = 'Surround', key = 'saiw`', desc = 'Surround word with backticks (markdown code) - use . to repeat' },
            
            -- Delete surroundings (sd = surround delete) [REPEATABLE]
            { category = 'Surround', key = 'sd"', desc = 'Delete surrounding " - move to next and press . to repeat' },
            { category = 'Surround', key = 'sd)', desc = 'Delete surrounding () - use . to repeat on next' },
            { category = 'Surround', key = 'sd}', desc = 'Delete surrounding {} - use . to repeat' },
            { category = 'Surround', key = 'sdt', desc = 'Delete surrounding HTML/XML tag - use . to repeat' },
            
            -- Replace surroundings (sr = surround replace) [REPEATABLE]
            { category = 'Surround', key = 'sr"\'', desc = 'Replace " with \' - move to next " and press . to repeat' },
            { category = 'Surround', key = 'sr)]', desc = 'Replace () with [] - use . to repeat' },
            { category = 'Surround', key = 'sr}t<div>', desc = 'Replace {} with <div> tag - use . to repeat' },
            { category = 'Surround', key = 'srt<p>', desc = 'Replace current tag with <p> - use . to repeat' },
            
            -- Find surroundings (navigation)
            { category = 'Surround', key = 'sf"', desc = 'Find/jump to right (next) " surround' },
            { category = 'Surround', key = 'sF"', desc = 'Find/jump to left (previous) " surround' },
            { category = 'Surround', key = 'sf)', desc = 'Find/jump to right (next) ) surround' },
            { category = 'Surround', key = 'sF{', desc = 'Find/jump to left (previous) { surround' },
            
            -- Highlight surroundings (visual feedback)
            { category = 'Surround', key = 'sh', desc = 'Highlight nearest surroundings - shows what sd/sr would affect' },
            
            -- Visual mode surround (surround selection)
            { category = 'Surround', key = 'viwsa"', desc = 'Visual select word, then surround with " - use . after viw' },
            { category = 'Surround', key = 'vipsa)', desc = 'Visual select paragraph, then surround with ()' },
          }
end

return {
  -- Enhanced cheatsheet with custom data
  {
    'nvim-telescope/telescope.nvim',
    keys = {
      {
        '<leader>sc',
        function()
          -- Load cheatsheet data on-demand
          local cheatsheet = get_cheatsheet_data()
          -- Create a custom cheatsheet picker
          local pickers = require 'telescope.pickers'
          local finders = require 'telescope.finders'
          local conf = require('telescope.config').values
          local actions = require 'telescope.actions'
          local action_state = require 'telescope.actions.state'

          -- Create picker
          pickers
            .new({}, {
              prompt_title = ' Command Cheatsheet ',
              finder = finders.new_table {
                results = cheatsheet,
                entry_maker = function(entry)
                  return {
                    value = entry,
                    display = string.format('%-20s %-25s %s', entry.category, entry.key, entry.desc),
                    ordinal = entry.category .. ' ' .. entry.key .. ' ' .. entry.desc,
                  }
                end,
              },
              sorter = conf.generic_sorter {},
              attach_mappings = function(prompt_bufnr, map)
                actions.select_default:replace(function()
                  actions.close(prompt_bufnr)
                  local selection = action_state.get_selected_entry()
                  if selection then
                    vim.notify(
                      string.format('%s: %s\n%s', selection.value.category, selection.value.key, selection.value.desc),
                      vim.log.levels.INFO,
                      { title = 'Keymap' }
                    )
                  end
                end)
                return true
              end,
            })
            :find()
        end,
        desc = 'Command Cheatsheet (Reference)',
      },
      {
        '<leader>sC',
        function()
          -- Load cheatsheet data on-demand
          local cheatsheet = get_cheatsheet_data()
          
          -- Create category browser
          local pickers = require 'telescope.pickers'
          local finders = require 'telescope.finders'
          local conf = require('telescope.config').values
          local actions = require 'telescope.actions'
          local action_state = require 'telescope.actions.state'

          -- Extract unique categories from the shared cheatsheet
          local categories_set = {}
          for _, item in ipairs(cheatsheet) do
            categories_set[item.category] = true
          end
          
          local categories = {}
          for cat in pairs(categories_set) do
            table.insert(categories, cat)
          end
          table.sort(categories)

          -- Create picker for categories
          pickers
            .new({}, {
              prompt_title = 'Cheatsheet Categories',
              finder = finders.new_table {
                results = categories,
              },
              sorter = conf.generic_sorter {},
              attach_mappings = function(prompt_bufnr)
                actions.select_default:replace(function()
                  local selection = action_state.get_selected_entry()
                  actions.close(prompt_bufnr)
                  
                  -- Filter cheatsheet by selected category
                  local filtered = {}
                  for _, item in ipairs(cheatsheet) do
                    if item.category == selection[1] then
                      table.insert(filtered, item)
                    end
                  end
                  
                  -- Open main cheatsheet picker with filtered results
                  pickers
                    .new({}, {
                      prompt_title = 'Cheatsheet: ' .. selection[1],
                      finder = finders.new_table {
                        results = filtered,
                        entry_maker = function(entry)
                          return {
                            value = entry,
                            display = string.format('%-20s | %s', entry.key, entry.desc),
                            ordinal = entry.key .. ' ' .. entry.desc,
                          }
                        end,
                      },
                      sorter = conf.generic_sorter {},
                    })
                    :find()
                end)
                return true
              end,
            })
            :find()
        end,
        desc = 'Cheatsheet Categories (Browse)',
      },
      {
        '<leader>?',
        function()
          require('telescope.builtin').keymaps()
        end,
        desc = 'Search keymaps',
      },
    },
  },

  -- Which-key can also show a searchable list
  {
    'folke/which-key.nvim',
    keys = {
      {
        '<leader>sK',
        function()
          require('which-key').show { global = true }
        end,
        desc = 'All keymaps (which-key)',
      },
    },
  },
}
