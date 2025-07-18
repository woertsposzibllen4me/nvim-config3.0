local M = {}

local create_return_action = function(current_win, cursor_pos)
  return function(picker)
    picker:close()
    vim.api.nvim_set_current_win(current_win)
    vim.api.nvim_win_set_cursor(current_win, cursor_pos)
  end
end

-- Wrapper function to launch any picker with return-to-explorer capability
local launch_picker_with_return = function(picker_fn, config)
  local current_win = vim.api.nvim_get_current_win()
  local cursor_pos = vim.api.nvim_win_get_cursor(current_win)

  vim.schedule(function()
    -- Fix a visual bug that happens if we run another Snacks picker while having the Snacks
    -- explorer in focus right before their launch.
    vim.cmd("wincmd p")

    -- Merge the return action into the config
    config.actions = config.actions or {}
    config.actions.return_to_explorer = create_return_action(current_win, cursor_pos)

    -- Add "return with explorer in focus" escape key mapping
    config.win = config.win or {}
    config.win.input = config.win.input or {}
    config.win.input.keys = config.win.input.keys or {}
    if not config.win.input.keys["<esc>"] then
      config.win.input.keys["<esc>"] = "return_to_explorer"
    end

    picker_fn(config)
  end)
end

M.grep_for_filename = function(picker, item)
  if not item or not item.file then
    return
  end

  local filename = vim.fn.fnamemodify(item.file, ":t:r")

  launch_picker_with_return(Snacks.picker.grep_word, {
    title = "Grep for: " .. filename,
    search = filename,
    cwd = picker:cwd(),
  })
end

M.grep_for_filename_with_ext = function(picker, item)
  if not item or not item.file then
    return
  end
  local filename = vim.fn.fnamemodify(item.file, ":t")

  launch_picker_with_return(Snacks.picker.grep_word, {
    title = "Grep for: " .. filename,
    search = filename,
    cwd = picker:cwd(),
  })
end

M.grep_in_dir = function(picker, item, opts)
  if not item or not item.file then
    return
  end

  local path
  if vim.fn.isdirectory(item.file) == 1 then
    path = item.file
  else
    path = vim.fn.fnamemodify(item.file, ":h")
  end

  local title = "Grep in: " .. vim.fn.fnamemodify(path, ":~:.")
  local dirs = { path }

  local config = {
    title = title,
    dirs = dirs,
    win = {
      input = {
        keys = require("modules.snacks.picker.keys.setup-all-keys").setup_grep_input_keys(dirs, title),
      },
    },
  }

  if opts and opts.default_grep == true then
    config.finder = "grep" -- override our default finder (egrep rn)
  end

  launch_picker_with_return(Snacks.picker.grep, config)
end

M.search_files_in_dir = function(picker, item)
  if not item or not item.file then
    return
  end
  local path
  if vim.fn.isdirectory(item.file) == 1 then
    path = item.file
  else
    path = vim.fn.fnamemodify(item.file, ":h")
  end
  local title = "Search files in: " .. vim.fn.fnamemodify(path, ":~:.")
  local dirs = { path }

  launch_picker_with_return(Snacks.picker.files, {
    title = title,
    dirs = dirs,
  })
end

local focus_right_win = function()
  vim.cmd("stopinsert")
  vim.cmd("wincmd l")
  -- if we are still in the Snacks picker list, go right again
  vim.schedule(function()
    if vim.bo.filetype == "snacks_picker_list" then
      vim.cmd("wincmd l")
    end
  end)
end

return {
  actions = {
    grep_filename = M.grep_for_filename,
    grep_full_filename = M.grep_for_filename_with_ext,
    grep_in_dir = M.grep_in_dir,
    grep_in_dir_default = function(picker, item)
      return M.grep_in_dir(picker, item, { default_grep = true })
    end,
    search_files_in_dir = M.search_files_in_dir,
    focus_right_win = focus_right_win,
  },
  win = {
    list = {
      keys = {
        ["gf"] = { "grep_filename", desc = "Grep fname" },
        ["gF"] = { "grep_full_filename", desc = "Grep fname + .ext" },
        ["gd"] = { "grep_in_dir", desc = "Grep in dir" },
        ["gD"] = { "grep_in_dir_default", desc = "Grep in dir (default)" },
        ["fd"] = { "search_files_in_dir", desc = "Search files in dir" },
        ["<c-j>"] = false,
        ["<c-k>"] = false,
        ["<esc>"] = {
          function()
            vim.cmd("wincmd p")
          end,
          desc = "Exit to prev window",
        },
      },
    },
    input = {
      keys = {
        ["gf"] = { "grep_filename", desc = "Grep fname" },
        ["gF"] = { "grep_full_filename", desc = "Grep fname + .ext" },
        ["gd"] = { "grep_in_dir", desc = "Grep in dir" },
        ["gD"] = { "grep_in_dir_default", desc = "Grep in dir (default)" },
        ["fd"] = { "search_files_in_dir", desc = "Search files in dir" },
        ["<esc>"] = {
          function()
            vim.cmd("wincmd p")
          end,
          desc = "Exit to prev window",
        },
        ["<c-l>"] = { "focus_right_win", desc = "Focus right window", mode = { "i", "n" } },
      },
    },
  },
}
