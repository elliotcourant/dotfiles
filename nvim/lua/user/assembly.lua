vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead", "BufEnter" }, {
  pattern = { "*.s" },
  callback = function()
    vim.bo.expandtab  = false
    vim.bo.shiftwidth = 2
    vim.bo.tabstop    = 2
    vim.o.spell       = false
    vim.o.colorcolumn = '80'
    vim.diagnostic.enable(false, { bufnr = 0 })
  end
})
