function CaptureCurrentBufferName()
  local bufname = vim.fn.bufname("%")
  print("Current buffer name: " .. bufname)

  local raw_representation = vim.inspect(bufname)
  print("Raw buffer name: " .. raw_representation)

  local title = vim.o.titlestring
  print("Current titlestring: " .. title)

  -- Return the values so you can copy them from the messages
  return { bufname = bufname, raw = raw_representation, title = title }
end

vim.api.nvim_set_keymap("n", "<Leader>ub", ":lua CaptureCurrentBufferName()<CR>", { noremap = true, silent = false })

require("which-key").add({
  mode = { "n" },
  { "<Leader>u", group = "Utilities", icon = "󱁤" },
  { "<leader>ub", desc = "Capture current buffer name" },
})
