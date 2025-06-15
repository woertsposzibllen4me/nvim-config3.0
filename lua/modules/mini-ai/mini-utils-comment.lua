-- In your mini-utils-comment.lua file
local M = {}

function M.ai_comment(ai_type)
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  -- Find the start and end of consecutive comment lines
  local start_line = cursor_line
  local end_line = cursor_line

  -- Go up to find start of comment block
  while start_line > 1 and lines[start_line - 1]:match("^%s*%-%-") do
    start_line = start_line - 1
  end

  -- Go down to find end of comment block
  while end_line < #lines and lines[end_line]:match("^%s*%-%-") do
    end_line = end_line + 1
  end
  end_line = end_line - 1 -- Adjust back to last comment line

  -- Return empty if cursor is not on a comment line
  if not lines[cursor_line]:match("^%s*%-%-") then
    return { from = { line = cursor_line, col = 1 } }
  end

  local from_col = ai_type == "a" and 1 or (lines[start_line]:find("%S") or 1)
  local to_col = ai_type == "a" and #lines[end_line] or lines[end_line]:len()

  return {
    from = { line = start_line, col = from_col },
    to = { line = end_line, col = to_col },
  }
end

return M
