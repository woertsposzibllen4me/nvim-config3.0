function CaptureCurrentBufferInfo()
  local bufname = vim.fn.bufname("%")
  local raw_representation = vim.inspect(bufname)
  local title = vim.o.titlestring
  local filetype = vim.bo.filetype
  local buftype = vim.bo.buftype
  local buf_vars = vim.b -- Buffer variables
  local win_config = vim.api.nvim_win_get_config(0)

  print("=== Buffer Info ===")
  print("Current buffer name: " .. bufname)
  print("Raw buffer name: " .. raw_representation)
  print("Current titlestring: " .. title)
  print("Current buffer type: " .. filetype)
  print("Current buffer type (buftype): " .. buftype)
  print("Buffer variables: " .. vim.inspect(buf_vars))
  print("Window configuration: " .. vim.inspect(win_config))

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
vim.keymap.set("n", "<Leader>uB", CaptureCurrentBufferInfo, { desc = "Capture current buffer name" })
