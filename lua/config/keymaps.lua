local opts = { noremap = true, silent = true }
local map = vim.keymap.set

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    -- lateral movement with H and L except in neo-tree
    if vim.bo.buftype ~= "neo-tree" then
      map("n", "H", "15zh", { desc = "Move cursor 10 spaces to the left" })
      map("n", "L", "15zl", { desc = "Move cursor 10 spaces to the right" })
    end
  end,
})

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Exit terminal mode
map("t", "<C-q>", [[<C-\><C-n>]], { noremap = true, silent = true })

-- window change made simpler (might be disabled w/ smart-splits)
-- map("n", "<C-h>", "<C-w>h", { desc = "Move to left window", silent = true })
-- map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window", silent = true })
-- map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window", silent = true })
-- map("n", "<C-l>", "<C-w>l", { desc = "Move to right window", silent = true })

-- leader q to quit
vim.keymap.set({ "n", "v" }, "<leader>qq", ":<C-u>qa<CR>", { desc = "Quit all", silent = true })

-- undo on U
map("n", "U", "<C-r>")

-- save with C-S
map("n", "<C-s>", ":w<CR>", { silent = true })

-- Center after most code navigation commands
map("n", "G", "Gzz", opts)
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)
map("n", "<C-O>", "<C-O>zz", opts)
map("n", "<C-I>", "<C-I>zz", opts)
map("n", "{", "{zz", opts)
map("n", "}", "}zz", opts)
map("n", "n", "nzz", opts)
map("n", "N", "Nzz", opts)
map("n", "*", "*zz", opts)
map("n", "#", "#zz", opts)
map("n", "%", "%zz", opts)
-- map("n", "``", "``zz", opts)

-- Lazy
require("which-key").add({
  "<leader>L",
  "<cmd>Lazy<cr>",
  desc = "Lazy",
  icon = "󰒲",
})

-- Rebind macro key cause mistakes are made too often lol
map("n", "q", "", { noremap = true, desc = "Quit most things" })
map("n", "Q", "q", { noremap = true, desc = "Record macro" })

-- Delete whole word with ctrl+backspace (interpreted as <C-h> in terminal)
map("i", "<C-h>", "<C-w>", { noremap = true })

-- Disable hl with esc
map("n", "<esc>", "<cmd>noh<cr>")

map("n", "<leader>wo", function()
  vim.cmd("Neotree close")
  vim.cmd("only")
  vim.cmd("Neotree show")
end, { desc = "Close others (and opens Neotree)" })

-- force C-n and C-p to navgigate cmd/search history (fixes cmp issues)
map("c", "<C-n>", "<C-Down>", { desc = "Navigate cmd history" })
map("c", "<C-p>", "<C-Up>", { desc = "Navigate cmd history" })

map("n", vim.g.maplocalleader .. "i", function()
  vim.notify("test")
end, { desc = "test" })
