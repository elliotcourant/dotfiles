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

keymap("n", "<Leader>t", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", opts)
keymap("n", "<Leader>T", "<cmd>Telescope lsp_document_symbols<cr>", opts)
keymap("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
keymap("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)


keymap("n", "tt", "<cmd>ToggleTerm<cr>", opts)
keymap("i", "<C-Tab>", "<C-\\>", opts)



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
command('Eslint', '!yarn eslint --fix %', commandOpts)