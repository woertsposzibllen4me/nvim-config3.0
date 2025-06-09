--- Module for disabling/enabling features during diff mode to improve legibility
local M = {}

local ts_context = nil
local ts_context_was_enabled = false
local lspsaga_winbar_was_enabled = false

--- Disables features that can clutter diff view:
--- - Diagnostic messages
--- - Treesitter context (sticky headers)
--- - LSP Saga winbar breadcrumbs
--- @return nil
function M.disable_diff_features()
  vim.diagnostic.enable(false)

  local has_ts_context
  has_ts_context, ts_context = pcall(require, "treesitter-context")
  if has_ts_context then
    ts_context.disable()
    ts_context_was_enabled = true
  end

  local has_lspsaga, _ = pcall(require, "lspsaga")
  if has_lspsaga then
    local config = require("lspsaga").config
    lspsaga_winbar_was_enabled = config.symbol_in_winbar and config.symbol_in_winbar.enable
    if lspsaga_winbar_was_enabled then
      vim.cmd("Lspsaga winbar_toggle")
    end
  end

  vim.cmd("redraw!")
end

--- Re-enables features that were disabled for diff mode with `disable_diff_features`
--- Restores the previous state of all managed features
--- @return nil
function M.re_enable_diff_features()
  vim.diagnostic.enable(true)

  if ts_context_was_enabled and ts_context then
    ts_context.enable()
    ts_context_was_enabled = false
  end

  if lspsaga_winbar_was_enabled then
    vim.cmd("Lspsaga winbar_toggle")
    lspsaga_winbar_was_enabled = false
  end

  vim.cmd("redraw!")
end

return M
