_G.Logger = {
  file = vim.fn.stdpath("config") .. "/logs/custom.log",

  init = function(self)
    vim.fn.mkdir(vim.fn.fnamemodify(self.file, ":h"), "p")
  end,

  log = function(self, message, level, context)
    level = level or "INFO"
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local context_str = context and (" [" .. context .. "]") or ""
    local entry = string.format("[%s] %s%s: %s\n", timestamp, level, context_str, tostring(message))

    local file = io.open(self.file, "a")
    if file then
      file:write(entry)
      file:close()
    end
  end,

  info = function(self, msg, ctx)
    self:log(msg, "INFO", ctx)
  end,
  debug = function(self, msg, ctx)
    self:log(msg, "DEBUG", ctx)
  end,
  warn = function(self, msg, ctx)
    self:log(msg, "WARN", ctx)
  end,
  error = function(self, msg, ctx)
    self:log(msg, "ERROR", ctx)
  end,
}

Logger:init()
