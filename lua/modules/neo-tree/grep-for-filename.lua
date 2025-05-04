local M = {}

-- Function to grep for the current node's filename in cwd
M.grep_for_filename = function(state)
  local node = state.tree:get_node()
  if not node then
    return
  end

  local filename = vim.fn.fnamemodify(node:get_id(), ":t:r")

  -- Use Snacks grep picker for the filename in cwd
  Snacks.picker.grep_word({
    title = "Grep for: " .. filename,
    search = filename,
  })
end

return M
