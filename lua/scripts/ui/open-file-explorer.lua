-- Utilies for opening main file explorer
local M = {}

M.open_main_explorer = function()
  if MainFileExplorer == "neo-tree" then
    vim.cmd("Neotree show")
  elseif MainFileExplorer == "snacks" then
    local current_win = vim.api.nvim_get_current_win()
    require("snacks").explorer()
    vim.defer_fn(function()
      vim.api.nvim_set_current_win(current_win) -- No other way to set current window after snacks explorer opens
    end, 0)
  end
end

M.open_on_startup = function()
  local explorer_group = vim.api.nvim_create_augroup("ExplorerAutoOpen", { clear = true })
  vim.api.nvim_create_autocmd("BufReadPost", {
    group = explorer_group,
    callback = function()
      local win_width = vim.api.nvim_win_get_width(0)
      if vim.bo.filetype ~= "qf" and win_width >= 140 then
        vim.defer_fn(function() -- defer 0 necessary to avoid visual bugs
          vim.api.nvim_clear_autocmds({ group = explorer_group })
          M.open_main_explorer()
        end, 0)
      end
    end,
  })
end
return M
