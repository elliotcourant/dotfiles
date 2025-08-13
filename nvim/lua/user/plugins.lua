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
  use { "dstein64/nvim-scrollview" }
  use { 'nvim-lualine/lualine.nvim' }
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
  use { "mbbill/undotree" }
  use { "markstory/vim-zoomwin" }
  use { "junegunn/goyo.vim" }
  use { "terryma/vim-multiple-cursors" }
  use { "junegunn/vim-easy-align" }
  use { "tpope/vim-surround" }
  use {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end
  }
  use { "stevearc/dressing.nvim" }
  use { "rcarriga/nvim-notify" }
  use {
    "terrortylor/nvim-comment",
    config = function()
      require('nvim_comment').setup()
    end
  }
  use({
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
      -- Disable by default
      vim.diagnostic.config({ virtual_lines = false })
    end,
  })

  -- Telescope
  use { "nvim-telescope/telescope.nvim" }
  use { "nvim-lua/plenary.nvim" }
  -- Add icons for plugins that support it.
  use { "kyazdani42/nvim-web-devicons" }

  -- Treesitter
  use { "nvim-treesitter/nvim-treesitter" }
  use { "nvim-treesitter/playground" }
  use { "nvim-treesitter/nvim-treesitter-context" }

  -- Language Server stuff
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  }
  use { "RRethy/vim-illuminate" }
  use {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    config = function()
      require("fidget").setup {
        text = {
          spinner = "pipe",  -- animation shown when tasks are ongoing
          done = "✔",      -- character shown when all tasks are complete
          commenced = "Started", -- message shown when task starts
          completed = "Completed", -- message shown when task completes
        },
        align = {
          bottom = true, -- align fidgets along bottom edge of buffer
          right = true, -- align fidgets along right edge of buffer
        },
        timer = {
          spinner_rate = 125, -- frame rate of spinner animation, in ms
          fidget_decay = 2000, -- how long to keep around empty fidget, in ms
          task_decay = 1000, -- how long to keep around completed task, in ms
        },
        window = {
          relative = "win", -- where to anchor, either "win" or "editor"
          blend = 0, -- &winblend for the window
          zindex = nil, -- the zindex value for the window
          border = "none", -- style of border for the fidget window
        },
        fmt = {
          leftpad = true, -- right-justify text in fidget box
          stack_upwards = true, -- list of tasks grows upwards
          max_width = 0,  -- maximum width of the fidget box
          fidget =        -- function to format fidget title
              function(fidget_name, spinner)
                return string.format("%s %s", spinner, fidget_name)
              end,
          task = -- function to format each task line
              function(task_name, message, percentage)
                return string.format(
                  "%s%s [%s]",
                  message,
                  percentage and string.format(" (%s%%)", percentage) or "",
                  task_name
                )
              end,
        },
      }
    end,
  }
  use {
    'ruifm/gitlinker.nvim',
    requires = 'nvim-lua/plenary.nvim',
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

  -- Testing Stuff
  -- use { "nvim-neotest/neotest-go", commit = '22513619bcb156939c22ea7cd1a99f754fcb1fde' }
  use {
    "nvim-neotest/neotest",
    requires = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "fredrikaverpil/neotest-golang",
      -- "nvim-neotest/neotest-go",
      "haydenmeade/neotest-jest",
    },
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


  -- Robot overlords
  -- use {
  --   'yetone/avante.nvim',
  --   run = "make",
  --   requires = {
  --     'stevearc/dressing.nvim',
  --     'nvim-lua/plenary.nvim',
  --     'MunifTanjim/nui.nvim',
  --     --- The below dependencies are optional,
  --     'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
  --     'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
  --     'MeanderingProgrammer/render-markdown.nvim',
  --   }
  -- }
  use {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { "markdown", "Avante" },
    after = { 'nvim-treesitter' },
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }, -- if you prefer nvim-web-devicons
    config = function()
      require('render-markdown').setup({
        file_types = { "markdown", "Avante" },
      })
    end,
  }


  -- Git Stuff
  use { "tpope/vim-fugitive" }
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        signs = {
          add          = { text = '┃' },
          change       = { text = '┃' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        signs_staged                 = {
          add          = { text = '┃' },
          change       = { text = '┃' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
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
      }
    end
  }
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
