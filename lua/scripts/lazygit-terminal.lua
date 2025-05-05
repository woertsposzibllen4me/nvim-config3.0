local M = {}
local lazygit_term = {
  buf = nil,
  win = nil,
}

local function notify_error(msg)
  vim.notify(msg, vim.log.levels.ERROR)
end

-- Function to create a floating terminal
function M.float_term(opts)
  opts = vim.tbl_deep_extend("force", {
    size = { width = 0.9, height = 0.9 },
  }, opts or {})
  local buf = vim.api.nvim_create_buf(false, true)
  local float = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = math.floor(vim.o.columns * opts.size.width),
    height = math.floor(vim.o.lines * opts.size.height),
    row = math.floor(vim.o.lines * (1 - opts.size.height) / 2),
    col = math.floor(vim.o.columns * (1 - opts.size.width) / 2),
    style = "minimal",
    border = "rounded",
  })

  -- Store in our global reference
  lazygit_term.buf = buf
  lazygit_term.win = float

  -- Fix Whichkey delay from waiting for bracket keys combinations
  vim.api.nvim_buf_set_keymap(buf, "t", "]", "]", { noremap = true, nowait = true })
  vim.api.nvim_buf_set_keymap(buf, "t", "[", "[", { noremap = true, nowait = true })

  -- Create terminal
  vim.fn.jobstart("lazygit", {
    cwd = opts.cwd,
    term = true,
    on_exit = function()
      vim.schedule(function()
        -- Check if the window still exists
        if vim.api.nvim_win_is_valid(lazygit_term.win) then
          vim.api.nvim_win_close(lazygit_term.win, true)
        end
        -- Force delete the buffer
        if vim.api.nvim_buf_is_valid(lazygit_term.buf) then
          vim.api.nvim_buf_delete(lazygit_term.buf, { force = true })
        end
        -- Refresh file and directory views
        vim.cmd("checktime")
        if package.loaded["neo-tree"] then
          pcall(function()
            require("neo-tree.sources.manager").refresh()
          end)
        end
        -- Clear our references
        lazygit_term.buf = nil
        lazygit_term.win = nil
      end)
    end,
  })
  vim.cmd("startinsert")
  return { buf = buf, win = float }
end

-- Function to check clipboard with retries
local function getRelativeFilepath(retries, delay)
  local relative_filepath
  for _ = 1, retries do
    relative_filepath = vim.fn.getreg("+")
    if relative_filepath ~= "" then
      return relative_filepath
    end
    vim.loop.sleep(delay)
  end
  return nil
end

-- Function to run Tinygit smart commit over the lazygit terminal
function M.run_tinygit_smartcommit()
  vim.cmd("Tinygit smartCommit")
  -- Set up a timer to check when Tinygit is done
  local check_timer = vim.loop.new_timer()
  check_timer:start(
    80,
    80,
    vim.schedule_wrap(function()
      -- Check if any of the gitcommit windows are still valid
      local gitcommit_windows_exist = false
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, "filetype") == "gitcommit" then
          gitcommit_windows_exist = true
          break
        end
      end
      if not gitcommit_windows_exist then
        -- Return focus to the terminal window if it's still valid
        if vim.api.nvim_win_is_valid(lazygit_term.win) then
          vim.api.nvim_set_current_win(lazygit_term.win)
          vim.cmd("startinsert")
        end
        check_timer:stop()
        check_timer:close()
      end
    end)
  )
end

-- Function to handle editing from Lazygit
function M.LazygitEdit(original_buffer)
  local current_bufnr = vim.fn.bufnr("%")
  local channel_id = vim.fn.getbufvar(current_bufnr, "terminal_job_id")
  if not channel_id then
    notify_error("No terminal job ID found.")
    return
  end
  vim.fn.chansend(channel_id, "\15") -- \15 is <c-o>
  vim.cmd("close")
  vim.cmd("checktime")
  local relative_filepath = getRelativeFilepath(5, 50)
  if not relative_filepath then
    notify_error("Clipboard is empty or invalid.")
    return
  end
  local winid = vim.fn.bufwinid(original_buffer)
  if winid == -1 then
    notify_error("Could not find the original window.")
    return
  end
  vim.fn.win_gotoid(winid)
  vim.cmd("e " .. relative_filepath)
end

-- Function to get git root directory
function M.get_git_root()
  local git_cmd = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  if git_cmd then
    local git_root = git_cmd:read("*l")
    git_cmd:close()
    return git_root
  end
  return vim.fn.getcwd()
end

-- Function to open Lazygit logs
function M.StartLazygitLogs()
  local term = M.float_term({ cwd = M.get_git_root() })
  return term
end

-- Function to start Lazygit in a floating terminal
function M.StartLazygit()
  local current_buffer = vim.api.nvim_get_current_buf()
  local float_term = M.float_term({ cwd = M.get_git_root() })

  -- Keybind to edit the file in the current nvim instance
  vim.api.nvim_buf_set_keymap(
    float_term.buf,
    "t",
    "<C-g>",
    string.format([[<Cmd>lua require('scripts.lazygit-terminal').LazygitEdit(%d)<CR>]], current_buffer),
    { noremap = true, silent = true }
  )

  -- Keybind to write a commit using Tinygit
  vim.api.nvim_buf_set_keymap(
    float_term.buf,
    "t",
    "<C-c>",
    [[<C-\><C-n>:lua RunTinygitSmartCommit()<CR>]],
    { noremap = true, silent = true }
  )
  return float_term
end

-- Make specific functions available globally
_G.StartLazygitLogs = M.StartLazygitLogs
_G.StartLazygit = M.StartLazygit
_G.RunTinygitSmartCommit = M.run_tinygit_smartcommit

vim.api.nvim_set_keymap("n", "<leader>gg", [[<Cmd>lua StartLazygit()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gl", [[<Cmd>lua StartLazygitLogs()<CR>]], { noremap = true, silent = true })

return M
