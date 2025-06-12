-- Protected filetypes that shouldn't be closed with ESC
local protected_filetypes = {
  "snacks_picker_list",
  "snacks_picker_input",
}

local wins = vim.api.nvim_list_wins()
for _, win in ipairs(wins) do
  if vim.api.nvim_win_is_valid(win) then
    local ok, config = pcall(vim.api.nvim_win_get_config, win)
    if ok and config.relative ~= "" then -- floating window
      local buf = vim.api.nvim_win_get_buf(win)
      local filetype = vim.bo[buf].filetype

      -- Only close if not in protected filetypes
      local is_protected = false
      for _, protected_ft in ipairs(protected_filetypes) do
        if filetype == protected_ft then
          is_protected = true
          break
        end
      end

      if not is_protected then
        pcall(vim.api.nvim_win_close, win, false)
      end
    end
  end
end
vim.cmd("noh")
