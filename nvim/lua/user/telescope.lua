-- I want to be able to switch to my previous buffer by hitting ; and Enter.
-- This sorts by recent usage for the buffer window and excludes the current
-- buffer to achieve this behavior.
require('telescope').setup {
  defaults = {
    dynamic_preview_title = true,
    layout_config = {
      vertical = { width = 0.75 }
    },
  },
  pickers = {
    buffers = {
      ignore_current_buffer = true,
      sort_lastused = true,
    },
  },
}
require('telescope').load_extension('vim_bookmarks')
