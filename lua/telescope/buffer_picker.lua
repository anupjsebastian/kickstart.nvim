-- ============================================================================
-- ENHANCED TELESCOPE BUFFER PICKER
-- ============================================================================
-- Reusable buffer picker with visual indicators
-- Features:
--   • Modified indicator (●)
--   • Diagnostic indicators (errors/warnings)
--   • File type icons
--   • Special buffer highlighting (terminals, quickfix)
--   • Filters out [No Name] buffers automatically
-- ============================================================================

local M = {}

-- Create enhanced buffer picker
function M.pick_buffer()
    local entry_display = require('telescope.pickers.entry_display')

    -- Custom entry maker with indicators
    local function buffer_entry_maker(opts)
        opts = opts or {}

        local displayer = entry_display.create {
            separator = ' ',
            items = {
                { width = 2 },        -- Modified indicator
                { width = 2 },        -- Diagnostic indicator
                { width = 3 },        -- Icon
                { remaining = true }, -- Filename
            },
        }

        local make_display = function(entry)
            local bufnr = entry.bufnr
            local display_name = entry.display_name

            -- Get buffer state
            local is_modified = vim.api.nvim_buf_get_option(bufnr, 'modified')
            local is_readonly = vim.api.nvim_buf_get_option(bufnr, 'readonly')
            local buftype = vim.api.nvim_buf_get_option(bufnr, 'buftype')
            local is_special = buftype ~= '' -- terminal, quickfix, help, etc.

            -- Get diagnostic counts for this buffer
            local diagnostics = vim.diagnostic.get(bufnr)
            local error_count = 0
            local warn_count = 0
            for _, d in ipairs(diagnostics) do
                if d.severity == vim.diagnostic.severity.ERROR then
                    error_count = error_count + 1
                elseif d.severity == vim.diagnostic.severity.WARN then
                    warn_count = warn_count + 1
                end
            end

            -- Build separate indicators for alignment
            local modified_indicator = is_modified and { '●', 'DiagnosticInfo' } or { ' ', 'Normal' }

            local diag_indicator
            if error_count > 0 then
                diag_indicator = { '󰅚', 'DiagnosticError' }
            elseif warn_count > 0 then
                diag_indicator = { '󰀪', 'DiagnosticWarn' }
            else
                diag_indicator = { ' ', 'Normal' }
            end

            -- Get file icon and determine highlight based on buffer type
            local icon, icon_hl
            local name_hl = 'Normal'

            if is_special or is_readonly then
                -- Special/readonly buffers (terminals, quickfix, etc) get yellow
                icon = '󰈙' -- Log/document icon
                icon_hl = 'DiagnosticWarn'
                name_hl = 'DiagnosticWarn'
            else
                local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
                if has_devicons then
                    icon, icon_hl = devicons.get_icon(display_name, string.match(display_name, '%a+$'),
                        { default = true })
                end
                icon = icon or ''
            end

            return displayer {
                modified_indicator,
                diag_indicator,
                { icon,         icon_hl },
                { display_name, name_hl },
            }
        end

        return function(entry)
            local bufnr = entry.bufnr
            local bufname = vim.api.nvim_buf_get_name(bufnr)

            -- Filter out buffers with no name
            if bufname == '' then
                return nil
            end

            -- Get display name (just the filename)
            local display_name = vim.fn.fnamemodify(bufname, ':t')

            return {
                bufnr = bufnr,
                filename = bufname,
                display_name = display_name,
                ordinal = display_name,
                display = make_display,
                lnum = entry.lnum,
            }
        end
    end

    -- Open telescope buffers with custom entry maker
    require('telescope.builtin').buffers {
        sort_mru = true,
        sort_lastused = true,
        ignore_current_buffer = false,
        show_all_buffers = true,
        previewer = false,
        entry_maker = buffer_entry_maker(),
    }
end

return M
