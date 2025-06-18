local M = {}
M.filter_recent = {
  cwd = true,
  filter = function(item, _)
    -- Skip if no file path
    if not item.file then
      return true
    end

    -- Paths to exclude
    local exclude_patterns = {
      -- Undo directory
      vim.fn.stdpath("state") .. "/undo",
      -- Git commit message files
      "%.git/COMMIT_EDITMSG$",
      "%.git/MERGE_MSG$",
      "/COMMIT_EDITMSG$",
      "/MERGE_MSG$",
    }

    for _, pattern in ipairs(exclude_patterns) do
      if item.file:match(pattern) then
        return false
      end
    end

    return true
  end,
}
return M
