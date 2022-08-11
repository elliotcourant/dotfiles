--vim.wo.colorcolumn = '120'
--vim.wo.number = true
--
---- Indentation
--vim.g.expandtab = true
--vim.g.tabstop = 2
--vim.g.shiftwidth = 2
--vim.g.autoindent = true
--vim.g.smartindent = true
--
--vim.g.bs = 2
--
--vim.g.clipboard = 'unnamedplus'
--
---- Update the buffer if the file is modified externally.
--vim.g.autoread = true
---- Show the keys being entered.
--vim.g.showcmd = true
---- Searches should be case insensitive.
--vim.g.ignorecase = true
---- Unless those searches contain a capital letter.
--vim.g.smartcase = true
--
--vim.g.hidden = true
--vim.g.ttyfast = true
--vim.g.noshowmode = true
--vim.g.nowrap = true
--vim.g.mouse = 'a'

vim.o.expandtab = true
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2

vim.cmd [[
  set nocompatible
  filetype off
  filetype plugin indent on

  set number
  set bs=2
  set laststatus=2
  set clipboard+=unnamedplus
  set autoread    " Update buffer when file is modified externally.
  set showcmd     " I want to see the command keys
  set ignorecase  " searches are case insensitive...
  set smartcase   " ... unless they contain at least one capital letter
  set hidden
  set ttyfast
  set noshowmode
  set nowrap
  set go+=b.
  set mouse=a
  set rtp+=/.fzf
  set completeopt=preview,menu,noinsert,menuone
  set colorcolumn=120

  set indentexpr=nvim_treesitter#indent()
  set signcolumn=auto:2
]]

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
})
