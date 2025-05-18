local M = {}

local restore_wezmove_bindings = function()
  vim.keymap.set("n", "<C-j>", function()
    require("wezterm-move").move("j")
  end)

  vim.keymap.set("n", "<C-k>", function()
    require("wezterm-move").move("k")
  end)
end

function M.restore_gs_bindings()
  vim.keymap.set("n", "q", "", { noremap = true, desc = "Quit most things" })
  local ok, foo = pcall(require, "wezterm-move")
  if ok then
    restore_wezmove_bindings()
  end
end

return M
