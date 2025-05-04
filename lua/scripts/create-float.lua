local function create_float()
  -- Create a buffer
  local buf = vim.api.nvim_create_buf(false, true)

  -- Get dimensions
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  -- Calculate starting position
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Set up window options
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  }

  -- Open window with buffer
  local win = vim.api.nvim_open_win(buf, true, opts)

  return buf, win
end

vim.api.nvim_create_user_command("FloatingBuffer", function()
  create_float()
end, {})
