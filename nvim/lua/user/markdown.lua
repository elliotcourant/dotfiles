vim.g.mkdp_theme = 'light'
vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
  pattern = { "*.md" },
  callback = function()
    vim.bo.syntax      = 'markdown'
    vim.bo.textwidth   = 120
    vim.bo.colorcolumn = 120
  end
})

