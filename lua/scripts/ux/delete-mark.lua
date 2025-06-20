local M = {}
M.delete_mark = function()
  vim.api.nvim_echo({ { "Press mark key to delete. (! for all)", "Normal" } }, false, {})
  -- Set a timer for timeout
  local timer = vim.loop.new_timer()
  local timed_out = false
  if timer == nil then
    return
  end
  timer:start(2000, 0, function()
    timed_out = true
    timer:close()
    vim.schedule(function()
      print("Delete mark: timeout")
    end)
  end)
  local char = vim.fn.getchar()
  if type(char) ~= "number" then
    vim.notify("Failed to get character input", vim.log.levels.ERROR, { title = "delete-mark" })
    return
  end
  if not timed_out then
    timer:close()
    if char == 27 then -- 27 is the character code for ESC
      print("Delete mark: cancelled")
      vim.cmd("redraw!")
      return
    end
    if char == 33 then -- 33 is the character code for '!'
      vim.cmd("delmarks!")
      print("Deleted all local marks")
      vim.cmd("redraw!")
      return
    end
    local mark = vim.fn.nr2char(char)
    vim.cmd("delmarks " .. mark)
    print("Deleted mark: " .. mark)
    vim.cmd("redraw!")
  end
end
return M
