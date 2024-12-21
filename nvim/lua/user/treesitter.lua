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

local white   = '#f1f2f3';
local gray5   = '#b7bdc0';
local red     = '#ff5370';
local red1    = '#F07178';
local green   = '#c3e88d';
local yellow  = '#ffcb6b';
local purple  = '#c792ea';
local cyan    = '#89ddff';
local orannge = '#f78c6c';
local indigo  = '#BB80B3';

-- Fix clojure macros not highlighting properly. Like defn or when
vim.api.nvim_set_hl(0, "@lsp.type.macro.clojure", { fg = purple  })
vim.api.nvim_set_hl(0, "@lsp.type.event.clojure", { fg = white   })
vim.api.nvim_set_hl(0, "@lsp.type.type.clojure",  { fg = cyan    })
vim.api.nvim_set_hl(0, "@variable",               { fg = red     })
vim.api.nvim_set_hl(0, "@symbol",                 { fg = gray5   })
vim.api.nvim_set_hl(0, "@parameter",              { fg = orannge })
vim.api.nvim_set_hl(0, "@tag",                    { fg = red1    })
vim.api.nvim_set_hl(0, "@tag.attribute",          { fg = yellow  })
vim.api.nvim_set_hl(0, "@namespace",              { fg = yellow  })
vim.api.nvim_set_hl(0, "@type",                   { fg = green   })
vim.api.nvim_set_hl(0, "label",                   { fg = white   })

function InspectHighlight()
  local result = vim.treesitter.get_captures_at_cursor(0)
  print(vim.inspect(result))
end

require("treesitter-context").setup {
  enable         = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines      = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  trim_scope     = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  patterns       = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
    -- For all filetypes
    -- Note that setting an entry here replaces all other patterns for this entry.
    -- By setting the 'default' entry below, you can control which nodes you want to
    -- appear in the context window.
    default = {
      'class',
      'function',
      'method',
      -- 'for', -- These won't appear in the context
      -- 'while',
      -- 'if',
      -- 'switch',
      -- 'case',
    },
    -- Example for a specific filetype.
    -- If a pattern is missing, *open a PR* so everyone can benefit.
    --   rust  = {
    --       'impl_item',
    --   },
  },
  exact_patterns = {
    -- Example for a specific filetype with Lua patterns
    -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
    -- exactly match "impl_item" only)
    -- rust    = true,
  },

  -- [!] The options below are exposed but shouldn't require your attention,
  --     you can safely ignore them.

  zindex    = 20, -- The Z-index of the context window
  mode      = 'topline', -- Line used to calculate context. Choices: 'cursor', 'topline'
  separator = nil, -- Separator between context and content. Should be a single character string, like '-'.
}
