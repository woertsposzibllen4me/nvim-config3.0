-- remove automatic comment insertion
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

-- Center cursor after search using Enter
vim.api.nvim_create_autocmd("CmdlineEnter", {
  callback = function()
    vim.keymap.set("c", "<CR>", function()
      if vim.fn.getcmdtype() == "/" or vim.fn.getcmdtype() == "?" then
        return "<CR>zz"
      end
      return "<CR>"
    end, { expr = true, buffer = true })
  end,
})

-- Allow quitting command line windows with q
vim.api.nvim_create_autocmd("CmdwinEnter", {
  pattern = "*",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "q", ":q<CR>", { noremap = true })
  end,
})

-- Disable cursorline in diff mode
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    if vim.wo.diff then
      -- This code runs when entering a window in diff mode
      local wins = vim.api.nvim_tabpage_list_wins(0)
      for _, win in ipairs(wins) do
        vim.cmd("set nowrap")
        vim.wo[win].cursorline = false
        vim.wo[win].culopt = "number"
      end
    end
  end,
})

-- automatically switch to the help window when opening help files to the right
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.txt", "*.md" },
  callback = function()
    if vim.bo.buftype == "help" then
      vim.cmd("wincmd L")
    end
  end,
})

-- Set textwidth to 88 for Python files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.bo.textwidth = 88 -- Set textwidth to 88 for Python files (matching Black's default)
  end,
})
