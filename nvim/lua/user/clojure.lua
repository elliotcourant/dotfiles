vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead" }, {
  pattern = { "*.clj" },
  callback = function()
    vim.bo.textwidth = 80
    -- Doesn't work in lua yet? https://github.com/neovim/neovim/issues/14626
    vim.api.nvim_command('set colorcolumn=80')
    vim.keymap.set("n", "<Leader>gt", RunNearestClojureTest, { silent = true })
  end
})

-- currentNamespace will return the clojure namespace of the currently open file.
function CurrentClojureNamespace()
  local nsLineNumber = vim.fn.search('(ns *', 'bcnW')
  if nsLineNumber == 0 then
    -- If we cannot find the namespace line then do nothing.
    return 0
  end

  local nsLine = vim.fn.getline(nsLineNumber)
  local namespace = vim.fn.split(nsLine, " ")[2]
  return namespace
end

function NearestClojureTest()
  local nearestDeftestLine = vim.fn.search('(deftest *', 'bcnW')
  if nearestDeftestLine == 0 then
    -- If we cannot find the nearest deftest then do nothing.
    return 0
  end

  local deftestLine = vim.fn.getline(nearestDeftestLine)
  local testName = vim.fn.split(deftestLine, " ")[2]

  return testName
end

function NearestClojureTestCommand()
  local namespace = CurrentClojureNamespace()
  local test = NearestClojureTest()
  if namespace == 0 or test == 0 then
    -- Do nothing
    return 0
  end

  return string.format("lein test :only %s/%s", namespace, test)
end

function RunNearestClojureTest()
  local terminal = require('toggleterm.terminal').Terminal
  local command  = NearestClojureTestCommand()
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
