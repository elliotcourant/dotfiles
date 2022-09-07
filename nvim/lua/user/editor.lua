vim.g.nocompatible = true
vim.o.number       = true
vim.g.bs           = 2 -- Make backspace work in a sane way.
vim.o.laststatus   = 2
vim.o.autoread     = true -- Update buffers when the file is modified externally.
vim.o.showcmd      = true  -- I want to the command keys.
vim.o.expandtab    = true
vim.o.smartindent  = true
vim.o.tabstop      = 2
vim.o.shiftwidth   = 2
vim.o.showtabline  = 2 -- Is modified by the dashboard file on startup.
vim.o.wrap         = false
vim.o.showmode     = 0
vim.o.colorcolumn  = 120
vim.o.hidden       = true


vim.cmd [[
  filetype off
  filetype plugin indent on

  set clipboard+=unnamedplus
  set ignorecase  " searches are case insensitive...
  set smartcase   " ... unless they contain at least one capital letter
  set ttyfast
  set go+=b.
  set mouse=a
  set rtp+=/.fzf
  set completeopt=preview,menu,noinsert,menuone

  set indentexpr=nvim_treesitter#indent()
  set signcolumn=auto:2
  set foldcolumn=2

  let g:bookmark_no_default_key_mappings = 1
]]

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
})
