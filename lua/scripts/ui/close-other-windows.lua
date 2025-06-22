local M = {}
M.solo_window_with_filetree = function()
  local excluded_filetypes = {
    "snacks_picker_list",
    "snacks_picker_input",
    "neo-tree",
  }
  if vim.tbl_contains(excluded_filetypes, vim.bo.filetype) then
    vim.notify("Cannot focus on explorer window", vim.log.levels.WARN)
    return
  end
  vim.cmd("only!")
  vim.schedule(function()
    pcall(function()
      require("scripts.ui.open-file-explorer").open_main_explorer()
    end)
  end)
end
return M
