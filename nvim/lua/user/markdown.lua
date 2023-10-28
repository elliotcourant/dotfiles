vim.g.mkdp_theme = 'light'
vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead", "BufEnter" }, {
  pattern = { "*.md" },
  callback = function()
    vim.bo.expandtab  = true
    vim.bo.shiftwidth = 2
    vim.bo.tabstop    = 2
    vim.bo.syntax     = 'markdown'
    vim.bo.textwidth  = 120
    vim.o.spell       = false
    vim.o.colorcolumn = '120'
  end
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead", "BufEnter" }, {
  pattern = { "*.mdx" },
  callback = function()
    vim.bo.expandtab  = true
    vim.bo.shiftwidth = 2
    vim.bo.tabstop    = 2
    vim.bo.filetype   = 'markdown.mdx'
    vim.bo.syntax     = 'markdown'
    vim.bo.textwidth  = 120
    vim.o.spell       = false
    vim.o.colorcolumn = '120'
  end
})
