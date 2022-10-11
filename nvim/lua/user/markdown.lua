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
    -- Doesn't work in lua yet? https://github.com/neovim/neovim/issues/14626
    vim.api.nvim_command('set colorcolumn=120')
  end
})
