local M = {}

-- Used to fix focus bug that happens if we run pickers while having the Snacks Explorer in focus
local focus_large_win = require("scripts.ui.focus-largest-window")

M.grep_for_filename = function(picker, item)
  if not item or not item.file then
    return
  end
  -- Extract just the filename without path and extension
  local filename = vim.fn.fnamemodify(item.file, ":t:r")
  vim.schedule(function()
    focus_large_win.focus()
    Snacks.picker.grep_word({
      title = "Grep for: " .. filename,
      search = filename,
      cwd = picker:cwd(), -- Use the same cwd as the explorer
    })
  end)
end

M.grep_for_full_filename = function(picker, item)
  if not item or not item.file then
    return
  end
  -- Extract filename with extension
  local filename = vim.fn.fnamemodify(item.file, ":t")
  vim.schedule(function()
    focus_large_win.focus()
    Snacks.picker.grep_word({
      title = "Grep for: " .. filename,
      search = filename,
      cwd = picker:cwd(),
    })
  end)
end

M.grep_in_dir = function(picker, item)
  if not item or not item.file then
    return
  end

  local path
  if vim.fn.isdirectory(item.file) == 1 then
    path = item.file
  else
    path = vim.fn.fnamemodify(item.file, ":h")
  end

  local title = "Grep in: " .. vim.fn.fnamemodify(path, ":~:.")
  local dirs = { path }

  vim.schedule(function()
    focus_large_win.focus()
    local grep_config = require("modules.snacks.picker.grep-globs").setup_grep_with_globs(dirs, title)

    -- Add the directory-specific options
    local extended_config = vim.tbl_deep_extend("force", grep_config, {
      title = title,
      dirs = dirs,
    })

    Snacks.picker.grep(extended_config)
  end)
end

return {
  actions = {
    grep_filename = M.grep_for_filename,
    grep_full_filename = M.grep_for_full_filename,
    grep_in_dir = M.grep_in_dir,
  },
  win = {
    list = {
      keys = {
        ["gf"] = { "grep_filename", desc = "Grep fname" },
        ["gF"] = { "grep_full_filename", desc = "Grep fname + .ext" },
        ["gd"] = { "grep_in_dir", desc = "Grep in dir" },
        ["<c-j>"] = false,
        ["<c-k>"] = false,
        ["<esc>"] = {
          function()
            vim.cmd("wincmd l")
          end,
          desc = "Swap to right window", -- it looks like, because explorer is a float, going to the
          -- right window actually just goes to the last window used, which is pretty handy
        },
      },
    },
    input = {
      keys = {
        ["<esc>"] = {
          function()
            vim.cmd("wincmd l")
          end,
          desc = "Swap to right window",
        },
      },
    },
  },
}
