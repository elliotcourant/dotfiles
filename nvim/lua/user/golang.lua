function RunNearestGolangTest()
  local nearestTestLine = vim.fn.search('func Test*', 'bcnW')
  if nearestTestLine == 0 then
    return 0
  end
  local line = tostring(vim.fn.getline(nearestTestLine))
  local primaryTestName = string.match(line, '^func (Test%a+)')
  local nearestTestRunLine = vim.fn.search('t.Run("*', 'bcnW')
  local currentDir = vim.fn.expand('%:p:h')

  local testString = string.format("^%s$", primaryTestName)
  if nearestTestRunLine > 0 and nearestTestRunLine > nearestTestLine then
    local miniLineString = tostring(vim.fn.getline(nearestTestRunLine))
    local miniTestString = (string.gsub(string.match(miniLineString, '%s%a%.Run%("([^"]+)'), ' ', '_'))
    testString = string.format('^%s/"%s"$', primaryTestName, miniTestString)
  end

  local terminal = require('toggleterm.terminal').Terminal
  local command  = string.format('gotestsum --format testname -- --race -v -run=%s %s', testString, currentDir)
  if command == 0 then
    -- Do nothing
    vim.notify('No tests to be run from here...')
    return 0
  end

  -- Get the width of the actual screen, not just the current split/window.
  local screenWidth = tonumber(vim.api.nvim_eval('&columns'))
  if screenWidth == nil then
    return 0
  end
  local desiredWidth = 120

  local run = terminal:new({
    hidden        = false,
    cmd           = command,
    direction     = "float",
    float_opts    = {
      border   = "double",
      relative = 'editor',
      col      = math.max(0, screenWidth - desiredWidth), -- Right align the floating window.
      width    = math.min(screenWidth, desiredWidth),
    },
    auto_scroll   = true,
    close_on_exit = false,
  })
  run:spawn()
  vim.cmd("ToggleTerm")
  run:send(string.format("Running: %s\n------", command))
end

vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead", "BufEnter" }, {
  pattern = { "*.go" },
  callback = function()
    vim.bo.expandtab  = false
    vim.bo.shiftwidth = 2
    vim.bo.tabstop    = 2
    vim.bo.textwidth  = 80
    vim.o.spell       = false
    vim.o.colorcolumn = '80'
    -- vim.keymap.set("n", "<Leader>gt", RunNearestGolangTest, { silent = true })
    vim.keymap.set("n", "<Leader>dt", ":lua require('dap-go').debug_test()<cr>", { silent = true })
  end
})

local function go_org_imports(wait_ms)
  -- Based on https://github.com/neovim/nvim-lspconfig/issues/115#issuecomment-1801096383
  local params = vim.lsp.util.make_range_params(0, 'utf-8')
  params.context = { only = { "source.organizeImports" } }
  local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
  for cid, res in pairs(result or {}) do
    for _, r in pairs(res.result or {}) do
      if r.edit then
        local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
        vim.lsp.util.apply_workspace_edit(r.edit, enc)
      end
    end
  end
end

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*.go" },
  callback = function ()
    go_org_imports()
    vim.lsp.buf.format()
  end
})

require('dap-go').setup{
  -- Additional dap configurations can be added.
  -- dap_configurations accepts a list of tables where each entry
  -- represents a dap configuration. For more details do:
  -- :help dap-configuration
  dap_configurations = {
    {
      -- Must be "go" or it will be ignored by the plugin
      name = "monetr Remote",
      type = "go",
      mode = "remote",
      request = "attach",
      host = "localhost",
      port = "2345",
    },
  },
  delve = {
    build_flags = "-tags=testing",
  }
}
