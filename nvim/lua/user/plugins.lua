local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  use { "wbthomason/packer.nvim" } -- Have packer manage itself

  -- My personal theme
  use { "elliotcourant/material.vim" }
  use { "vim-airline/vim-airline" }
  use { "vim-airline/vim-airline-themes" }
  use {
    'kdheepak/tabline.nvim',
    config = function()
      require 'tabline'.setup {
        -- Defaults configuration options
        enable = false,
        options = {
          -- If lualine is installed tabline will use separators configured in lualine by default.
          -- These options can be used to override those settings.
          section_separators     = { '', '' },
          component_separators   = { '', '' },
          max_bufferline_percent = nil, -- set to nil by default, and it uses vim.o.columns * 2/3
          show_tabs_always       = true, -- this shows tabs only when there are more than one tab or if the first tab is named
          show_devicons          = true, -- this shows devicons in buffer section
          show_bufnr             = false, -- this appends [bufnr] to buffer section,
          show_filename_only     = false, -- shows base filename only instead of relative path in filename
          modified_icon          = "+ ", -- change the default modified icon
          modified_italic        = false, -- set to true by default; this determines whether the filename turns italic if modified
          show_tabs_only         = false, -- this shows only tabs instead of tabs + buffers
        }
      }
      vim.cmd [[
        set guioptions-=e " Use showtabline in gui vim
        set sessionoptions+=tabpages,globals " store tabpages and globals in session
      ]]
    end,
    requires = {
      { 'hoob3rt/lualine.nvim', opt = true },
      { 'kyazdani42/nvim-web-devicons', opt = true }
    }
  }
  use {
    'goolord/alpha-nvim',
    config = function()
      require 'alpha'.setup(require 'user.dashboard'.config)
    end
  }

  -- Editor nice to haves
  use {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end
  }
  use { "markstory/vim-zoomwin" }
  use { "junegunn/goyo.vim" }
  use { "terryma/vim-multiple-cursors" }
  use { "junegunn/vim-easy-align" }
  use { "easymotion/vim-easymotion" }
  use { "tpope/vim-surround" }
  use {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end
  }
  use { "stevearc/dressing.nvim" }
  use { "rcarriga/nvim-notify" }


  -- Telescope
  use { "nvim-telescope/telescope.nvim" }
  use {
    "tom-anders/telescope-vim-bookmarks.nvim",
    requires = {
      { "nvim-telescope/telescope.nvim" },
      { "MattesGroeger/vim-bookmarks" },
    }
  }
  use { "nvim-lua/plenary.nvim" }
  -- Add icons for plugins that support it.
  use { "kyazdani42/nvim-web-devicons" }

  -- Treesitter
  use { "nvim-treesitter/nvim-treesitter" }
  use {
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup {
        enable         = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines      = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        trim_scope     = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        patterns       = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
          -- For all filetypes
          -- Note that setting an entry here replaces all other patterns for this entry.
          -- By setting the 'default' entry below, you can control which nodes you want to
          -- appear in the context window.
          default = {
            'class',
            'function',
            'method',
            -- 'for', -- These won't appear in the context
            -- 'while',
            -- 'if',
            -- 'switch',
            -- 'case',
          },
          -- Example for a specific filetype.
          -- If a pattern is missing, *open a PR* so everyone can benefit.
          --   rust  = {
          --       'impl_item',
          --   },
        },
        exact_patterns = {
          -- Example for a specific filetype with Lua patterns
          -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
          -- exactly match "impl_item" only)
          -- rust    = true,
        },

        -- [!] The options below are exposed but shouldn't require your attention,
        --     you can safely ignore them.

        zindex    = 20, -- The Z-index of the context window
        mode      = 'topline', -- Line used to calculate context. Choices: 'cursor', 'topline'
        separator = nil, -- Separator between context and content. Should be a single character string, like '-'.
      }
    end
  }
  use {
    "mfussenegger/nvim-lint",
    config = function()
      require('lint').linters_by_ft = {
        typescript = { 'eslint' },
        tsx        = { 'eslint' },
        javascript = { 'eslint' },
        jsx        = { 'eslint' },
      }
    end
  }


  -- Language Server stuff
  use {
    "williamboman/nvim-lsp-installer",
    "neovim/nvim-lspconfig",
  }
  use { "RRethy/vim-illuminate" }
  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = { { 'neovim/nvim-lspconfig' }, { 'nvim-lua/plenary.nvim' } },
  }

  -- Terminal things
  use {
    "akinsho/toggleterm.nvim",
    tag = 'v2.*',
    config = function()
      require("toggleterm").setup {
        shade_terminals = true,
        shading_factor = 0,
      }
    end
  }


  -- Autocomplete things
  -- cmp plugins
  use { "hrsh7th/nvim-cmp" } -- The completion plugin
  use { "hrsh7th/cmp-buffer" } -- buffer completions
  use { "hrsh7th/cmp-path" } -- path completions
  use { "saadparwaiz1/cmp_luasnip" } -- snippet completions
  use { "hrsh7th/cmp-nvim-lsp" }
  use { "hrsh7th/cmp-nvim-lua" }
  use { "L3MON4D3/LuaSnip" }

  -- Debugger things
  use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
  use { "theHamsta/nvim-dap-virtual-text" }
  use { "nvim-telescope/telescope-dap.nvim" }


  -- Golang Stuff
  use {
    "fatih/vim-go",
    run = ':GoUpdateBinaries'
  }
  use { "leoluz/nvim-dap-go", requires = { "mfussenegger/nvim-dap" } }


  -- Markdown stuff
  use {
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    ft = { "markdown" },
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  }

  -- Clojure stuff
  use { 'Olical/conjure' }
  use { 'guns/vim-sexp' }
  use { 'tpope/vim-sexp-mappings-for-regular-people' }


  -- Git Stuff
  use { "tpope/vim-fugitive" }
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        signs                        = {
          add          = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
          change       = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
          delete       = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
          topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
          changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        },
        signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir                 = {
          interval     = 1000,
          follow_files = true
        },
        attach_to_untracked          = true,
        current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts      = {
          virt_text         = true,
          virt_text_pos     = 'eol', -- 'eol' | 'overlay' | 'right_align'
          delay             = 1000,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
        sign_priority                = 1,
        update_debounce              = 100,
        status_formatter             = nil, -- Use default
        max_file_length              = 40000, -- Disable if file is longer than this (in lines)
        preview_config               = {
          -- Options passed to nvim_open_win
          border   = 'single',
          style    = 'minimal',
          relative = 'cursor',
          row      = 0,
          col      = 1
        },
        yadm                         = {
          enable = false
        },
      }
    end
  }
  use {
    'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require "octo".setup()
    end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
