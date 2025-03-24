return {
  "folke/persistence.nvim",
  lazy = false,
  event = "BufReadPre",
  opts = {},
  -- stylua: ignore
  keys = {
    { "<leader>qr", function() require("persistence").load() end, desc = "Restore Session" },
    { "<leader>q.", function() require("persistence").select() end, desc = "Select Session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    { "<leader>qs", function() require("persistence").save() end, desc = "Save Session" },
  },
}
