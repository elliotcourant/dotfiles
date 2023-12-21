-- require 'tabline'.setup {
--   -- Defaults configuration options
--   enable = true,
--   options = {
--     -- If lualine is installed tabline will use separators configured in lualine by default.
--     -- These options can be used to override those settings.
--     section_separators     = { '', '' },
--     component_separators   = { '', '' },
--     max_bufferline_percent = nil, -- set to nil by default, and it uses vim.o.columns * 2/3
--     show_tabs_always       = true, -- this shows tabs only when there are more than one tab or if the first tab is named
--     show_devicons          = true, -- this shows devicons in buffer section
--     show_bufnr             = false, -- this appends [bufnr] to buffer section,
--     show_filename_only     = false, -- shows base filename only instead of relative path in filename
--     modified_icon          = "+ ", -- change the default modified icon
--     modified_italic        = false, -- set to true by default; this determines whether the filename turns italic if modified
--     show_tabs_only         = false, -- this shows only tabs instead of tabs + buffers
--   }
-- }

-- let s:gray2 = g:material_theme_style == 'dark' ? '#292929' : '#2c3a41'
-- let s:gray3 = g:material_theme_style == 'dark' ? '#474646' : '#425762'
-- let s:gray4 = g:material_theme_style == 'dark' ? '#6a6c6c' : '#658494'
-- let s:gray5 = g:material_theme_style == 'dark' ? '#f1f2f3' : '#aebbc5'
-- let s:gray5 = g:material_theme_style == 'dark' ? '#b7bdc0' : '#aebbc5'

local autoTheme = require('lualine.themes.auto');
autoTheme.inactive.a.bg = '#292929'
autoTheme.inactive.c.bg = '#292929'
autoTheme.normal.c.bg = '#292929'

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = autoTheme,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {
      'mode',
    },
    lualine_b = {
      'branch',
      'diff',
      'diagnostics',
    },
    lualine_c = {
      {
        'filename',
        path = 1,
      }
    },
    lualine_x = {
      -- 'encoding',
      'fileformat',
      'filetype',
    },
    lualine_y = {
      'progress',
    },
    lualine_z = {
      'location',
    }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'filename',
        path = 1,
      }
    },
    lualine_x = {
      'location',
    },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {
      {
        'buffers',
        symbols = {
          modified = ' ●', -- Text to show when the buffer is modified
          alternate_file = '# ', -- Text to show to identify the alternate file
          directory = '', -- Text to show when the buffer is a directory
        },
      },
    },
  },
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
vim.cmd [[
  set guioptions-=e " Use showtabline in gui vim
  set sessionoptions+=tabpages,globals " store tabpages and globals in session
]]
