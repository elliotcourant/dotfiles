vim.api.nvim_create_autocmd({ "FileType", "FocusGained", "FocusLost", "BufEnter", "BufLeave" }, {
  pattern = { "*" },
  callback = function()
    if vim.bo.filetype == "alpha" then
      vim.o.showtabline = 0
      vim.o.showmode    = 0
      vim.o.laststatus  = 0
      vim.o.ruler       = 0
      vim.o.showcmd     = 0
    else
      vim.o.showtabline = 2
      vim.o.showmode    = 1
      vim.o.laststatus  = 2
      vim.o.ruler       = 1
      vim.o.showcmd     = 1
    end
  end
})

local if_nil = vim.F.if_nil

local default_terminal = {
    type = "terminal",
    command = nil,
    width = 69,
    height = 8,
    opts = {
        redraw = true,
        window_config = {},
    },
}

local default_header = {
    type = "text",
    val = {
      [[         //                 /*          ]],
      [[      ,(/(//,               *###        ]],
      [[    ((((((////.             /####%*     ]],
      [[ ,/(((((((/////*            /########   ]],
      [[/*///((((((//////.          *#########/ ]],
      [[//////((((((((((((/         *#########/.]],
      [[////////((((((((((((*       *#########/.]],
      [[/////////(/(((((((((((      *#########(.]],
      [[//////////.,((((((((((/(    *#########(.]],
      [[//////////.  /(((((((((((,  *#########(.]],
      [[(////////(.    (((((((((((( *#########(.]],
      [[(////////(.     ,#((((((((((##########(.]],
      [[((//////((.       /#((((((((##%%######(.]],
      [[((((((((((.         #(((((((####%%##%#(.]],
      [[((((((((((.          ,((((((#####%%%%%(.]],
      [[ .#(((((((.            (((((#######%%   ]],
      [[    /(((((.             .(((#%##%%/*    ]],
      [[      ,(((.               /(#%%#        ]],
      [[        ./.                 #*          ]],
    },
    opts = {
        position = "center",
        hl = "String",
        -- wrap = "overflow";
    },
}

local versionOutput = vim.api.nvim_eval("execute('version')")
local versionStr = vim.fn.split(vim.fn.split(versionOutput, '\n')[1], ' ')[2]

local function hostOS ()
  if vim.fn.has('mac') then
    return ' macOS'
  end
  if vim.fn.has('linux') then
    return ' Linux'
  end
  if vim.fn.has('win32') or vim.fn.has('win64') then
    return ' Windows'
  end
end

-- vim.api.nvim_eval("matchstr(execute('version'), 'NVIM v\zs[^\n]*')")
local version_one = {
    type = "text",
    val = {
      versionStr,
    },
    opts = {
        position = "center",
        hl = "Function",
    },
}
local version_two = {
    type = "text",
    val = {
      hostOS(),
    },
    opts = {
        position = "center",
        hl = "Function",
    },
}


local screenHeight = tonumber(vim.api.nvim_eval('&lines'))
local footer = {
    type = "text",
    val = string.rep(' \n', screenHeight - 36),
    opts = {
        position = "center",
        hl = "Type",
    },
}

local leader = "'"

--- @param sc string
--- @param txt string
--- @param keybind string? optional
--- @param keybind_opts table? optional
local function button(sc, txt, keybind, keybind_opts)
    local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

    local opts = {
        position       = "center",
        shortcut       = sc,
        cursor         = 5,
        width          = 50,
        align_shortcut = "right",
        hl_shortcut    = "Keyword",
        hl             = "Type"
    }
    if keybind then
        keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
        opts.keymap = { "n", sc_, keybind, keybind_opts }
    end

    local function on_press()
        local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
        vim.api.nvim_feedkeys(key, "tx", false)
    end

    return {
        type     = "button",
        val      = txt,
        on_press = on_press,
        opts     = opts,
    }
end

local buttons = {
    type = "group",
    val = {
        button("' f",          "  Find file"),
        button("' a",          "  Find word"),
        button("e",            "  New file",       "<cmd>ene <CR>"),
        button("e $MYVIMRC",   "  Edit Config",    "<cmd>e $MYVIMRC<cr>"),
        button("PackerUpdate", "ﮮ  Update Plugins", "<cmd>PackerUpdate<cr>"),
        button("checkhealth",  "  Check Health",   "<cmd>checkhealth<cr>"),
    },
    opts = {
        spacing = 1,
    },
}

local section = {
    terminal    = default_terminal,
    header      = default_header,
    version_one = version_one,
    version_two = version_two,
    buttons     = buttons,
    footer      = footer,
}

local config = {
    layout = {
        { type = "padding", val = 2 },
        section.header,
        { type = "padding", val = 2 },
        section.version_one,
        section.version_two,
        { type = "padding", val = 2 },
        section.buttons,
        section.footer,
    },
    opts = {
        margin = 5,
    },
}

return {
    button  = button,
    section = section,
    config  = config,
    -- theme config
    leader  = leader,
    -- deprecated
    opts    = config,
}
