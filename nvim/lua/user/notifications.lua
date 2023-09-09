-- Overwrite the default notify method with the new one
local betterNotify = require("notify")
betterNotify.setup({
  background_colour = "#000000",
})
local ignoreMessages = {
  '[LSP] Format request failed, no matching language servers.',
};

function Contains(list, x)
  for _, v in ipairs(list) do
    if v == x then
      return true
    end
  end
  return false
end

--- No idea why this is necessary?
---@diagnostic disable-next-line: duplicate-set-field
vim.notify = function(msg, level, opt)
  if Contains(ignoreMessages, msg) then
    return
  end

  return betterNotify(msg, level, opt)
end
