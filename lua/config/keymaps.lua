-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = { noremap = true, silent = true }
local map = vim.keymap.set

-- override OG lazygit with our custom solution
vim.api.nvim_set_keymap("n", "<leader>gg", [[<Cmd>lua StartLazygit()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gl", [[<Cmd>lua OpenLazygitLogs()<CR>]], { noremap = true, silent = true })

map("n", "U", "<C-r>")

-- Navigation
map("n", "G", "Gzz", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
-- map("n", "{", "{zz", opts)
-- map("n", "}", "}zz", opts)
map("n", "n", "nzz", opts)
map("n", "N", "Nzz", opts)
map("n", "*", "*zz", opts)
map("n", "#", "#zz", opts)
map("n", "%", "%zz", opts)
map("n", "``", "``zz", opts)

-- clipboard
map("n", "<leader>ya", 'ggVG"+y', { noremap = true, silent = true, desc = "Copy file to system clipboard" })

-- Lazy
map("n", "<leader>ll", "<cmd>Lazy<cr>", { noremap = true, silent = true, desc = "Lazy" })
map("n", "<leader>lx", "<cmd>LazyExtras<cr>", { noremap = true, silent = true, desc = "LazyExtras" })

-- Buffer picking
map("n", "gb", "<cmd>BufferLinePick<CR>", { noremap = true, silent = true, desc = "Pick buffer" })

vim.keymap.set({ "i", "s" }, "<A-n>", function()
  return vim.snippet.active({ direction = 1 }) and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
end, { expr = true, silent = true })

vim.keymap.set({ "i", "s" }, "<A-p>", function()
  return vim.snippet.active({ direction = -1 }) and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<S-Tab>"
end, { expr = true, silent = true })

-- Map <Enter> to insert a new line below and return to the original line
vim.api.nvim_set_keymap("n", "<Enter>", "o<Esc>k", { noremap = true, silent = true })
-- Map <A-Enter> to insert a new line above and return to the original line (uses a custom char to allow binding)
vim.api.nvim_set_keymap("n", "<A-Enter>", "O<Esc>j", { noremap = true, silent = true })

-- Rebind macro key cause mistakes are made too often lol
vim.api.nvim_set_keymap("n", "q", "", { noremap = true })
vim.api.nvim_set_keymap("n", "Q", "q", { noremap = true })

-- Delete whole word with ctrl+backspace (interpreted as <C-h> in terminal)
vim.api.nvim_set_keymap("i", "<C-h>", "<C-w>", { noremap = true })
