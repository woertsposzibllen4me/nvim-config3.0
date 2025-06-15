---@class Logger
---@field config LoggerConfig
local M = {}

---@class LoggerConfig
---@field file string
---@field max_file_size integer
---@field levels table<string, integer>
---@field min_level integer
M.config = {
  file = vim.fn.stdpath("config") .. "/logs/custom.log",
  max_file_size = 10 * 1024 * 1024,
  levels = {
    DEBUG = 1,
    INFO = 2,
    WARN = 3,
    ERROR = 4,
  },
  min_level = 2,
}

---@private
local function _rotate_if_needed()
  local stat = vim.loop.fs_stat(M.config.file)
  if stat and stat.size > M.config.max_file_size then
    local backup_file = M.config.file .. ".old"
    vim.loop.fs_rename(M.config.file, backup_file)
  end
end

function M.init()
  local log_dir = vim.fn.fnamemodify(M.config.file, ":h")
  vim.fn.mkdir(log_dir, "p")
  _rotate_if_needed()
end

---@param message string
---@param level? string
---@param context? string
function M.log(message, level, context)
  level = level or "INFO"
  local level_num = M.config.levels[level] or M.config.levels.INFO
  if level_num < M.config.min_level then
    return
  end

  local timestamp = os.date("%Y-%m-%d %H:%M:%S")
  local context_str = context and (" [" .. context .. "]") or ""
  local entry = string.format("[%s] %s%s: %s\n", timestamp, level, context_str, tostring(message))

  local file = io.open(M.config.file, "a")
  if file then
    file:write(entry)
    file:close()
  else
    vim.notify("Logger: Failed to write to log file", vim.log.levels.WARN)
  end
end

---@param msg string
---@param ctx? string
function M.debug(msg, ctx)
  M.log(msg, "DEBUG", ctx)
end

---@param msg string
---@param ctx? string
function M.info(msg, ctx)
  M.log(msg, "INFO", ctx)
end

---@param msg string
---@param ctx? string
function M.warn(msg, ctx)
  M.log(msg, "WARN", ctx)
end

---@param msg string
---@param ctx? string
function M.error(msg, ctx)
  M.log(msg, "ERROR", ctx)
end

---@param level string
function M.set_level(level)
  if M.config.levels[level] then
    M.config.min_level = M.config.levels[level]
  end
end

---@return string
function M.get_log_file()
  return M.config.file
end

function M.clear()
  local file = io.open(M.config.file, "w")
  if file then
    file:close()
  end
end

return M
