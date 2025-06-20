return {
  "jonahgoldwastaken/copilot-status.nvim",
  enabled = false,
  dependencies = { "zbirenbaum/copilot.lua" },
  event = "InsertEnter",
  config = function()
    require("copilot_status").setup({})
  end,
}
