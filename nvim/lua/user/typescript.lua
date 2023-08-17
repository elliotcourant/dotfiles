vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead", "BufEnter" }, {
  pattern = { "*.ts", "*.tsx" },
  callback = function()
    vim.bo.expandtab  = true
    vim.bo.shiftwidth = 2
    vim.bo.tabstop    = 2
    vim.bo.textwidth  = 120
    vim.o.spell       = false
    vim.o.colorcolumn = '120'
  end
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.ts", "*.tsx" },
  callback = function ()
    vim.lsp.buf.format()
  end
})
