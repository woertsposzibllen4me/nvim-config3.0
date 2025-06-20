return {
  "jonahgoldwastaken/copilot-status.nvim",
  enabled = true,
  dependencies = { "zbirenbaum/copilot.lua" },
  event = "InsertEnter",
  config = function()
    require("copilot_status").setup({})
  end,
}
