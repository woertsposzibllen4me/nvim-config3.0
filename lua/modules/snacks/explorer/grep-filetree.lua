-- Snacks Explorer: Enhanced grep functionality
local M = {}

-- Function to grep for the current item's filename in cwd
M.grep_for_filename = function(picker, item)
  if not item or not item.file then
    return
  end
  -- Extract just the filename without path and extension
  local filename = vim.fn.fnamemodify(item.file, ":t:r")
  -- Open grep picker with the filename as search term
  vim.schedule(function()
    Snacks.picker.grep_word({
      title = "Grep for: " .. filename,
      search = filename,
      cwd = picker:cwd(), -- Use the same cwd as the explorer
    })
  end)
end

-- Function to grep for the full filename (with extension)
M.grep_for_full_filename = function(picker, item)
  if not item or not item.file then
    return
  end
  -- Extract filename with extension
  local filename = vim.fn.fnamemodify(item.file, ":t")
  vim.schedule(function()
    Snacks.picker.grep_word({
      title = "Grep for: " .. filename,
      search = filename,
      cwd = picker:cwd(),
    })
  end)
end

-- Function to grep inside the current directory or parent directory of a file
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

-- Configuration to add these actions to the explorer
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
