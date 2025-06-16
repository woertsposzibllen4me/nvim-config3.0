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

  vim.schedule(function()
    focus_large_win.focus()
    Snacks.picker.grep({
      title = title,
      dirs = { path },
      live = true,
      regex = true,
      format = "file",
      show_empty = true,
    })
  end)
end

M.setup_explorer_grep = function()
  return {
    explorer = {
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
          },
        },
      },
    },
  }
end

return M
