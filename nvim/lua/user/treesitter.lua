require 'nvim-treesitter.configs'.setup {
  indent = {
    enable = true
  },
  ensure_installed = {
    "bash",
    "clojure",
    "comment",
    "css",
    "dockerfile",
    "gitignore",
    "go",
    "gomod",
    "hcl",
    "help",
    "html",
    "javascript",
    "json",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "python",
    "regex",
    "rust",
    "scss",
    "sql",
    "starlark",
    "toml",
    "tsx",
    "typescript",
    "yaml",
  },
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
};

vim.api.nvim_set_hl(0, "@variable",      { fg = "#EEFFFF" })
vim.api.nvim_set_hl(0, "@parameter",     { fg = "#F78C6C" })
vim.api.nvim_set_hl(0, "@tag",           { fg = "#F07178" })
vim.api.nvim_set_hl(0, "@tag.attribute", { fg = "#FFCB6B" })
vim.api.nvim_set_hl(0, "@namespace",     { fg = "#FFCB6B" })
vim.api.nvim_set_hl(0, "@type",          { fg = "#C3E88D" })

function InspectHighlight()
  local result = vim.treesitter.get_captures_at_cursor(0)
  print(vim.inspect(result))
end
