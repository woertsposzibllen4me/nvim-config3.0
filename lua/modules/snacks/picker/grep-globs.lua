local M = {}

local function reposition_dressing()
  -- Find and reposition the dressing input window
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local filetype = vim.bo[buf].filetype

    if filetype == "DressingInput" then
      local editor_width = vim.o.columns
      local editor_height = vim.o.lines
      local win_width = vim.api.nvim_win_get_config(win).width
      local win_height = vim.api.nvim_win_get_config(win).height

      -- Calculate center position
      local row = math.floor((editor_height - win_height) / 2)
      local col = math.floor((editor_width - win_width) / 2)

      -- Reposition the window
      vim.api.nvim_win_set_config(win, {
        relative = "editor",
        row = row,
        col = col,
        width = win_width,
        height = win_height,
      })
      break
    end
  end
end

M.setup_grep_with_globs = function()
  return {
    finder = "grep",
    regex = true,
    format = "file",
    show_empty = true,
    live = true,
    supports_live = true,
    layout = "grep_vertical",
    win = {
      input = {
        keys = {
          ["<F2>"] = {
            function(picker)
              local current_search = vim.api.nvim_buf_get_lines(0, 0, -1, false)[1] or ""

              -- Get the last used patterns from vim global variable (more stable)
              local last_patterns = vim.g.snacks_multigrep_patterns or "*.glob"

              picker:close()

              -- Remove vim.schedule and call directly
              vim.ui.input({
                prompt = "File patterns (comma-separated, e.g., *.lua,*.js,*.py): ",
                default = last_patterns,
              }, function(input)
                if input and input ~= "" then
                  local patterns = {}
                  for pattern in input:gmatch("([^,]+)") do
                    table.insert(patterns, vim.trim(pattern))
                  end
                  vim.g.snacks_multigrep_patterns = table.concat(patterns, ",")
                  vim.schedule(function()
                    Snacks.picker.grep({
                      search = current_search,
                      glob = patterns,
                      title = "Grep (" .. table.concat(patterns, ", ") .. ")",
                    })
                  end)
                end
              end)

              vim.schedule(function()
                local has_dressing, _ = pcall(require, "dressing")
                if has_dressing then
                  reposition_dressing()
                end
              end)
            end,
            mode = { "n", "i" },
            desc = "Filter by file pattern(s)",
          },
        },
      },
    },
  }
end
return M
