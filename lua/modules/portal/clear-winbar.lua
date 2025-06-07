local M = {}

---@param debug? "debug" Enable debug logging
M.setup_clear_portal_winbar = function(debug)
  -- If some windows get their winbar cleared but others don't, it might be worthwhile to
  -- try to increase the check interval to give more time for all portal preview windows to be created.
  local check_interval = 5
  local current_windows = vim.api.nvim_list_wins()
  local current_window_count = #current_windows

  if debug then
    print("=== Portal Winbar Debug - Initial State ===")
    print("Initial window count:", current_window_count)
    print("Initial windows:", vim.inspect(current_windows))
    for _, win in ipairs(current_windows) do
      local buf = vim.api.nvim_win_get_buf(win)
      local buf_name = vim.api.nvim_buf_get_name(buf)
      local winbar = vim.api.nvim_get_option_value("winbar", { win = win })
      print(string.format("  Window %d: %s (winbar: '%s')", win, buf_name ~= "" and buf_name or "[No Name]", winbar))
    end
  end

  local function check_and_clear_winbar(attempt)
    attempt = attempt or 1
    local new_windows = vim.api.nvim_list_wins()
    local new_window_count = #new_windows

    if debug then
      print(string.format("= Portal Winbar Debug - Attempt %d =", attempt))
      print("Current window count:", new_window_count)
      print("Expected count:", current_window_count)
      print("New windows:", vim.inspect(new_windows))
    end

    -- If new windows were created, clear their winbars
    if new_window_count > current_window_count then
      if debug then
        print("New windows detected! Processing...")
      end

      for _, win in ipairs(new_windows) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        local winbar_before = vim.api.nvim_get_option_value("winbar", { win = win })
        local skip_window = false
        for _, existing_win in ipairs(current_windows) do
          if win == existing_win then
            skip_window = true
            break
          end
        end
        if not skip_window then
          vim.api.nvim_set_option_value("winbar", "", { win = win })
          if debug then
            local winbar_after = vim.api.nvim_get_option_value("winbar", { win = win })
            print(
              string.format(
                "  CLEARED Window %d: %s (winbar: '%s' -> '%s')",
                win,
                buf_name ~= "" and buf_name or "[No Name]",
                winbar_before,
                winbar_after
              )
            )
          end
        else
          if debug then
            print(
              string.format(
                "  SKIPPED Window %d: %s (winbar: '%s')",
                win,
                buf_name ~= "" and buf_name or "[No Name]",
                winbar_before
              )
            )
          end
        end
      end

      if debug then
        print("= Portal Winbar Debug - Complete =")
      end
    else
      if debug then
        print("No new windows yet, checking again...")
      end

      if attempt * check_interval < 3000 then -- Max 3 seconds
        vim.defer_fn(function()
          check_and_clear_winbar(attempt + 1)
        end, check_interval)
      else
        if debug then
          print("= Portal Winbar Debug - TIMEOUT =")
          print("Gave up waiting for new windows after 3 seconds")
        end
      end
    end
  end

  vim.defer_fn(check_and_clear_winbar, check_interval)
end

return M
