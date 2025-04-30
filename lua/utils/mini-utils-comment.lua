local M = {}

-- Text object for commented code blocks
-- For "a", it will include blank lines surrounding the comment block
-- "a" is line-wise, "i" is character-wise (only the commented text)
function M.ai_comment(ai_type)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local comment_blocks = {} ---@type {from: {line: number, col: number}, to: {line: number, col: number}}[]

  local in_block = false
  local block_start = 0
  local block_end = 0

  -- Find all comment blocks
  for l, line in ipairs(lines) do
    local is_comment = line:match("^%s*%-%-")

    if is_comment and not in_block then
      -- Start of a new comment block
      in_block = true
      block_start = l
    elseif not is_comment and in_block then
      -- End of comment block
      in_block = false
      block_end = l - 1

      -- Add this block to our collection
      comment_blocks[#comment_blocks + 1] = {
        from = { line = block_start, col = 1 },
        to = { line = block_end, col = #lines[block_end] },
      }
    end
  end

  -- Handle case where the file ends with a comment block
  if in_block then
    comment_blocks[#comment_blocks + 1] = {
      from = { line = block_start, col = 1 },
      to = { line = #lines, col = #lines[#lines] },
    }
  end

  -- Expand "a" textobject to include surrounding blank lines
  if ai_type == "a" then
    for i, block in ipairs(comment_blocks) do
      -- Check for blank line before block and include it
      local start_line = block.from.line
      while start_line > 1 and lines[start_line - 1]:match("^%s*$") do
        start_line = start_line - 1
      end

      -- Check for blank line after block and include it
      local end_line = block.to.line
      while end_line < #lines and lines[end_line + 1]:match("^%s*$") do
        end_line = end_line + 1
      end

      block.from.line = start_line
      block.to.line = end_line
      block.to.col = #lines[end_line]
    end
  end

  -- Find which block the cursor is in
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_line = cursor[1]

  for _, block in ipairs(comment_blocks) do
    if cursor_line >= block.from.line and cursor_line <= block.to.line then
      -- For "i" textobject, adjust columns to exclude comment markers
      if ai_type == "i" then
        for l = block.from.line, block.to.line do
          local line = lines[l]
          local comment_text = line:match("^(%s*%-%-+)%s?(.*)$")
          if comment_text then
            local marker_len = #comment_text
            if l == block.from.line then
              block.from.col = marker_len + 1
            end
          end
        end
      end

      return block
    end
  end

  -- If no block is found containing cursor, return nil
  return nil
end

return M
