local M = {}
M.virtual_text_toggle = Snacks.toggle.new({
  name = "Diagnostic Virtual Text",
  get = function()
    local config = vim.diagnostic.config()
    return config.virtual_text ~= false
  end,
  set = function(state)
    vim.diagnostic.config({ virtual_text = state })
  end,
})

return M
