-- Swap true/false under cursor
vim.keymap.set("n", "<leader>S", function()
  -- Get current word under cursor
  local word = vim.fn.expand("<cword>")

  -- Define replacements
  local replacements = {
    ["true"] = "false",
    ["false"] = "true",
    ["True"] = "False",
    ["False"] = "True",
  }

  if replacements[word] then
    -- Save cursor position
    local cursor_pos = vim.api.nvim_win_get_cursor(0)

    -- Enter visual mode (v) and select inner word (iw) then change
    vim.cmd('normal! viw"_c' .. replacements[word])

    -- Return to normal mode and restore cursor position
    vim.api.nvim_win_set_cursor(0, cursor_pos)
  end
end, { desc = "Swap true/false keywords" })
require("which-key").add({
  { "<leader>S", group = "Swap true/false keywords", icon = "" },
})
