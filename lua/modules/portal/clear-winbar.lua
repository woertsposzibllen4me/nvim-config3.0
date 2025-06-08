local M = {}

-- Create or get the debug log buffer
local debug_buf = nil
local function get_debug_buffer()
  if not debug_buf or not vim.api.nvim_buf_is_valid(debug_buf) then
    debug_buf = vim.api.nvim_create_buf(false, true) -- not listed, scratch buffer
    vim.api.nvim_buf_set_name(debug_buf, "Portal Debug Log")
    vim.api.nvim_set_option_value("buftype", "nofile", { buf = debug_buf })
    vim.api.nvim_set_option_value("bufhidden", "hide", { buf = debug_buf })
    vim.api.nvim_set_option_value("swapfile", false, { buf = debug_buf })
    vim.api.nvim_set_option_value("modifiable", true, { buf = debug_buf })
  end
  return debug_buf
end

-- Log message to scratch buffer instead of print
local function debug_log(message)
  local buf = get_debug_buffer()
  local timestamp = os.date("[%H:%M:%S] ")
  local log_line = timestamp .. tostring(message)

  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  table.insert(lines, log_line)

  if #lines > 1000 then
    lines = vim.list_slice(lines, #lines - 999, #lines)
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

-- Function to open the debug log in a split window
M.show_debug_log = function()
  local buf = get_debug_buffer()
  vim.cmd("split")
  vim.api.nvim_win_set_buf(0, buf)
  vim.cmd("normal! G")
end

---@param debug? "debug" Enable debug logging
M.setup_clear_portal_winbar = function(debug)
  local check_interval = 5
  local current_windows = vim.api.nvim_list_wins()
  local current_window_count = #current_windows

  if debug then
    debug_log("=== Portal Winbar Debug - Initial State ===")
    debug_log("Initial window count: " .. current_window_count)
    debug_log("Initial windows: " .. vim.inspect(current_windows))
    vim.keymap.set("n", "<leader>-d", M.show_debug_log, {
      desc = "Open Portal Debug Log",
      silent = true,
    })
    for _, win in ipairs(current_windows) do
      local buf = vim.api.nvim_win_get_buf(win)
      local buf_name = vim.api.nvim_buf_get_name(buf)
      local winbar = vim.api.nvim_get_option_value("winbar", { win = win })
      debug_log(
        string.format("  Window %d: %s (winbar: '%s')", win, buf_name ~= "" and buf_name or "[No Name]", winbar)
      )
    end
  end

  local function check_and_clear_winbar(attempt)
    attempt = attempt or 1
    local new_windows = vim.api.nvim_list_wins()
    local new_window_count = #new_windows

    if debug then
      debug_log(string.format("= Portal Winbar Debug - Attempt %d =", attempt))
      debug_log("Current window count: " .. new_window_count)
      debug_log("Expected count: " .. current_window_count)
      debug_log("New windows: " .. vim.inspect(new_windows))
    end

    -- If new windows were created, clear their winbars
    if new_window_count > current_window_count then
      if debug then
        debug_log("New windows detected! Processing...")
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
            debug_log(
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
            debug_log(
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
        debug_log("= Portal Winbar Debug - Complete =")
      end
    else
      if debug then
        debug_log("No new windows yet, checking again...")
      end

      if attempt * check_interval < 3000 then -- Max 3 seconds
        vim.defer_fn(function()
          check_and_clear_winbar(attempt + 1)
        end, check_interval)
      else
        if debug then
          debug_log("= Portal Winbar Debug - TIMEOUT =")
          debug_log("Gave up waiting for new windows after 3 seconds")
        end
      end
    end
  end

  vim.defer_fn(check_and_clear_winbar, check_interval)
end

return M
