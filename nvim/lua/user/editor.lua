vim.g.nocompatible  = true
vim.o.number        = true
vim.g.bs            = 2 -- Make backspace work in a sane way.
vim.opt.laststatus  = 2
vim.opt.autoread    = true -- Update buffers when the file is modified externally.
vim.opt.showcmd     = true -- I want to the command keys.
vim.opt.expandtab   = true
vim.opt.smartindent = true
vim.opt.tabstop     = 2
vim.opt.shiftwidth  = 2
vim.opt.showtabline = 2 -- Is modified by the dashboard file on startup.
vim.opt.wrap        = false
vim.opt.showmode    = true
vim.opt.colorcolumn = '120'
vim.opt.hidden      = true
vim.opt.spell       = false
vim.opt.spelllang   = { 'en_us' }
vim.opt.scrolloff   = 8 -- Keep at least 8 lines visible at the bottom of the buffers.
vim.opt.updatetime  = 1000

-- Setup persistent undo
if vim.fn.has('persistent_undo') then
  local targetPath = tostring(vim.fn.expand('~/.undodir'));
  if vim.fn.isdirectory(targetPath) ~= true then
    vim.fn.mkdir(targetPath, 'p', 0755);
  end
  vim.o.undodir = targetPath;
  vim.o.undofile = true;
end

vim.cmd [[
  filetype off
  filetype plugin indent on

  set clipboard+=unnamedplus
  set ignorecase  " searches are case insensitive...
  set smartcase   " ... unless they contain at least one capital letter
  set ttyfast
  set go+=b.
  set mouse=a
  set rtp+=/.fzf
  set completeopt=preview,menu,noinsert,menuone

  set indentexpr=nvim_treesitter#indent()
  set signcolumn=auto:2
  set foldcolumn=2

  let g:bookmark_no_default_key_mappings = 1
nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
]]

-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
--   callback = function()
--     require("lint").try_lint()
--   end,
-- })

require('dressing').setup({
  input = {
    -- Set to false to disable the vim.ui.input implementation
    enabled = true,

    -- Default prompt string
    default_prompt = "Input:",

    -- Can be 'left', 'right', or 'center'
    prompt_align = "left",

    -- When true, <Esc> will close the modal
    insert_only = true,

    -- When true, input will start in insert mode.
    start_in_insert = true,

    -- These are passed to nvim_open_win
    -- anchor = "SW",
    border = "rounded",
    -- 'editor' and 'win' will default to being centered
    relative = "cursor",

    -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    prefer_width = 40,
    width = nil,
    -- min_width and max_width can be a list of mixed types.
    -- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
    max_width = { 140, 0.9 },
    min_width = { 20, 0.2 },

    -- -- Window transparency (0-100)
    -- winblend = 10,
    -- -- Change default highlight groups (see :help winhl)
    -- winhighlight = "",

    -- Set to `false` to disable
    mappings = {
      n = {
        ["<Esc>"] = "Close",
        ["<CR>"] = "Confirm",
      },
      i = {
        ["<C-c>"] = "Close",
        ["<CR>"] = "Confirm",
        ["<Up>"] = "HistoryPrev",
        ["<Down>"] = "HistoryNext",
      },
    },

    override = function(conf)
      -- This is the config that will be passed to nvim_open_win.
      -- Change values here to customize the layout
      return conf
    end,

    -- see :help dressing_get_config
    get_config = nil,
  },
  select = {
    -- Set to false to disable the vim.ui.select implementation
    enabled = true,

    -- Priority list of preferred vim.select implementations
    backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

    -- Trim trailing `:` from prompt
    trim_prompt = true,

    -- Options for telescope selector
    -- These are passed into the telescope picker directly. Can be used like:
    -- telescope = require('telescope.themes').get_ivy({...})
    telescope = nil,

    -- Options for fzf selector
    fzf = {
      window = {
        width = 0.5,
        height = 0.4,
      },
    },

    -- Options for fzf_lua selector
    fzf_lua = {
      winopts = {
        width = 0.5,
        height = 0.4,
      },
    },

    -- Options for nui Menu
    nui = {
      position = "50%",
      size = nil,
      relative = "editor",
      border = {
        style = "rounded",
      },
      buf_options = {
        swapfile = false,
        filetype = "DressingSelect",
      },
      win_options = {
        winblend = 10,
      },
      max_width = 80,
      max_height = 40,
      min_width = 40,
      min_height = 10,
    },

    -- Options for built-in selector
    builtin = {
      -- These are passed to nvim_open_win
      -- anchor = "NW",
      border = "rounded",
      -- 'editor' and 'win' will default to being centered
      relative = "editor",

      -- -- Window transparency (0-100)
      -- winblend = 10,
      -- -- Change default highlight groups (see :help winhl)
      -- winhighlight = "",

      -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
      -- the min_ and max_ options can be a list of mixed types.
      -- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
      width = nil,
      max_width = { 140, 0.8 },
      min_width = { 40, 0.2 },
      height = nil,
      max_height = 0.9,
      min_height = { 10, 0.2 },

      -- Set to `false` to disable
      mappings = {
        ["<Esc>"] = "Close",
        ["<C-c>"] = "Close",
        ["<CR>"] = "Confirm",
      },

      override = function(conf)
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        return conf
      end,
    },

    -- Used to override format_item. See :help dressing-format
    format_item_override = {},

    -- see :help dressing_get_config
    get_config = nil,
  },
})

require('gitlinker').setup({
  opts = {
    remote = nil, -- force the use of a specific remote
    -- adds current line nr in the url for normal mode
    add_current_line_on_normal_mode = true,
    -- callback for what to do with the url
    action_callback = require"gitlinker.actions".copy_to_clipboard,
    -- print the url after performing the action
    print_url = true,
  },
  callbacks = {
        ["github.com"] = require"gitlinker.hosts".get_github_type_url,
        ["gitlab.com"] = require"gitlinker.hosts".get_gitlab_type_url,
        ["gitlab.elliotcourant.dev"] = require"gitlinker.hosts".get_gitlab_type_url,
        ["try.gitea.io"] = require"gitlinker.hosts".get_gitea_type_url,
        ["codeberg.org"] = require"gitlinker.hosts".get_gitea_type_url,
        ["bitbucket.org"] = require"gitlinker.hosts".get_bitbucket_type_url,
        ["try.gogs.io"] = require"gitlinker.hosts".get_gogs_type_url,
        ["git.sr.ht"] = require"gitlinker.hosts".get_srht_type_url,
        ["git.launchpad.net"] = require"gitlinker.hosts".get_launchpad_type_url,
        ["repo.or.cz"] = require"gitlinker.hosts".get_repoorcz_type_url,
        ["git.kernel.org"] = require"gitlinker.hosts".get_cgit_type_url,
        ["git.savannah.gnu.org"] = require"gitlinker.hosts".get_cgit_type_url
  },
  -- default mapping to call url generation with action_callback
  -- mappings = "<leader>gh"
})
