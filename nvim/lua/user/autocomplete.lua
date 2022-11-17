require("nvim-lsp-installer").setup {}

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
end


local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

require('lspconfig')['gopls'].setup {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
}

require('lspconfig')['tsserver'].setup {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
}

require('lspconfig')['clojure_lsp'].setup {
  capabilities = capabilities,
  on_attach    = function(client, bufnr)
    return on_attach(client, bufnr)
  end,
  flags        = lsp_flags,
}

require('lspconfig')['marksman'].setup {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
}

require('lspconfig')['tailwindcss'].setup {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
}

require('lspconfig')['yamlls'].setup {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
  settings     = {
    schemas = {
      ["https://json.schemastore.org/github-workflow.json"]                             = "/.github/workflows/*",
      ["https://github.com/yannh/kubernetes-json-schema/blob/master/v1.22.10/all.json"] = "/*",
    },
  },
}

local clangd_capabilities = capabilities;
clangd_capabilities.offsetEncoding = "utf-8"
require('lspconfig')['clangd'].setup {
  capabilities = clangd_capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
}

require('lspconfig')['rust_analyzer'].setup {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
}

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

require('lspconfig')['sumneko_lua'].setup({
  on_attach    = on_attach,
  capabilities = capabilities,
  flags        = lsp_flags,
  settings     = {
    Lua = {
      diagnostics = {
        enable  = true,
        globals = { 'vim', 'packer_plugins' },
      },
      runtime     = { version = 'LuaJIT' },
      workspace   = {
        library = vim.list_extend({ [vim.fn.expand('$VIMRUNTIME/lua')] = true }, {}),
      },
    },
  },
})

-- npm i -g bash-language-server
require('lspconfig')['bashls'].setup {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
}

-- yarn global add diagnostic-languageserver
require('lspconfig')['diagnosticls'].setup {
  capabilities = capabilities,
  on_attach    = on_attach,
  flags        = lsp_flags,
}
