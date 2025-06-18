local M = {}
M.virtual_text_toggle = Snacks.toggle.new({
  name = "Diagnostic Virtual Text",
  get = function()
    local config = vim.diagnostic.config()
    if config then
      return config.virtual_text ~= false
    else
      return false -- Default to false if config is not available
    end
  end,
  set = function(state)
    vim.diagnostic.config({ virtual_text = state })
  end,
})

return M
