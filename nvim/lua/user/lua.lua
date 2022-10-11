vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead", "BufEnter" }, {
  pattern = { "*.lua" },
  callback = function()
    vim.bo.expandtab  = true
    vim.bo.shiftwidth = 2
    vim.bo.tabstop    = 2
    vim.bo.textwidth  = 120
    vim.o.spell       = true
  end
})
