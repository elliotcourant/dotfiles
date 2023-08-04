require("mason").setup {}
require("mason-lspconfig").setup {
  ensure_installed = {
    "ansiblels",
    "bashls",
    "clojure_lsp",
    "cmake",
    "gopls",
    "lua_ls",
    "marksman",
    "pylsp",
    "rust_analyzer",
    "tailwindcss",
    "terraformls",
    "tsserver",
  },
}
local util = require('lspconfig.util')

-- Setup nvim-cmp.
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local kind_icons = {
  Text          = "",
  Method        = "",
  Function      = "",
  Constructor   = "",
  Field         = "",
  Variable      = "",
  Class         = "",
  Interface     = "",
  Module        = "",
  Property      = "",
  Unit          = "",
  Value         = "",
  Enum          = "",
  Keyword       = "",
  Snippet       = "",
  Color         = "",
  File          = "",
  Reference     = "",
  Folder        = "",
  EnumMember    = "",
  Constant      = "",
  Struct        = "",
  Event         = "",
  Operator      = "",
  TypeParameter = "",
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
      vim_item.kind = " " .. kind_icons[vim_item.kind] .. " " .. vim_item.kind
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
      function(...) return cmp_buffer:compare_locality(...) end,
      cmp.config.compare.offset,
      cmp.config.compare.exact,
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
  require 'illuminate'.on_attach(client)
  ---- Enable completion triggered by <c-x><c-o>
  --vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

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

require('lspconfig')['gopls'].setup {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
  settings     = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      codelenses = {
        generate = true,
        tidy     = true,
      },
      semanticTokens = true,
    }
  },
  handlers = {
    -- ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    --   virtual_text = true,
    --   virtual_lines = false,
    -- }),
  }
}

if (is_installed('pylsp')) then
  require('lspconfig')['pylsp'].setup {
    capabilities = capabilities,
    on_attach    = on_attach,
    flags        = lsp_flags,
    handlers = {
      ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        virtual_lines = false,
      }),
    }
  }
end

require('lspconfig')['tsserver'].setup {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
  handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        silent = false,
    }),
    -- ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    --   -- Disable virtual_text
    --   virtual_text = false,
    --   virtual_lines = true,
    -- }),
  }
}

require('lspconfig')['clojure_lsp'].setup {
  capabilities = capabilities,
  on_attach    = function(client, bufnr)
    return on_attach(client, bufnr)
  end,
  flags        = lsp_flags,
  -- handlers = {
  --   ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  --     virtual_text = true,
  --     virtual_lines = false,
  --   }),
  -- }
}

require('lspconfig')['cmake'].setup {
  capabilities = capabilities,
  on_attach    = function(client, bufnr)
    return on_attach(client, bufnr)
  end,
  flags        = lsp_flags,
  -- handlers = {
  --   ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  --     virtual_text = true,
  --     virtual_lines = false,
  --   }),
  -- }
}

require('lspconfig')['marksman'].setup {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = true,
      virtual_lines = false,
    }),
  }
}

-- require('lspconfig')['grammarly'].setup {
--   capabilities = capabilities,
--   on_attach    = on_attach,
--   flags        = lsp_flags,
--   handlers = {
--     ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--       virtual_text = true,
--       virtual_lines = false,
--     }),
--   }
-- }

require('lspconfig')['tailwindcss'].setup {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
  handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        silent = true,
    }),
    ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = true,
      virtual_lines = false,
    }),
  }
}

require('lspconfig')['eslint'].setup {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
  handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        silent = true,
    }),
    -- ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    --   virtual_text = false,
    --   virtual_lines = true,
    -- }),
  },
  settings = {
    codeAction = {
      showDocumentation = {
        enable = false,
      },
    },
  },
}

-- if (is_installed('yaml-language-server')) then
--   require('lspconfig')['yamlls'].setup {
--     capabilities = capabilities,
--     on_attach    = on_attach,
--     flags        = lsp_flags,
--     settings     = {
--       schemas = {
--         ["https://json.schemastore.org/github-workflow.json"]                             = "/.github/workflows/*",
--         ["https://github.com/yannh/kubernetes-json-schema/blob/master/v1.22.10/all.json"] = "/*",
--       },
--     },
--   }
-- end

if (is_installed('rust-analyzer')) then
  require('lspconfig')['rust_analyzer'].setup {
    capabilities = capabilities,
    on_attach    = on_attach,
    flags        = lsp_flags,
    handlers = {
      ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        virtual_lines = true,
      }),
    }
  }
end

require('lspconfig')['sourcekit'].setup {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
}

require('lspconfig')['terraformls'].setup {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
}

require('lspconfig')['lua_ls'].setup({
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

require('lspconfig')['bashls'].setup {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
}

require('lspconfig')['ansiblels'].setup {
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
}

-- yarn global add diagnostic-languageserver
-- if (os.execute('which diagnostic-languageserver') == 0) then
--   require('lspconfig')['diagnosticls'].setup {
--     capabilities = capabilities,
--     on_attach    = on_attach,
--     flags        = lsp_flags,
--     handlers = {
--       ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
--         virtual_text = false,
--         virtual_lines = true,
--       }),
--     }
--   }
-- end

local clangd_capabilities = capabilities;
clangd_capabilities.offsetEncoding = "utf-8"
require('lspconfig')['clangd'].setup {
  capabilities = clangd_capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
}
