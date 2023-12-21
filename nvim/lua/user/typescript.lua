vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead", "BufEnter" }, {
  pattern = {
    "*.cjs",
    "*.js",
    "*.jsx",
    "*.mjs",
    "*.ts",
    "*.tsx",
  },
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
    vim.lsp.buf.format({
      -- Don't use tsserver _AND_ eslint for formatting. Preferrably just use eslint.
      -- Without this it would call format from both language servers.
      filter = function(client) return client.name ~= "tsserver" end
    })
  end
})
