local opts = { noremap = true, silent = true }
local wk = require("which-key")
local map = vim.keymap.set

-- lateral movement with H and L except in neo-tree
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
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
map("n", "<C-s>", "<cmd>w<cr><esc>", { silent = true })

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
wk.add({
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

-- Close (non-entered) floating windows and disable search hl with esc
map("n", "<esc>", function()
  local current_win = vim.api.nvim_get_current_win()
  local current_config = vim.api.nvim_win_get_config(current_win)

  -- If currently in a floating window, don't close any floating windows
  if current_config.relative ~= "" then
    vim.cmd("noh") -- just clear search highlights
    return
  end

  -- Otherwise, close any open floating windows (hover docs, diagnostics, etc.)
  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    -- Check if window still exists before trying to get config
    if vim.api.nvim_win_is_valid(win) then
      local ok, config = pcall(vim.api.nvim_win_get_config, win)
      if ok and config.relative ~= "" then -- floating window
        pcall(vim.api.nvim_win_close, win, false)
      end
    end
  end
  vim.cmd("noh")
end, { silent = true, desc = "Close floating windows/disable search highlight" })

-- Set focus on solo windows with neo-tree
map("n", "<leader>wo", function()
  vim.cmd("Neotree close")
  vim.cmd("only")
  vim.cmd("Neotree show")
end, { desc = "Close others (and opens Neotree)" })

-- force C-n and C-p to navigate cmd/search history (fixes cmp issues)
map("c", "<C-n>", "<C-Down>", { desc = "Navigate cmd history" })
map("c", "<C-p>", "<C-Up>", { desc = "Navigate cmd history" })

map("n", vim.g.maplocalleader .. "i", function()
  vim.notify("test")
end, { desc = "test" })

-- Search within visual selection
vim.keymap.set("x", "<leader>/", "<Esc>/\\%V")

wk.add({
  "<leader>bp",
  function()
    local path = vim.api.nvim_buf_get_name(0)
    local row = unpack(vim.api.nvim_win_get_cursor(0))
    local command = ("pycharm --line " .. row .. " " .. path .. "")
    print(command)
    os.execute(command)
  end,
  desc = "Open line in PyCharm",
  icon = { icon = "", color = "yellow" },
})

-- Quickfix navigation
map("n", "[q", function()
  local ok, err = pcall(vim.cmd.cprev)
  if not ok then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Previous Quickfix Item" })

map("n", "]q", function()
  local ok, err = pcall(vim.cmd.cnext)
  if not ok then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Next Quickfix Item" })

-- Focus largest window to quickly go back to main editing window
vim.keymap.set("n", "<leader>wi", function()
  local largest_win, largest_area = nil, 0

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == "" then
      local area = vim.api.nvim_win_get_width(win) * vim.api.nvim_win_get_height(win)
      if area > largest_area then
        largest_area, largest_win = area, win
      end
    end
  end

  if largest_win then
    vim.api.nvim_set_current_win(largest_win)
  end
end, { desc = "Focus largest window" })

-- Easier system yank
map({ "n", "v" }, "<C-y>", function()
  vim.fn.feedkeys('"+y')
end, { desc = "Yank to system clipboard" })
