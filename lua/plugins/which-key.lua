return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    keys = {
      scroll_down = "<c-d>",
      scroll_up = "<c-u>",
    },
    delay = 200, -- delay in milliseconds
    spec = {
      { "<leader>g", group = "Git", icon = { icon = "󰊢", hl = "DevIconGitLogo" }, mode = { "n", "v" } },
      { "<leader>go", group = "Open..", icon = { icon = "󰊢", hl = "DevIconGitLogo" }, mode = { "n", "v" } },
      { "<leader>gh", group = "Hunks", mode = { "n", "v" } },

      { "<leader>r", group = "Refactor", mode = { "n", "v" } },
      { "<leader>rg", group = "GrugFar", icon = { icon = "󰛔", color = "blue" } },

      { "<leader>s", group = "Snacks", icon = { icon = "󱥰", hl = "SnacksDashboardKey" } },
      { "<leader>sg", group = "Git", icon = { icon = "󱥰", hl = "SnacksDashboardKey" } },

      { "<leader>f", group = "Telescope" },
      { "<leader>t", group = "Terminal", icon = { icon = "", color = "blue" } },
      { "<leader>l", group = "Line diffs", icon = { icon = "󰈙", color = "blue" } },
      { "<leader>o", group = "Open..", icon = { icon = "", color = "yellow" } },
      { "<leader>q", group = "Quit", mode = { "n", "v" } },
      { "<leader>n", group = "Notifications" },
      { "<leader>y", group = "Yank", icon = { icon = "", color = "yellow" } },
      { "<leader>x", group = "Diagnostics" },
      { "<leader>w", group = "Windows" },
      { "<leader>D", group = "DadBod UI" },
      { "<leader>d", group = "Debug", icon = { icon = "🪲" } },
      { "<leader>c", group = "QuickFix" },
    },
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
}
