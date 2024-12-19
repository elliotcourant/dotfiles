-- I want to be able to switch to my previous buffer by hitting ; and Enter.
-- This sorts by recent usage for the buffer window and excludes the current
-- buffer to achieve this behavior.
--
local telescopeConfig = require("telescope.config")
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

require('telescope').setup {
  defaults = {
    dynamic_preview_title = true,
    layout_config = {
      vertical = { width = 0.75 }
    },
    -- `hidden = true` is not supported in text grep commands.
    vimgrep_arguments = vimgrep_arguments,
  },
  pickers = {
    buffers = {
      ignore_current_buffer = true,
      sort_lastused = true,
    },
    find_files = {
      find_command = {
        "rg", "--files", "--hidden",
        "--glob", "!**/.git/*",
        "--glob", "!**/node_modules/*",
        "--glob", "!**/.clj-kondo/*",
        "--glob", "!**/server/icons/sources/simple-icons/*",
      },
    }
  },
}
