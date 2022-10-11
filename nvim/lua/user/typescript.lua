vim.cmd [[
  au BufNewFile,BufFilePre,BufRead *.ts set autoindent expandtab tabstop=2 shiftwidth=2
]]

vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead", "BufEnter" }, {
  pattern = { "*.ts" },
  callback = function()
    vim.bo.expandtab  = true
    vim.bo.shiftwidth = 2
    vim.bo.tabstop    = 2
    vim.bo.textwidth  = 120
    vim.o.spell       = true
    -- Doesn't work in lua yet? https://github.com/neovim/neovim/issues/14626
    vim.api.nvim_command('set colorcolumn=120')
  end
})
