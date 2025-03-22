local M = {}

local function notify_error(msg)
  vim.notify(msg, vim.log.levels.ERROR)
end

-- Terminal setup function
---@param shell? string
function M.setup(shell)
  vim.o.shell = shell or vim.o.shell
  -- Special handling for pwsh
  if shell == "pwsh" or shell == "powershell" then
    -- Check if 'pwsh' is executable and set the shell accordingly
    if vim.fn.executable("pwsh") == 1 then
      vim.o.shell = "pwsh"
    elseif vim.fn.executable("powershell") == 1 then
      vim.o.shell = "powershell"
    else
      return notify_error("No powershell executable found")
    end
    -- Setting shell command flags
    vim.o.shellcmdflag =
      "-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues['Out-File:Encoding']='utf8';$PSStyle.OutputRendering='plaintext';Remove-Alias -Force -ErrorAction SilentlyContinue tee;"
    -- Setting shell redirection
    vim.o.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
    -- Setting shell pipe
    vim.o.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
    -- Setting shell quote options
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
  end
end

-- Function to create a floating terminal
function M.float_term(cmd, opts)
  opts = vim.tbl_deep_extend("force", {
    size = { width = 0.9, height = 0.9 },
    esc_esc = false,
    ctrl_hjkl = false,
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

  -- Store the window ID in the buffer for later reference
  vim.api.nvim_buf_set_var(buf, "float_term_win", float)

  -- Fix Whichkey delay from waiting for bracket keys combinations
  vim.api.nvim_buf_set_keymap(buf, "t", "]", "]", { noremap = true, nowait = true })
  vim.api.nvim_buf_set_keymap(buf, "t", "[", "[", { noremap = true, nowait = true })

  -- Create terminal
  vim.fn.termopen(cmd, {
    cwd = opts.cwd,
    on_exit = function()
      vim.schedule(function()
        -- Check if the buffer still exists before trying to close it
        if vim.api.nvim_buf_is_valid(buf) then
          -- Check if the window still exists
          local win_valid = pcall(vim.api.nvim_win_get_buf, float)

          -- Refresh file and directory views
          vim.cmd("checktime")
          if package.loaded["neo-tree"] then
            pcall(function()
              require("neo-tree.sources.manager").refresh()
            end)
          end

          -- Force close the window if it's still valid
          if win_valid then
            vim.api.nvim_win_close(float, true)
          end

          -- Force delete the buffer
          if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
      end)
    end,
  })

  -- Terminal settings
  vim.cmd("startinsert")
  if not opts.esc_esc then
    vim.keymap.set("t", "<esc>", "<esc>", { buffer = buf, nowait = true })
  end
  if not opts.ctrl_hjkl then
    vim.keymap.set("t", "<c-h>", "<c-h>", { buffer = buf, nowait = true })
    vim.keymap.set("t", "<c-j>", "<c-j>", { buffer = buf, nowait = true })
    vim.keymap.set("t", "<c-k>", "<c-k>", { buffer = buf, nowait = true })
    vim.keymap.set("t", "<c-l>", "<c-l>", { buffer = buf, nowait = true })
  end

  return { buf = buf, win = float }
end

-- Function to set ANSI color
local function set_ansi_color(idx, color)
  local channel_id = vim.b.terminal_job_id
  if channel_id then
    local command = string.format("\27]4;%d;%s\7", idx, color)
    vim.fn.chansend(channel_id, command)
  else
    notify_error("No terminal job ID found.")
  end
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
  local term = M.float_term({ "lazygit", "log" }, { cwd = M.get_git_root() })
  return term
end

-- Function to start Lazygit in a floating terminal
function M.StartLazygit()
  local current_buffer = vim.api.nvim_get_current_buf()
  local float_term = M.float_term({ "lazygit" }, { cwd = M.get_git_root() })

  -- Set custom colors for the Lazygit terminal
  set_ansi_color(1, "#FF0000") -- Set color 1 to red
  set_ansi_color(2, "#00FF00") -- Set color 2 to green

  vim.api.nvim_buf_set_keymap(
    float_term.buf,
    "t",
    "<C-g>", -- Go to file in current nvim instance
    string.format([[<Cmd>lua require('scripts.lazygit_terminal').LazygitEdit(%d)<CR>]], current_buffer),
    { noremap = true, silent = true }
  )

  return float_term
end

-- Make specific functions available globally
_G.StartLazygitLogs = M.StartLazygitLogs
_G.StartLazygit = M.StartLazygit

vim.api.nvim_set_keymap("n", "<leader>gg", [[<Cmd>lua StartLazygit()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gl", [[<Cmd>lua StartLazygitLogs()<CR>]], { noremap = true, silent = true })

return M
