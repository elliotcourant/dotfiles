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
    "regex",
    "rust",
    "scss",
    "sql",
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
