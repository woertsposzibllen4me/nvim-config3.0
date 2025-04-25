local M = {}

local lazygit_term = {
  buf = nil,
  win = nil,
  backdrop = {
    buf = nil,
    win = nil,
  },
}

-- Create a floating terminal with Lazygit
function M.open_lazygit_terminal()
  -- Find git repository root
  local git_root
  local handle = io.popen("git rev-parse --show-toplevel 2>/dev/null")
  if handle then
    git_root = handle:read("*l")
    handle:close()
  end

  if not git_root then
    vim.notify("Not in a git repository, aborting", vim.log.levels.ERROR)
    return
  end

  -- Setup buffer and window for LG terminal
  local term_buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)

  -- Create backdrop first, with lower zindex
  local backdrop_bufnr = vim.api.nvim_create_buf(false, true)
  local backdrop_winnr = vim.api.nvim_open_win(backdrop_bufnr, false, {
    relative = "editor",
    border = "none",
    row = 0,
    col = 0,
    width = vim.o.columns,
    height = vim.o.lines,
    focusable = false,
    style = "minimal",
    zindex = 50, -- Base zindex
  })

  -- Apply backdrop highlight and blend
  vim.api.nvim_set_hl(0, "LazyGitBackdrop", { bg = "#000000", default = true })
  vim.wo[backdrop_winnr].winhighlight = "Normal:LazyGitBackdrop"
  vim.wo[backdrop_winnr].winblend = 50
  vim.bo[backdrop_bufnr].buftype = "nofile"

  local term_win = vim.api.nvim_open_win(term_buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    zindex = 60, -- Higher than backdrop
  })

  -- Store the terminal info
  lazygit_term.buf = term_buf
  lazygit_term.win = term_win
  lazygit_term.backdrop.buf = backdrop_bufnr
  lazygit_term.backdrop.win = backdrop_winnr

  -- Set up environment with NVIM_LISTEN_ADDRESS
  local server_addr = vim.v.servername
  local env = server_addr and { NVIM_LISTEN_ADDRESS = server_addr } or {}

  -- Start lazygit in terminal
  vim.fn.jobstart("lazygit", {
    cwd = git_root,
    env = env,
    term = true,
    on_exit = function()
      vim.schedule(function()
        if lazygit_term.dim_bg then
          lazygit_term.dim_bg:unmount()
        end

        if vim.api.nvim_win_is_valid(lazygit_term.win) then
          vim.api.nvim_win_close(lazygit_term.win, true)
        end
        if vim.api.nvim_buf_is_valid(lazygit_term.buf) then
          vim.api.nvim_buf_delete(lazygit_term.buf, { force = true })
        end

        -- Clear our reference
        lazygit_term.buf = nil
        lazygit_term.win = nil
        lazygit_term.dim_bg = nil
      end)
    end,
  })

  -- Add custom keybinding to terminal buffer for <C-c>
  vim.api.nvim_buf_set_keymap(
    term_buf,
    "t",
    "<C-c>",
    [[<C-\><C-n>:lua RunTinygitSmartCommit()<CR>]],
    { noremap = true, silent = true }
  )

  -- Fix Whichkey delay from waiting for bracket keys combinations
  vim.api.nvim_buf_set_keymap(term_buf, "t", "]", "]", { noremap = true, nowait = true })
  vim.api.nvim_buf_set_keymap(term_buf, "t", "[", "[", { noremap = true, nowait = true })

  -- Enter terminal mode
  vim.cmd("startinsert")

  return term_buf, term_win
end

function M.run_tinygit_smartcommit()
  if not lazygit_term.win or not vim.api.nvim_win_is_valid(lazygit_term.win) then
    vim.notify("No active lazygit terminal window found", vim.log.levels.ERROR)
    return
  end

  vim.cmd("Tinygit smartCommit")

  -- Set up a timer to check when Tinygit is done (could not get "BufDelete, BufWipeout.." events to trigger)
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

_G.RunTinygitSmartCommit = M.run_tinygit_smartcommit

vim.api.nvim_create_user_command("LazyGit", function()
  M.open_lazygit_terminal()
end, {})

return M
