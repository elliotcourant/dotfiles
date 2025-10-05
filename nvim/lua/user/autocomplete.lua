require("mason").setup {}
require("mason-lspconfig").setup {
  automatic_enable = false,
  ensure_installed = {
    "ansiblels",
    -- "asm_lsp",
    "bashls",
    "clangd",
    "clojure_lsp",
    "cmake",
    "cssls",
    "eslint",
    "gopls",
    "lua_ls",
    "marksman",
    "mdx_analyzer",
    "pylsp",
    "rust_analyzer",
    "tailwindcss",
    "terraformls",
    "ts_ls",
  },
}

-- Setup nvim-cmp.
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local kind_icons = {
  Class         = " ",
  Color         = " ",
  Constant      = " ",
  Constructor   = " ",
  Enum          = "了",
  EnumMember    = " ",
  Event         = " ",
  Field         = " ",
  File          = " ",
  Folder        = " ",
  Function      = " ",
  Interface     = "ﰮ ",
  Keyword       = " ",
  Method        = "ƒ ",
  Module        = " ",
  Operator      = " ",
  Property      = " ",
  Reference     = " ",
  Snippet       = "﬌ ",
  Struct        = " ",
  Text          = " ",
  TypeParameter = " ",
  Unit          = " ",
  Value         = " ",
  Variable      = " ",
}

local luasnip = require('luasnip')
local cmp_buffer = require('cmp_buffer')
cmp.setup({
  completion = {
    completeopt = 'menu,menuone,noinsert,longest',
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion    = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>']   = cmp.mapping.scroll_docs(-4),
    ['<C-f>']   = cmp.mapping.scroll_docs(4),
    ['<C-Tab>'] = cmp.mapping.complete(),
    ['<C-e>']   = cmp.mapping.abort(),
    ['<CR>']    = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    -- ["<Tab>"]   = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     cmp.select_next_item()
    --   elseif luasnip.expand_or_jumpable() then
    --     luasnip.expand_or_jump()
    --   else
    --     fallback()
    --   end
    -- end, { "i", "s" }),
    -- ["<S-Tab>"] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     cmp.select_prev_item()
    --   elseif luasnip.jumpable(-1) then
    --     luasnip.jump(-1)
    --   else
    --     fallback()
    --   end
    -- end, { "i", "s" }),
    ['<Tab>']   = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      if vim_item.kind ~= nil then
        vim_item.kind = " " .. kind_icons[vim_item.kind] .. " " .. vim_item.kind
      end
      vim_item.menu = ({
        nvim_lsp = "",
        nvim_lua = "",
        luasnip  = "",
        buffer   = "",
        path     = "",
        emoji    = "",
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    --{ name = 'vsnip' }, -- For vsnip users.
    { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
    { name = 'spell' },
  }, {
    { name = 'buffer' },
  }),
  sorting = {
    comparators = {
      -- This is some trickery to make the buffer completion sort by the proximity of the compeltion item to the cursor
      -- in the buffer. So if an item is closer to your cursor, its more likely to be the recommended completion item...
      -- I think...
      cmp.config.compare.exact,
      function(...) return cmp_buffer:compare_locality(...) end,
      cmp.config.compare.offset,
      cmp.config.compare.score,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    }
  }
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- [[ other on_attach code ]]
  -- require 'illuminate'.on_attach(client)

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  --vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<Leader>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<Leader>r', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('v', '<Leader>r', vim.lsp.buf.rename, bufopts)
  -- vim.keymap.set('n', '<A-CR>', vim.lsp.buf.code_action, loudBufopts)
  vim.keymap.set('n', '<F2>', vim.lsp.buf.format, bufopts)
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = 'rounded',
        source = 'always',
        prefix = ' ',
        scope = 'cursor',
      }
      vim.diagnostic.open_float(nil, opts)
    end
  })
end

local is_installed = function(name)
  return os.execute(string.format('which %s > /dev/null 2>&1', name)) == 0
end


local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

-- require('lspconfig')['asm_lsp'].setup {
--   capabilities = capabilities,
--   on_attach    = on_attach,
--   flags        = lsp_flags,
--   settings     = { },
--   handlers     = { }
-- }

vim.lsp.enable('gopls')
vim.lsp.config('gopls', {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
  settings     = {
    gopls = {
      buildFlags = {
        "-tags=development,testing",
      },
      -- directoryFilters = {
      --   "-**/node_modules",
      -- },
      analyses = {
        unusedparams = true,
        ST1003 = false,
      },
      staticcheck = true,
      codelenses = {
        generate = true,
        tidy     = true,
      },
      semanticTokens = true,
    }
  },
})

if (is_installed('pylsp')) then
  vim.lsp.enable('pylsp')
  vim.lsp.config('pylsp', {
    capabilities = capabilities,
    on_attach    = on_attach,
    flags        = lsp_flags,
  })
end

vim.lsp.enable('ts_ls')
vim.lsp.config('ts_ls', {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
  init_options = {
    preferences = {
      importModuleSpecifierPreference = "non-relative"
    }
  },
  handlers = {
    ["textDocument/hover"] = vim.lsp.buf.hover({
        silent = false,
    }),
  }
})

vim.lsp.enable('clojure_lsp')
vim.lsp.config('clojure_lsp', {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
})

vim.lsp.enable('cmake')
vim.lsp.config('cmake', {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
})

local cssCapabilities = capabilities
cssCapabilities.textDocument.completion.completionItem.snippetSuppport = true
vim.lsp.enable('cssls')
vim.lsp.config('cssls', {
  capabilities = cssCapabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
})

vim.lsp.enable('marksman')
vim.lsp.config('marksman', {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
})

-- Make sure that we load typescript from the actual project directory.
local util = require 'lspconfig.util'
local function get_typescript_server_path(root_dir)
  local project_root = vim.fs.find('node_modules', { path = root_dir, upward = true })[1]
  return project_root and (util.path.join(project_root, 'typescript', 'lib')) or ''
end

vim.lsp.enable('mdx_analyzer')
vim.lsp.config('mdx_analyzer', {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
  single_file_suppport = true,
  filetypes    = {
    "markdown.mdx",
  },
  init_options = {
    typescript = {
      enabled = true,
    },
  },
  on_new_config = function(new_config, new_root_dir)
    if vim.tbl_get(new_config.init_options, 'typescript') and not new_config.init_options.typescript.tsdk then
      new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
    end
  end,
})

vim.lsp.enable('tailwindcss')
vim.lsp.config('tailwindcss', {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
  filetypes    = {
    "aspnetcorerazor",
    "astro",
    "astro-markdown",
    "blade",
    "clojure",
    "django-html",
    "htmldjango",
    "edge",
    "eelixir",
    "elixir",
    "ejs",
    "erb",
    "eruby",
    "gohtml",
    "gohtmltmpl",
    "haml",
    "handlebars",
    "hbs",
    "html",
    "html-eex",
    "heex",
    "jade",
    "leaf",
    "liquid",
    "markdown",
    "markdown.mdx",
    "mdx",
    "mustache",
    "njk",
    "nunjucks",
    "php",
    "razor",
    "slim",
    "twig",
    "css",
    "less",
    "postcss",
    "sass",
    "scss",
    "stylus",
    "sugarss",
    "javascript",
    "javascriptreact",
    "reason",
    "rescript",
    "typescript",
    "typescriptreact",
    "vue",
    "svelte",
  },
  handlers = {
    ["textDocument/hover"] = vim.lsp.buf.hover({
        silent = true,
    }),
  },
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
          { "twMerge\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "mergeTailwind\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
        },
      },
    },
  },
})

vim.lsp.enable('eslint')
vim.lsp.config('eslint', {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
  handlers = {
    ["textDocument/hover"] = vim.lsp.buf.hover({
        silent = true,
    }),
  },
  settings = {
    codeAction = {
      showDocumentation = {
        enable = false,
      },
    },
    eslint = {
      settings = {
        experimental = {
          -- allows to use flat config format
          useFlatConfig = true,
        },
      }
    },
  },
})

if (is_installed('rust-analyzer')) then
  vim.lsp.enable('rust_analyzer')
  vim.lsp.config('rust_analyzer', {
    capabilities = capabilities,
    on_attach    = on_attach,
    flags        = lsp_flags,
  })
end

vim.lsp.enable('terraformls')
vim.lsp.config('terraformls', {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
})

vim.lsp.enable('lua_ls')
vim.lsp.config('lua_ls', {
  on_attach    = on_attach,
  capabilities = capabilities,
  flags        = lsp_flags,
  settings     = {
    Lua = {
      diagnostics = {
        enable  = true,
        globals = {
          'vim',
          'packer_plugins',
        },
      },
      runtime   = {
        version = 'LuaJIT',
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim')] = true,
        },
        -- library = vim.api.nvim_get_runtime_file("", true),
        -- library = vim.list_extend({ [vim.fn.expand('$VIMRUNTIME/lua')] = true }, {}),
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
})

vim.lsp.enable('bashls')
vim.lsp.config('bashls', {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
})

vim.lsp.enable('ansiblels')
vim.lsp.config('ansiblels', {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
  settings     = {
    ansible = {
      ansible = {
        path = "ansible"
      },
      executionEnvironment = {
        enabled = false
      },
      python = {
        interpreterPath = "python3"
      },
      validation = {
        enabled = true,
        lint = {
          enabled = true,
          path = "ansible-lint"
        }
      }
    }
  }
})

local clangd_capabilities = capabilities;
clangd_capabilities.offsetEncoding = "utf-8"
vim.lsp.enable('clangd')
vim.lsp.config('clangd', {
  capabilities = clangd_capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
})
