function RunNearestGolangTest()
  local nearestTestLine = vim.fn.search('func Test*', 'bcnW')
  if nearestTestLine == 0 then
    return 0
  end
  local primaryTestName = string.match(vim.fn.getline(nearestTestLine), '^func (Test%a+)')
  local nearestTestRunLine = vim.fn.search('t.Run("*', 'bcnW')
  local currentDir = vim.fn.expand('%:p:h')

  local testString = string.format("^%s$", primaryTestName)
  if nearestTestRunLine > 0 and nearestTestRunLine > nearestTestLine then
    local miniLineString = vim.fn.getline(nearestTestRunLine)
    local miniTestString = (string.gsub(string.match(miniLineString, '%s%a%.Run%("([^"]+)'), ' ', '_'))
    testString = string.format('^%s/"%s"$', primaryTestName, miniTestString)
  end

  local terminal = require('toggleterm.terminal').Terminal
  local command  = string.format('gotestsum --format testname -- -v -run=%s %s', testString, currentDir)
  if command == 0 then
    -- Do nothing
    vim.notify('No tests to be run from here...')
    return 0
  end

  -- Get the width of the actual screen, not just the current split/window.
  local screenWidth = tonumber(vim.api.nvim_eval('&columns'))
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
    vim.bo.textwidth  = 120
    vim.o.spell       = true
    -- Doesn't work in lua yet? https://github.com/neovim/neovim/issues/14626
    vim.api.nvim_command('set colorcolumn=120')
    vim.keymap.set("n", "<Leader>gt", RunNearestGolangTest, { silent = true })
    vim.keymap.set("n", "<Leader>dt", ":lua require('dap-go').debug_test()<cr>", { silent = true })
  end
})

require('dap-go').setup{}
