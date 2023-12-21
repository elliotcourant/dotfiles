-- Conjure specific configuration and setup
vim.cmd [[
  let g:conjure#filetypes = ["clojure"]
  let g:conjure#mapping#doc_word = ["L"]
  let g:conjure#client#clojure#nrepl#connection#auto_repl#cmd = "lein with-profile test repl :headless"
  let g:conjure#client#clojure#nrepl#connection#auto_repl#hidden = "true"
]]


vim.api.nvim_create_autocmd({ "BufNewFile", "BufFilePre", "BufRead", "BufEnter" }, {
  pattern = { "*.clj" },
  callback = function()
    vim.bo.textwidth  = 80
    vim.bo.expandtab  = true
    vim.bo.shiftwidth = 2
    vim.bo.tabstop    = 2
    vim.bo.textwidth  = 120
    vim.o.spell       = false
    vim.o.colorcolumn = '80'
    -- vim.api.nvim_command('set formatoptions=cqj')
    vim.keymap.set("n", "<Leader>gt", RunNearestClojureTest, { silent = true })
    vim.keymap.set("n", "<Leader>ct", ":ConjureCljRunCurrentTest<CR>", { silent = true })
  end
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.clj" },
  callback = function()
    vim.api.nvim_command('ConjureEvalBuf')
  end
})

vim.api.nvim_create_autocmd({ "BufNewFile" }, {
  pattern = { "conjure-log-*" },
  callback = function(args)
    vim.diagnostic.disable(args.buf)
  end
})

-- currentNamespace will return the clojure namespace of the currently open file.
function CurrentClojureNamespace()
  local nsLineNumber = vim.fn.search('(ns\\s\\S\\+', 'bcnW')
  if nsLineNumber == 0 then
    -- If we cannot find the namespace line then do nothing.
    return 0
  end

  -- getline can return string|string[], this just fixes it to return only a string.
  local nsLine = tostring(vim.fn.getline(nsLineNumber))
  local namespace = vim.fn.split(nsLine, " ")[2]
  return namespace
end

function NearestClojureTest()
  local nearestDeftestLine = vim.fn.search('(deftest *', 'bcnW')
  if nearestDeftestLine == 0 then
    -- If we cannot find the nearest deftest then do nothing.
    return ""
  end

  local deftestLine = tostring(vim.fn.getline(nearestDeftestLine))
  local testName = vim.fn.split(deftestLine, " ")[2]

  return testName
end

function NearestClojureTestCommand()
  local namespace = CurrentClojureNamespace()
  local test = NearestClojureTest()
  if namespace == 0 or test == "" then
    -- Do nothing
    return 0
  end

  -- Escape the > pattern sometimes seen in clojure tests. Specifically `foo->bar`.
  -- NOTE: This is definitely not a good way to do this and there are absolutely
  -- other escape patterns that might be dangerous. But I'm invoking these tests myself?
  -- so if something goes wrong its my fault anyway.
  test = string.gsub(test, ">", "\\>")
  return string.format("lein test :only %s/%s", namespace, test)
end

function RunNearestClojureTest()
  vim.cmd("ConjureCljRunCurrentTest")

  return 0
  -- local terminal = require('toggleterm.terminal').Terminal
  -- local command  = NearestClojureTestCommand()
  -- if command == 0 then
  --   -- Do nothing
  --   vim.notify('No tests to be run from here...')
  --   return 0
  -- end
  --
  -- -- Get the width of the actual screen, not just the current split/window.
  -- local screenWidth = tonumber(vim.api.nvim_eval('&columns'))
  -- -- Silence the warning about optional value below.
  -- if screenWidth == nil then
  --   return 0
  -- end
  --
  -- local desiredWidth = 120
  --
  -- local run = terminal:new({
  --   hidden        = false,
  --   cmd           = command,
  --   direction     = "float",
  --   float_opts    = {
  --     border   = "double",
  --     relative = 'editor',
  --     col      = math.max(0, screenWidth - desiredWidth), -- Right align the floating window.
  --     width    = math.min(screenWidth, desiredWidth),
  --   },
  --   auto_scroll   = true,
  --   close_on_exit = false,
  -- })
  -- run:spawn()
  -- vim.cmd("ToggleTerm")
  -- run:send(string.format("Running: %s\n------", command))
end
