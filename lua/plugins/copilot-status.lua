return {
  "farazdagi/copilot-status.nvim", -- forked due to unimplemented fix  TODO: check upstream (jonahgoldwastaken)
  dependencies = { "zbirenbaum/copilot.lua" },
  event = "BufReadPost",
  enabled = true,
  config = function()
    require("copilot_status").setup({})
  end,
}
