local M = {}
M.print_wins_and_bufs = function()
  print("=== BUFFERS ===")
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local name = vim.api.nvim_buf_get_name(buf)
      local filetype = vim.bo[buf].filetype
      local buftype = vim.bo[buf].buftype
      print(string.format("Buf %d: name='%s', ft='%s', bt='%s'", buf, name, filetype, buftype))
    end
  end
  print("\n=== WINDOWS ===")
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local config = vim.api.nvim_win_get_config(win)
    local filetype = vim.bo[buf].filetype
    local buftype = vim.bo[buf].buftype
    print(
      string.format(
        "Win %d: buf=%d, ft='%s', bt='%s', relative='%s'",
        win,
        buf,
        filetype,
        buftype,
        config.relative or "none"
      )
    )
    if config.relative ~= "" then
      print(
        string.format(
          "  Position: row=%s, col=%s, width=%s, height=%s",
          config.row or "?",
          config.col or "?",
          config.width or "?",
          config.height or "?"
        )
      )
    end
  end
end
return M
