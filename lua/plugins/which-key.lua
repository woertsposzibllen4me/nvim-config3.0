return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    keys = {
      scroll_down = "<c-d>",
      scroll_up = "<c-u>",
    },
    delay = 400, -- delay in milliseconds
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  config = function(_, opts) -- added opts parameter here
    local wk = require("which-key")
    wk.setup(opts)
    wk.add({
      { "<leader>g", group = "Git" },
      { "<leader>gh", group = "Hunks operations" },
      { "<leader>q", group = "Quit" },
      { "<leader>n", group = "Notifications" },
      {
        "<leader>y",
        icon = {
          icon = "",
          color = "yellow",
        },
        group = "Yank",
      },
      { "<leader>x", group = "Diagnostics" },
      { "<leader>w", group = "Windows" },
      { "<leader>d", group = "DadBod UI" },
      { "<leader>c", group = "QuickFix" },
    })
  end,
}
