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
