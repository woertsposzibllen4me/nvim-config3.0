function ToggleQuickfix()
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
vim.keymap.set(
  "n",
  "<leader>C",
  ":lua ToggleQuickfix()<CR>",
  { noremap = true, silent = true, desc = "Toggle quickfix" }
)

-- Add autocmd to map 'q' in quickfix window
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "q", ":cclose<CR>", { buffer = true, silent = true })
  end,
})
