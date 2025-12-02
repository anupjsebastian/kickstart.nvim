-- ========================================================================
-- STRUDEL - Live coding music with Strudel from Neovim
-- ========================================================================
-- NOTE: Keymaps are loaded in strudel-keymaps.lua
-- ========================================================================

return {
  {
    "gruvw/strudel.nvim",
    ft = { "javascript" },
    build = "PUPPETEER_SKIP_DOWNLOAD=1 npm ci",
    init = function()
      -- Set up filetype detection for .str files as javascript
      vim.filetype.add({
        extension = {
          str = "javascript",
        },
      })
      
      -- Disable virtual text for .str files
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*.str",
        callback = function()
          vim.diagnostic.config({
            virtual_text = false,
          }, vim.api.nvim_get_current_buf())
        end,
      })
    end,
    config = function()
      -- Detect OS and set appropriate browser path
      local browser_path = nil
      if vim.fn.has("mac") == 1 then
        browser_path = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
      elseif vim.fn.has("unix") == 1 then
        -- NixOS or Linux
        browser_path = "/run/current-system/sw/bin/google-chrome-stable"
      end

      require("strudel").setup({
        browser_exec_path = browser_path,
        ui = {
          maximise_menu_panel = false,
        },
        start_on_launch = true,
        sync_cursor = true,
        report_eval_errors = true,
      })
    end,
  },
}
