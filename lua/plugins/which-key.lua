return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    keys = {
      scroll_down = "<c-d>",
      scroll_up = "<c-u>",
    },
    delay = 250, -- delay in milliseconds
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
    -- stylua: ignore
    wk.add({
      { "<leader>g", icon = { icon = "󰊢", color = "red" }, group = "Git", mode = { "n", "v" } },
      { "<leader>gh", group = "Hunks", mode = { "n", "v" } },
      { "<leader>q", group = "Quit", mode = { "n", "v" } },
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
      { "<leader>s", group = "Search" },
      { "<leader>sg", group = "Git Search" },
      { "gl", icon = {
        icon = "",
        color = "blue",
      }, group = "Vim Lsp" },
    })
  end,
}
