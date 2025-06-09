function CaptureCurrentBufferName()
  local bufname = vim.fn.bufname("%")
  print("Current buffer name: " .. bufname)

  local raw_representation = vim.inspect(bufname)
  print("Raw buffer name: " .. raw_representation)

  local title = vim.o.titlestring
  print("Current titlestring: " .. title)

  -- Return the values so you can copy them from the messages
  return { bufname = bufname, raw = raw_representation, title = title }
end

function Make_window_floating()
  local buf = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)

  vim.api.nvim_win_close(win, false)
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2) - 1,
    border = "single",
  })
  if vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
  end
end

vim.keymap.set("n", "<leader>uf", Make_window_floating, { desc = "Make window floating" })
vim.keymap.set("n", "<Leader>uB", CaptureCurrentBufferName, { desc = "Capture current buffer name" })
