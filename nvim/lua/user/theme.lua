local set = vim.opt

-- Stuff for powerline/airline
vim.g["airline_powerline_fonts"]            = 1
vim.g["airline#extensions#tabline#enabled"] = 1
vim.g["airline#extensions#tagbar#enabled"]  = 0
vim.g["airline_theme"]                      = "material"
vim.g["material_theme_style"]               = "dark"

set.background = 'dark'
vim.cmd [[
  colorscheme material

  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif

  if (has("termguicolors"))
    set termguicolors
  endif

  " gray
  highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
  " blue
  highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
  highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
  " light blue
  highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
  highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
  highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
  " pink
  highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
  highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
  " front
  highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
  highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
  highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4

  highlight! Normal guibg=NONE
  highlight! NonText guibg=NONE
]]

-- vim.api.nvim_set_hl(0, 'Normal', {guibg=none})
-- vim.api.nvim_set_hl(0, 'NonText', {guibg=none})
