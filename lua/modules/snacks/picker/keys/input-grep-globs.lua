local M = {}

local function reposition_input_buffer()
  -- Find and reposition the dressing input window
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local filetype = vim.bo[buf].filetype

    if filetype == "DressingInput" then
      local editor_width = vim.o.columns
      local editor_height = vim.o.lines
      local win_config = vim.api.nvim_win_get_config(win)
      -- Set dressing width to at least 70, but not more than editor width
      local win_width = math.min(70, editor_width - 4)
      local win_height = win_config.height

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
        zindex = 1000, -- Ensure it appears above other windows
      })

      -- Disable blink in input buffer
      vim.b[buf].completion = false

      -- Start insert mode if the buffer is empty
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local is_empty = #lines == 0 or (#lines == 1 and lines[1] == "")

      if is_empty then
        vim.cmd("startinsert")
      end
      break
    end
    vim.notify("No DressingInput window found", vim.log.levels.WARN, { title = "grep-globs-input" })
  end
end

---@param dirs? table<string> the particular directories the grep might be happening in
---@param title? string the currently set, non-default, title of the picker
M.setup_grep_globs_input = function(dirs, title)
  return {
    function(picker)
      local current_search = vim.api.nvim_buf_get_lines(0, 0, -1, false)[1] or ""
      local last_patterns = vim.g.snacks_multigrep_patterns or ""
      local setup_all_keys = require("modules.snacks.picker.keys.setup-all-keys")

      picker:close()

      vim.ui.input({
        prompt = "File patterns (comma-separated, e.g., *.lua,*.py,src/**,*/dir/*): ",
        default = last_patterns,
      }, function(input)
        if not input then
          -- User cancelled, restart picker without patterns
          local config_wo_glob = { search = current_search }
          if dirs then
            config_wo_glob.dirs = dirs
          end
          if title then
            config_wo_glob.title = title
          end

          config_wo_glob.win = {
            input = {
              keys = setup_all_keys.setup_grep_input_keys(dirs, title),
            },
          }

          vim.schedule(function()
            Snacks.picker.grep(config_wo_glob)
          end)
          return
        end

        local patterns = {}
        for pattern in input:gmatch("([^,]+)") do
          table.insert(patterns, vim.trim(pattern))
        end
        vim.g.snacks_multigrep_patterns = table.concat(patterns, ",")

        -- Create grep options with conditional title
        local config_w_globs = {
          search = current_search,
          glob = patterns,
        }
        if dirs then
          config_w_globs.dirs = dirs
        end

        if #patterns > 0 then
          local glob_suffix = " (" .. table.concat(patterns, ", ") .. ")"
          config_w_globs.title = (title or "Grep") .. glob_suffix
        else
          config_w_globs.title = title
        end

        config_w_globs.win = {
          input = {
            keys = setup_all_keys.setup_grep_input_keys(dirs, title),
          },
        }

        vim.schedule(function()
          Snacks.picker.grep(config_w_globs)
        end)
      end)
      vim.schedule(function()
        if pcall(require, "dressing") then
          reposition_input_buffer()
        end
      end)
    end,
    mode = { "n", "i" },
    desc = "Filter by file pattern(s)",
  }
end
return M
