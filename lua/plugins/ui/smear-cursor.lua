-- ========================================================================
-- SMEAR CURSOR - Animated cursor trail
-- ========================================================================
-- Creates a smooth smear/trail effect behind the cursor when moving
-- Makes the cursor much more visible, especially when jumping between windows
-- ========================================================================

return {
  'sphamba/smear-cursor.nvim',
  event = 'VeryLazy',
  opts = {
    -- Smear cursor when switching buffers or windows.
    smear_between_buffers = true,
    -- Smear cursor when moving within line or to neighbor lines.
    smear_between_neighbor_lines = true,
    -- Only smear when moving at least this distance horizontally
    -- This reduces the side-to-side smear significantly
    min_horizontal_distance_smear = 5, -- characters (0 default)
    -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
    legacy_computing_symbols_support = false,
    -- Reduce the smear length for a more subtle effect
    stiffness = 0.8, -- How fast the head moves (0.6 default, higher = faster/shorter)
    trailing_stiffness = 0.6, -- How fast the tail moves (0.45 default, higher = shorter trail)
    distance_stop_animating = 0.5, -- Stop sooner (0.1 default, higher = shorter animation)
    -- Shorten maximum length
    max_length = 15, -- Maximum smear length (25 default, lower = shorter)
  },
}
