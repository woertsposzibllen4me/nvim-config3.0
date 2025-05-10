function TestLazygit()
  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Create a floating window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.8),
    row = math.floor(vim.o.lines * 0.1),
    col = math.floor(vim.o.columns * 0.1),
    style = "minimal",
    border = "rounded",
  })

  -- Set buffer name for easy identification
  vim.api.nvim_buf_set_name(buf, "TestLazygit")

  -- Prepare command based on OS
  local cmd
  if vim.fn.has("win32") == 1 then
    -- For Windows
    cmd = { "cmd.exe", "/C", "lazygit" }
  else
    -- For Unix-like systems
    cmd = "lazygit"
  end

  -- Execute command using jobstart
  local job_id = vim.fn.jobstart(cmd, {
    cwd = vim.fn.getcwd(),
    term = true,
  })

  -- Start insert mode for terminal interaction
  vim.cmd("startinsert")

  return { buf = buf, win = win, job_id = job_id }
end

-- Make the function available globally
_G.TestLazygit = TestLazygit

-- Add a command to make it easy to call
vim.cmd("command! TestLazygit lua TestLazygit()")
