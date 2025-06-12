-- Snacks Explorer: Grep for filename functionality
local M = {}

-- Function to grep for the current item's filename in cwd
M.grep_for_filename = function(picker, item)
  if not item or not item.file then
    return
  end

  -- Extract just the filename without path and extension
  local filename = vim.fn.fnamemodify(item.file, ":t:r")

  -- Close the current explorer picker
  picker:close()

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

  picker:close()

  vim.schedule(function()
    Snacks.picker.grep_word({
      title = "Grep for: " .. filename,
      search = filename,
      cwd = picker:cwd(),
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
      },
      win = {
        list = {
          keys = {
            ["gf"] = { "grep_filename", desc = "Grep for filename" },
            ["gF"] = { "grep_full_filename", desc = "Grep for filename with .ext" },
          },
        },
      },
    },
  }
end
return M
