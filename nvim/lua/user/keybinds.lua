-- Shorten function name
local keymap = vim.keymap.set
local command = vim.api.nvim_create_user_command
-- Silent keymap option
local opts = { silent = true }

-- Remap ' as the leader key.
vim.g.mapleader = "'"

keymap("n", "Q","<nop>", opts) -- Begone evil

keymap("n", "<Leader>ev", ":e $MYVIMRC<CR>", opts)

-- keymap("n", "<Left>", "<nop>")
-- keymap("n", "<Right>", "<nop>")
-- keymap("n", "<Up>", "<nop>")
-- keymap("n", "<Down>", "<nop>")
-- keymap("i", "<Left>", "<nop>")
-- keymap("i", "<Right>", "<nop>")
-- keymap("i", "<Up>", "<nop>")
-- keymap("i", "<Down>", "<nop>")

-- Allow the Tab key to be used to navigate between windows
keymap("n", "<Tab>",      "<C-w>",      opts)
keymap("n", "<Tab><Tab>", "<C-w><C-w>", opts)
keymap("x", "<Tab>",      "<C-w>",      opts)
keymap("x", "<Tab><Tab>", "<C-w><C-w>", opts)

-- Allow Shift+Tab to cycle through tab.s
keymap("n", "<S-Tab>", "gt", opts)

keymap("n", "<Leader>f", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<Leader>a", "<cmd>Telescope live_grep<cr>",  opts)
keymap("n", ";",         "<cmd>Telescope buffers<cr>",    opts)
keymap("n", "<Leader><Tab>", "<cmd>Telescope jumplist<cr>", opts)

-- Bookmark things
keymap("n", ",,",        "(Plug)BookmarkTogggle<cr>")
keymap("n", "<Leader>b", "<cmd>Telescope vim_bookmarks all<cr>",          opts)
keymap("n", "<Leader>b", "<cmd>Telescope vim_bookmarks current_file<cr>", opts)

-- Debugging things
keymap("n", "<Leader>d",      ":lua require('dap').continue()<cr>",                                           opts)
keymap("n", "<Leader>l",      ":lua require'telescope'.extensions.dap.frames{}<cr>",                          opts)
keymap("n", "<Leader><Cr>",   ":lua require'dap'.toggle_breakpoint()<cr>",                                    opts)
keymap("n", "<Leader><S-Cr>", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>", opts)
keymap("n", "<Leader>]",      ":lua require'dap'.step_over()<cr>",                                            opts)
keymap("n", "<Leader>[",      ":lua require'dap'.step_into()<cr>",                                            opts)
keymap("n", "<Leader>;",      ":lua require'dap'.run_to_cursor()<cr>",                                        opts)
keymap("n", "<Leader>\\",     ":lua require'dap'.terminate()<cr>:lua require'dap'.repl.close()<cr>",          opts)

keymap("n", "<Leader>t",      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",                             opts)
keymap("n", "<Leader>T",      "<cmd>Telescope lsp_document_symbols<cr>",                                      opts)
keymap("n", "<Leader>/",      "<cmd>Telescope current_buffer_fuzzy_find<cr>",                                 opts)

keymap("n", "<A-CR>",  vim.lsp.buf.code_action, { silent = true, noremap = true })
keymap("n", "<^]-CR>", vim.lsp.buf.code_action, { silent = true, noremap = true })

keymap("n", "[\\", vim.diagnostic.goto_next, { silent = true, noremap = true })
keymap("n", "]\\", vim.diagnostic.goto_prev, { silent = true, noremap = true })

keymap("n", "<Leader>v", function ()
  local virtual_lines = not vim.diagnostic.config().virtual_lines;
  vim.diagnostic.config({
    virtual_lines = virtual_lines,
    virtual_text  = not virtual_lines,
  })
end)

keymap("n", "gr",      "<cmd>Telescope lsp_references<cr>",  opts)
keymap("n", "gd",      "<cmd>Telescope lsp_definitions<cr>", opts)
keymap("n", "tt",      "<cmd>ToggleTerm<cr>",                opts)
keymap("i", "<C-Tab>", "<C-\\>",                             opts)

-- Clojure
keymap("n", "<Leader>GT", "<cmd>ConjureCljRunCurrentTest<cr>", opts)
-- keymap("n", "<Leader>gt", RunNearestClojureTest, opts)
keymap("n", '"', "<cmd>ConjureEvalCurrentForm<cr>", opts)
keymap("v", '"', "<cmd>'<,'>%ConjureEval<cr>",      opts)


-- Easy Motion Keybindings
keymap("n", "<Leader>w", "<Plug>(easymotion-bd-w)")
keymap("n", "<Leader>W", "<Plug>(easymotion-overwin-w)")
keymap("n", "<Leader>l", "<Plug>(easymotion-bd-jk)")
keymap("n", "<Leader>L", "<Plug>(easymotion-overwin-line)")

-- Easy Align Keybindings
keymap("x", "ga", "<Plug>(EasyAlign)", opts)
keymap("n", "ga", "<Plug>(EasyAlign)", opts)

-- Undo tree
keymap("n", "<Leader>u", "<cmd>UndotreeToggle<cr><cmd>UndotreeFocus<cr>", opts)

-- Focus Keybindings
keymap("n", "<Leader>z", "<cmd>ZoomToggle<cr>", opts)

-- Removing any trailing whitespace in the file.
keymap("n", "<Leader>s", "<cmd>%s/\\s\\+$//e<cr><cmd>noh<cr><cmd>w<cr>", opts)

-- TEST KEYBINDS
keymap("n", "<Leader>lt", require("neotest").run.run_last, opts)
keymap("n", "<Leader>at", require("neotest").run.attach, opts)
keymap("n", "<Leader>gt", require("neotest").run.run, opts)
keymap("n", "<Leader>st", require("neotest").run.stop, opts)
keymap("n", "<Leader>tt", require("neotest").summary.toggle, opts)
keymap("n", "<Leader>ot", function()
  require("neotest").output.open({
    enter = true,
    last_run = true,
    auto_close = true,
  });
end , opts)
keymap("n", "<Leader>oo", require("neotest").output_panel.toggle, opts)

-- ################################################################################################################## --
local commandOpts = { force = true }
command('Split',   'split',                commandOpts)
command('WQ',      'wq',                   commandOpts)
command('Wq',      'wq',                   commandOpts)
command('QA',      'qa',                   commandOpts)
command('Qa',      'qa',                   commandOpts)
command('W',       'w',                    commandOpts)
command('Q',       'q',                    commandOpts)
command('D',       'q',                    commandOpts)
command('VS',      'vs',                   commandOpts)
command('Vs',      'vs',                   commandOpts)
command('Eslint',  '!yarn eslint --fix %', commandOpts)
command('Focus',   'Goyo 120x100%',        commandOpts)
command('Unfocus', 'Goyo',                 commandOpts)

command('Bd', 'bp | sp | bn | bd', commandOpts)
command('BD', 'bp | sp | bn | bd', commandOpts)

command('ClearQuickfixList', 'cexpr []', commandOpts)

vim.api.nvim_create_user_command('Make', function(input)
  local terminal      = require('toggleterm.terminal').Terminal
  local makeCommand   = string.format('make %s', input.args)
  -- Get the width of the actual screen, not just the current split/window.
  local screenWidth   = tonumber(vim.api.nvim_eval('&columns'))
  local screenHeight  = tonumber(vim.api.nvim_eval('&lines'))
  if screenWidth == nil or screenHeight == nil then
    return 0
  end
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
