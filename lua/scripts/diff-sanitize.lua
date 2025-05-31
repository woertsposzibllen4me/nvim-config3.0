-- Used to make diffs more legible by disabling certain features
local M = {}

function M.disable_diff_features()
  vim.diagnostic.enable(false)

  local ok, ts_context = pcall(require, "treesitter-context")
  if ok then
    ts_context.disable()
  end
end

function M.enable_diff_features()
  vim.diagnostic.enable(true)

  local ok, ts_context = pcall(require, "treesitter-context")
  if ok then
    ts_context.enable()
  end
end

return M
