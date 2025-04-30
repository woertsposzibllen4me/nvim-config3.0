local M = {}

-- Text object for commented code blocks
-- Uses Treesitter for comment detection
-- For "a", it will include blank lines surrounding the comment block
-- "a" is line-wise, "i" is character-wise (only the commented text)
function M.ai_comment(ai_type)
  -- Ensure Treesitter is available
  if not vim.treesitter then
    vim.notify("Treesitter not available", vim.log.levels.ERROR)
    return nil
  end

  -- Get the current buffer and cursor position
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_row, cursor_col = cursor[1], cursor[2]

  -- Get language and parser
  local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
  local parser = vim.treesitter.get_parser(bufnr, lang)
  local tree = parser:parse()[1]
  local root = tree:root()

  -- Find all comment nodes
  local comment_nodes = {}
  local query = vim.treesitter.query.parse(
    lang,
    [[
    (comment) @comment
  ]]
  )

  if not query then
    vim.notify("No comment query available for " .. lang, vim.log.levels.WARN)
    return nil
  end

  for id, node in query:iter_captures(root, bufnr, 0, -1) do
    if query.captures[id] == "comment" then
      table.insert(comment_nodes, node)
    end
  end

  if #comment_nodes == 0 then
    return nil
  end

  -- Find consecutive comment nodes to form blocks
  local comment_blocks = {}
  local current_block = nil
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Helper function to get a node's range
  local function get_node_range(node)
    local start_row, start_col, end_row, end_col = node:range()
    return {
      from = { line = start_row + 1, col = start_col + 1 },
      to = { line = end_row + 1, col = end_col + 1 },
    }
  end

  -- Helper function to check if a node is on the next line of another node
  local function is_consecutive(node1, node2)
    local _, _, end_row1, _ = node1:range()
    local start_row2, _, _, _ = node2:range()
    return start_row2 == end_row1 + 1
  end

  -- Group consecutive comment nodes into blocks
  for i, node in ipairs(comment_nodes) do
    local range = get_node_range(node)

    if not current_block then
      current_block = {
        from = { line = range.from.line, col = range.from.col },
        to = { line = range.to.line, col = range.to.col },
        nodes = { node },
      }
    elseif is_consecutive(comment_nodes[i - 1], node) then
      -- Extend current block
      current_block.to = { line = range.to.line, col = range.to.col }
      table.insert(current_block.nodes, node)
    else
      -- Start a new block
      table.insert(comment_blocks, current_block)
      current_block = {
        from = { line = range.from.line, col = range.from.col },
        to = { line = range.to.line, col = range.to.col },
        nodes = { node },
      }
    end
  end

  -- Add the last block if it exists
  if current_block then
    table.insert(comment_blocks, current_block)
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
      block.to.col = lines[end_line] and #lines[end_line] or 0
    end
  end

  -- Find which block the cursor is in
  for _, block in ipairs(comment_blocks) do
    if
      (cursor_row >= block.from.line and cursor_row <= block.to.line)
      and (cursor_row > block.from.line or cursor_col >= block.from.col - 1)
      and (cursor_row < block.to.line or cursor_col <= block.to.col - 1)
    then
      -- For "i" textobject, use the exact comment text without comment marker
      if ai_type == "i" then
        -- Use treesitter to get the actual text content excluding comment markers
        local first_node = block.nodes[1]
        local last_node = block.nodes[#block.nodes]

        -- Get the text of the first node
        local start_row, start_col, _, _ = first_node:range()
        local text = vim.treesitter.get_node_text(first_node, bufnr)

        -- Try to find the beginning of the actual comment text after the marker
        local comment_start = text:match("^([%-%/%*%s]+)")
        if comment_start then
          block.from.col = start_col + #comment_start + 1
        end
      end

      return block
    end
  end

  -- If no block is found containing cursor, return nil
  return nil
end

return M
