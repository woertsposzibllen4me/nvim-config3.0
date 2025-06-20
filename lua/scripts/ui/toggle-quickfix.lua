local M = {}
M.toggle_quickfix = function()
  local qf_exists = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end

-- Toggle quickfix
return M
