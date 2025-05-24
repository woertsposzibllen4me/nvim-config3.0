return {
  "farazdagi/copilot-status.nvim", -- forked due to unimplemented fix  TODO: check upstream (jonahgoldwastaken)
  dependencies = { "zbirenbaum/copilot.lua" },
  event = "InsertEnter",
  enabled = true,
  config = function()
    require("copilot_status").setup({})
  end,
}
