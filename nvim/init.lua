require "user.plugins"
require "user.theme"
require "user.editor"
require "user.telescope"
require "user.treesitter"
require "user.autocomplete"

require "user.debugging"

require "user.golang"
require "user.markdown"
require "user.clojure"
require "user.typescript"
require "user.lua"


require "user.keybinds"

vim.api.nvim_create_user_command('Dotfiles', function()
  local files = {
    '~/dotfiles/nvim/lua/user/plugins.lua',
    '~/dotfiles/nvim/lua/user/theme.lua',
    '~/dotfiles/nvim/lua/user/editor.lua',
    '~/dotfiles/nvim/lua/user/telescope.lua',
    '~/dotfiles/nvim/lua/user/treesitter.lua',
    '~/dotfiles/nvim/lua/user/autocomplete.lua',
    '~/dotfiles/nvim/lua/user/debugging.lua',
    '~/dotfiles/nvim/lua/user/golang.lua',
    '~/dotfiles/nvim/lua/user/markdown.lua',
    '~/dotfiles/nvim/lua/user/clojure.lua',
    '~/dotfiles/nvim/lua/user/typescript.lua',
  }
  for _, item in ipairs(files) do
    vim.api.nvim_command(string.format("source %s", item))
  end

end, {
  force = true,
  nargs = 0,
})
