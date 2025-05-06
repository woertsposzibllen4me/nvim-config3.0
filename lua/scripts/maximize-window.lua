local original_dimensions = {}

local function restore_window()
  local win_id = vim.api.nvim_get_current_win()
  if original_dimensions[win_id] then
    vim.api.nvim_win_set_width(win_id, original_dimensions[win_id].width)
    vim.api.nvim_win_set_height(win_id, original_dimensions[win_id].height)
    original_dimensions[win_id] = nil
  end
end

local function set_window()
  local win_id = vim.api.nvim_get_current_win()
  original_dimensions[win_id] = {
    width = vim.api.nvim_win_get_width(win_id),
    height = vim.api.nvim_win_get_height(win_id),
  }
  return win_id
end

local function maximize_window()
  restore_window()
  local win_id = set_window()
  vim.cmd("wincmd _")
  vim.cmd("wincmd |")
end

local function half_size_window()
  restore_window()
  local win_id = set_window()
  maximize_window()
  local max_width = vim.api.nvim_win_get_width(win_id)
  local max_height = vim.api.nvim_win_get_height(win_id)
  vim.api.nvim_win_set_width(win_id, math.floor(max_width / 2))
  vim.api.nvim_win_set_height(win_id, math.floor(max_height / 2))
end

vim.keymap.set("n", "<leader>wm", maximize_window, { desc = "Maximize window size" })
vim.keymap.set("n", "<leader>ws", set_window, { desc = "Set window size" })
vim.keymap.set("n", "<leader>wr", restore_window, { desc = "Restore window size" })
vim.keymap.set("n", "<leader>wh", half_size_window, { desc = "Set window to half size" })
