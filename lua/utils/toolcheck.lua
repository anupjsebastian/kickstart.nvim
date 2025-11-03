-- ========================================================================
-- TOOL AVAILABILITY CHECKER
-- ========================================================================
-- Reusable functions to check if development tools are installed
-- Provides consistent error messages across all language configurations
-- Prioritizes Homebrew for macOS installations
-- ========================================================================

local M = {}

-- Check if bun is installed (for web development)
function M.check_bun()
  if vim.fn.executable('bun') == 0 then
    vim.notify(
      '❌ bun not found!\n\n' ..
      'Install with Homebrew (recommended):\n' ..
      '  brew install bun\n\n' ..
      'Or from official site: https://bun.sh\n' ..
      '  curl -fsSL https://bun.sh/install | bash\n\n' ..
      'Bun is a fast JavaScript runtime, package manager, and bundler.',
      vim.log.levels.ERROR
    )
    return false
  end
  return true
end

-- Check if uv is installed (for Python)
function M.check_uv()
  if vim.fn.executable('uv') == 0 then
    vim.notify(
      '❌ uv not found!\n\n' ..
      'Install with Homebrew (recommended):\n' ..
      '  brew install uv\n\n' ..
      'Or from official site: https://docs.astral.sh/uv/\n' ..
      '  curl -LsSf https://astral.sh/uv/install.sh | sh\n\n' ..
      'uv is a fast Python package and project manager.',
      vim.log.levels.ERROR
    )
    return false
  end
  return true
end

-- Check if live-server is installed (for HTML/CSS)
function M.check_live_server()
  if vim.fn.executable('live-server') == 0 then
    vim.notify(
      '❌ live-server not found!\n\n' ..
      'Install globally with bun (after installing bun):\n' ..
      '  bun install -g live-server\n\n' ..
      'Or with npm:\n' ..
      '  npm install -g live-server\n\n' ..
      'live-server provides auto-reload when you save HTML/CSS/JS files.',
      vim.log.levels.ERROR
    )
    return false
  end
  return true
end

-- Check if cargo is installed (for Rust)
function M.check_cargo()
  if vim.fn.executable('cargo') == 0 then
    vim.notify(
      '❌ cargo not found!\n\n' ..
      'Install with Homebrew (recommended):\n' ..
      '  brew install rust\n\n' ..
      'Or from official site (rustup): https://rustup.rs/\n' ..
      '  curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh\n\n' ..
      'cargo is the Rust package manager and build tool.',
      vim.log.levels.ERROR
    )
    return false
  end
  return true
end

return M
