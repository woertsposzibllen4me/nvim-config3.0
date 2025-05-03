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

-- Better, floating, command line window
vim.api.nvim_create_autocmd("CmdwinEnter", {
  pattern = "*",
  callback = function()
    -- Allow quitting cmdline window with q
    vim.api.nvim_buf_set_keymap(0, "n", "q", ":q<CR>", { noremap = true })
    -- Configure window to be floating
    local win_id = vim.api.nvim_get_current_win()
    local width = 90
    vim.api.nvim_win_set_config(win_id, {
      relative = "editor",
      width = width,
      height = 15,
      col = math.floor((vim.o.columns - width) / 2 - 1),
      row = math.floor(vim.o.lines * 0.55),
      border = "rounded",
      title = " Cmdline ",
      title_pos = "center",
    })
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

-- Automatically switch to the help window when opening help files to the right and allow quitting with q
-- Needs some extra considerations to avoid bugging out with snacks buffer-grep
_G.processed_help_buffers = _G.processed_help_buffers or {}

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.txt", "*.md" },
  callback = function(args)
    local bufnr = args.buf
    -- Only process help buffers we haven't seen before
    if vim.bo[bufnr].buftype == "help" and not _G.processed_help_buffers[bufnr] then
      vim.cmd("wincmd L")
      vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":q<CR>", { noremap = true })
      -- Mark this buffer as processed
      _G.processed_help_buffers[bufnr] = true

      -- Set up cleanup when buffer is deleted
      vim.api.nvim_create_autocmd("BufDelete", {
        buffer = bufnr,
        callback = function()
          -- Remove from our tracking table when buffer is deleted
          _G.processed_help_buffers[bufnr] = nil
        end,
        once = true, -- This autocmd can be one-time since it's specific to this buffer
      })
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

-- Ensure it is enabled and activates highlighting of spelling errors.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- vim.opt.spell = true
    vim.opt.spelllang = "en"

    vim.api.nvim_set_hl(0, "SpellBad", {
      underline = true,
      fg = "#ff5555", -- light red
    })

    vim.api.nvim_set_hl(0, "SpellCap", {
      underline = true,
      fg = "#8be9fd", -- light blue
    })

    vim.api.nvim_set_hl(0, "SpellRare", {
      underline = true,
      fg = "#f1fa8c", -- light yellow
    })

    vim.api.nvim_set_hl(0, "SpellLocal", {
      underline = true,
      fg = "#bd93f9", -- light purple
    })
  end,
})

-- Send out a name for the wezterm tab through OSC sequence
vim.api.nvim_create_autocmd({ "BufEnter", "DirChanged" }, {
  callback = function()
    local filename = vim.fn.expand("%:t")
    if filename == "" then
      filename = "[No Name]"
    end
    local title = string.format(" nvim - %s ", filename)
    vim.opt.title = true
    vim.opt.titlestring = title
    vim.cmd("redraw")
  end,
})

-- Toggle matchparen in insert mode  TODO: check copilot upstream for bugfix
vim.api.nvim_create_augroup("matchparen_insert_mode_toggle", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
  group = "matchparen_insert_mode_toggle",
  callback = function()
    vim.cmd("NoMatchParen")
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = "matchparen_insert_mode_toggle",
  callback = function()
    vim.cmd("DoMatchParen")
  end,
})

-- Git commit message configuration
vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.textwidth = 72
    vim.opt_local.colorcolumn = "50,72"
  end,
})
