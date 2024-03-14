require 'nvim-treesitter.configs'.setup {
  indent = {
    enable = true
  },
  ensure_installed = {
    "bash",
    "clojure",
    "comment",
    "css",
    "dockerfile",
    "gitignore",
    "go",
    "gomod",
    "hcl",
    "html",
    "javascript",
    "json",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "python",
    "regex",
    "rust",
    "scss",
    "sql",
    "starlark",
    "toml",
    "tsx",
    "typescript",
    "vimdoc",
    "yaml",
  },
  ignore_install = { "help" },
  highlight = {
    -- disable = { "help" },
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
};

vim.cmd [[
" Color Palette
" This initial color is the background i believe.
" if g:material_theme_style == 'default'
"   let s:gray1 = '#263238'
" elseif g:material_theme_style == 'palenight'
"   let s:gray1 = '#292D3E'
" elseif g:material_theme_style == 'dark'
"   let s:gray1 = '#212121'
" endif
" 
" let s:gray2 = g:material_theme_style == 'dark' ? '#292929' : '#2c3a41'
" let s:gray3 = g:material_theme_style == 'dark' ? '#474646' : '#425762'
" let s:gray4 = g:material_theme_style == 'dark' ? '#6a6c6c' : '#658494'
" let s:gray5 = g:material_theme_style == 'dark' ? '#f1f2f3' : '#aebbc5'
" " let s:gray5 = g:material_theme_style == 'dark' ? '#b7bdc0' : '#aebbc5'
" let s:red = '#ff5370'
" let s:green = '#c3e88d'
" let s:yellow = '#ffcb6b'
" let s:blue = '#82aaff'
" let s:purple = '#c792ea'
" let s:cyan = '#89ddff'
" let s:orange = '#f78c6c'
" let s:indigo = '#BB80B3'
]]

local white = '#f1f2f3';
local gray5   = '#b7bdc0';
local red     = '#ff5370';
local red1    = '#F07178';
local green   = '#c3e88d';
local yellow  = '#ffcb6b';
local purple = '#c792ea';
local cyan    = '#89ddff';
local orannge = '#f78c6c';

-- Fix clojure macros not highlighting properly. Like defn or when
vim.api.nvim_set_hl(0, "@lsp.type.macro.clojure", { fg = purple  })
vim.api.nvim_set_hl(0, "@lsp.type.event.clojure", { fg = white   })
vim.api.nvim_set_hl(0, "@lsp.type.type.clojure",  { fg = cyan    })
vim.api.nvim_set_hl(0, "@variable",               { fg = red     })
vim.api.nvim_set_hl(0, "@symbol",                 { fg = gray5   })
vim.api.nvim_set_hl(0, "@parameter",              { fg = orannge })
vim.api.nvim_set_hl(0, "@tag",                    { fg = red1    })
vim.api.nvim_set_hl(0, "@tag.attribute",          { fg = yellow  })
vim.api.nvim_set_hl(0, "@namespace",              { fg = yellow  })
vim.api.nvim_set_hl(0, "@type",                   { fg = green   })

function InspectHighlight()
  local result = vim.treesitter.get_captures_at_cursor(0)
  print(vim.inspect(result))
end
