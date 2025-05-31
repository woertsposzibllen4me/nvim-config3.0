local function custom_on_list(options)
  local unique_items = {}
  local seen_rows = {}

  for _, item in ipairs(options.items) do
    local filename = item.filename or vim.fn.bufname(item.bufnr)
    -- Get just the filename tail (basename)
    local basename = vim.fn.fnamemodify(filename, ":t")
    local lnum = item.lnum

    -- Use basename in the key instead of full path
    local row_key = basename .. ":" .. lnum
    print("row_key", row_key)

    if not seen_rows[row_key] then
      seen_rows[row_key] = true
      table.insert(unique_items, item)
    end
  end

  options.items = unique_items
  vim.fn.setqflist({}, " ", options)

  if #unique_items == 1 then
    vim.cmd.cfirst()
  elseif #unique_items > 1 then
    vim.cmd.copen()
  end
end

local function quick_references()
  vim.lsp.buf.references(nil, {
    on_list = function(opts)
      -- tag the list so bqf’s should_preview_cb can recognise it
      opts.title = "bqf-nopreview"
      vim.fn.setqflist({}, " ", opts) -- populate qf *with* new title
      vim.cmd("copen")

      local qf_buf = vim.api.nvim_get_current_buf()
      local map = function(lhs, rhs)
        vim.keymap.set("n", lhs, rhs, { buffer = qf_buf, silent = true })
      end
      map("j", "j<CR>zz<C-W>p")
      map("k", "k<CR>zz<C-W>p")
    end,
  })
end

vim.keymap.set("n", "K", function()
  vim.lsp.buf.hover({ border = "rounded" })
end, { desc = "Lsp Hover Info" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol under cursor" })
vim.keymap.set("n", "gR", quick_references, { desc = "References (quickfix)" })
vim.keymap.set("n", "gld", function()
  vim.lsp.buf.definition({ on_list = custom_on_list })
end, { desc = "Definitions " })
-- map("n", "gd", require("telescope.builtin").lsp_definitions, { desc = "Telescope Goto Definition" })
-- map("n", "gr", require("telescope.builtin").lsp_references, { desc = "Telescope Goto References" })
