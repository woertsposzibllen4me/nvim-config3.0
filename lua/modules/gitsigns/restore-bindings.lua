local M = {}

local restore_wezmove_bindings = function(wezmove)
  vim.keymap.set("n", "<C-j>", function()
    wezmove.move("j")
  end)

  vim.keymap.set("n", "<C-k>", function()
    wezmove.move("k")
  end)
end

local restore_smart_splits_bindings = function(smsplit)
  vim.keymap.set("n", "<C-j>", function()
    smsplit.move_cursor_down()
  end)

  vim.keymap.set("n", "<C-k>", function()
    smsplit.move_cursor_up()
  end)
end

function M.restore_gs_bindings()
  vim.keymap.set("n", "q", "", { noremap = true, desc = "Quit most things" })
  vim.keymap.set("n", "Q", "q", { noremap = true, desc = "Record macro" })
  local ok, wezmove = pcall(require, "wezterm-move")
  if ok then
    restore_wezmove_bindings(wezmove)
  end
  local ok2, smsplit = pcall(require, "smart-splits")
  if ok2 then
    restore_smart_splits_bindings(smsplit)
  end
end

return M
