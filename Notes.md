## Things


Creates a virtual text that sits inbetween the lines of the buffer. I want to try to make this show github comments from
code reviews.
```lua
vim.api.nvim_buf_set_extmark(0, 0, 1, 0, {
  virt_text_pos="right_align", -- not sure if this matters
  virt_lines={
    {{"Code review comment", "Hightlight for first text"}},
    {{"Text for second line", "Hightlight for second text"}},
  }
})
```
