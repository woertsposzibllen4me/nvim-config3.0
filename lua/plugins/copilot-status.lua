return {
  "jonahgoldwastaken/copilot-status.nvim",
  dependencies = { "zbirenbaum/copilot.lua" },
  event = "InsertEnter",
  enabled = true,
  config = function()
    require("copilot_status").setup({})
  end,
}
