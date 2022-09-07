-- Shorten function name
local keymap = vim.keymap.set
local command = vim.api.nvim_create_user_command
-- Silent keymap option
local opts = { silent = true }

-- Remap ' as the leader key.
vim.g.mapleader = "'"

keymap("n", "<Leader>ev", ":e $MYVIMRC<CR>", opts)
keymap("n", "<Leader>sv", ":so $MYVIMRC<CR>", opts)

-- Allow the Tab key to be used to navigate between windows
keymap("n", "<Tab>", "<C-w>", opts)
keymap("n", "<Tab><Tab>", "<C-w><C-w>", opts)
keymap("x", "<Tab>", "<C-w>", opts)
keymap("x", "<Tab><Tab>", "<C-w><C-w>", opts)

-- Allow Shift+Tab to cycle through tab.s
keymap("n", "<S-Tab>", "gt", opts)

keymap("n", "<Leader>f", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<Leader>a", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", ";", "<cmd>Telescope buffers<cr>", opts)

-- Bookmark things
keymap("n", ",,", "(Plug)BookmarkTogggle<cr>")
keymap("n", "<Leader>b", "<cmd>Telescope vim_bookmarks all<cr>", opts)
keymap("n", "<Leader>b", "<cmd>Telescope vim_bookmarks current_file<cr>", opts)

keymap("n", "<Leader>t", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", opts)
keymap("n", "<Leader>T", "<cmd>Telescope lsp_document_symbols<cr>", opts)
keymap("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
keymap("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)
keymap("n", "tt", "<cmd>ToggleTerm<cr>", opts)
keymap("i", "<C-Tab>", "<C-\\>", opts)

-- Clojure
keymap("n", "<Leader>gt", "<cmd>ConjureCljRunCurrentTest<cr>", opts)
keymap("n", '"', "<cmd>ConjureEvalCurrentForm<cr>", opts)
keymap("v", '"', "<cmd>'<,'>%ConjureEval<cr>", opts)

-- Easy Motion Keybindings
keymap("n", "<Leader>w", "<Plug>(easymotion-bd-w)")
keymap("n", "<Leader>W", "<Plug>(easymotion-overwin-w)")
keymap("n", "<Leader>l", "<Plug>(easymotion-bd-jk)")
keymap("n", "<Leader>L", "<Plug>(easymotion-overwin-line)")

-- Easy Align Keybindings
keymap("x", "ga", "<Plug>(EasyAlign)", opts)
keymap("n", "ga", "<Plug>(EasyAlign)", opts)

-- Focus Keybindings
keymap("n", "<Leader>z", "<cmd>ZoomToggle<cr>", opts)

-- Removing any trailing whitespace in the file.
keymap("n", "<Leader>s", "<cmd>%s/\\s\\+$//e<cr><cmd>noh<cr><cmd>w<cr>", opts)

-- ################################################################################################################## --
local commandOpts = { force = true }
command('Split', 'split', commandOpts)
command('WQ', 'wq', commandOpts)
command('Wq', 'wq', commandOpts)
command('QA', 'qa', commandOpts)
command('Qa', 'qa', commandOpts)
command('W', 'w', commandOpts)
command('Q', 'q', commandOpts)
command('D', 'q', commandOpts)
command('VS', 'vs', commandOpts)
command('Vs', 'vs', commandOpts)
command('BD', 'bd', commandOpts)
command('Bd', 'bd', commandOpts)
command('Eslint', '!yarn eslint --fix %', commandOpts)
command('Focus', 'Goyo 120x100%', commandOpts)
command('Unfocus', 'Goyo', commandOpts)


command('ClearQuickfixList', 'cexpr []', commandOpts)

vim.api.nvim_create_user_command('Make', function(input)
  local terminal      = require('toggleterm.terminal').Terminal
  local makeCommand   = string.format('make %s', input.args)
  -- Get the width of the actual screen, not just the current split/window.
  local screenWidth   = tonumber(vim.api.nvim_eval('&columns'))
  local screenHeight  = tonumber(vim.api.nvim_eval('&lines'))
  local desiredWidth  = 80
  local desiredHeight = 30

  local run = terminal:new({
    hidden        = false,
    cmd           = makeCommand,
    direction     = "float",
    float_opts    = {
      border   = "double",
      relative = 'editor',
      row      = 0,
      col      = math.max(0, screenWidth - desiredWidth), -- Right align the floating window.
      width    = math.min(screenWidth, desiredWidth),
      height   = math.min(screenHeight, desiredHeight)
    },
    auto_scroll   = true,
    close_on_exit = false,
  })
  run:spawn()
  vim.cmd("ToggleTerm")
  run:send(string.format("Running: %s\n------", makeCommand))
end, {
  force = true,
  nargs = 1,
})
