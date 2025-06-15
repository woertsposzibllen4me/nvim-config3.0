local M = {}
local largest_win, largest_area = nil, 0

M.focus = function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == "" then
      local area = vim.api.nvim_win_get_width(win) * vim.api.nvim_win_get_height(win)
      if area > largest_area then
        largest_area, largest_win = area, win
      end
    end
  end

  if largest_win then
    vim.api.nvim_set_current_win(largest_win)
  end
end
return M
