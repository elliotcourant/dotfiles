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
    "vimdoc",
    "yaml",
  },
  ignore_install = { "help" },
  highlight = {
    -- disable = { "help" },
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
};

-- Fix clojure macros not highlighting properly. Like defn or when
vim.api.nvim_set_hl(0, "@lsp.type.macro.clojure", { link = "Statement" })
vim.api.nvim_set_hl(0, "@variable",               { fg   = "#FF5370"   })
vim.api.nvim_set_hl(0, "@symbol",                 { fg   = "#b7bdc0"   })
vim.api.nvim_set_hl(0, "@parameter",              { fg   = "#F78C6C"   })
vim.api.nvim_set_hl(0, "@tag",                    { fg   = "#F07178"   })
vim.api.nvim_set_hl(0, "@tag.attribute",          { fg   = "#FFCB6B"   })
vim.api.nvim_set_hl(0, "@namespace",              { fg   = "#FFCB6B"   })
vim.api.nvim_set_hl(0, "@type",                   { fg   = "#C3E88D"   })

function InspectHighlight()
  local result = vim.treesitter.get_captures_at_cursor(0)
  print(vim.inspect(result))
end
