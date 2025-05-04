-- Yank buffer's relative path to clipboard
vim.keymap.set("n", "<leader>yp", function()
  local relative_path = vim.fn.expand("%:p:~:.")
  vim.fn.setreg("+", relative_path)
  vim.notify("Relative path copied to clipboard: " .. relative_path, vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Yank buffer relative path to clipboard" })

-- Yank buffer's absolute path to clipboard
vim.keymap.set("n", "<leader>yP", function()
  local absolute_path = vim.fn.expand("%:p")
  vim.fn.setreg("+", absolute_path)
  vim.notify("Absolute path copied to clipboard: " .. absolute_path, vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "Yank buffer absolute path to clipboard" })
