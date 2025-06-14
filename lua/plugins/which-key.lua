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
      -- Git
      { "<leader>g", group = "Git", icon = { icon = "󰊢", hl = "DevIconGitLogo" }, mode = { "n", "v" } },
      { "<leader>go", group = "Open..", icon = { icon = "󰊢", hl = "DevIconGitLogo" }, mode = { "n", "v" } },
      { "<leader>gh", group = "Hunks", mode = { "n", "v" } },

      -- Refactor
      { "<leader>r", group = "Refactor", mode = { "n", "v" } },
      { "<leader>rg", group = "GrugFar", icon = { icon = "󰛔", color = "blue" } },

      -- Snacks
      { "<leader>s", group = "Snacks", icon = { icon = "󱥰", hl = "SnacksDashboardKey" } },
      { "<leader>sg", group = "Git", icon = { icon = "󱥰", hl = "SnacksDashboardKey" } },

      -- Portal
      { "<leader>o", desc = "Portal Jump Backward", icon = { icon = "󰩈", color = "azure" } },
      { "<leader>i", desc = "Portal Jump Forward", icon = { icon = "󰩈", color = "azure" } },

      -- ] and [ keybinds Alternatives
      { "]'", group = "Alternative next", icon = { icon = "⏭️", color = "blue" } },
      { "['", group = "Alternative previous", icon = { icon = "⏮️", color = "blue" } },

      -- Standalones
      { "<leader>f", group = "Telescope" },
      { "<leader>t", group = "Terminal", icon = { icon = "", color = "blue" } },
      { "<leader>l", group = "Line diffs", icon = { icon = "󰈙", color = "blue" } },
      { "<leader>b", group = "Bring Open..", icon = { icon = "", color = "yellow" } },
      { "<leader>q", group = "Quit/Session", mode = { "n", "v" } },
      { "<leader>n", group = "Notifications" },
      { "<leader>y", group = "Yank", icon = { icon = "", color = "yellow" } },
      { "<leader>x", group = "Diagnostics" },
      { "<leader>w", group = "Windows" },
      { "<leader>D", group = "DadBod UI" },
      { "<leader>d", group = "Debug", icon = { icon = "🪲" } },
      { "<leader>c", group = "QuickFix/Actions" },
      { "<Leader>u", group = "Utilities", icon = { icon = "🛠️", color = "yellow" } },
      { "gH", group = "Peek Definitions", icon = { icon = "👁️", color = "yellow" } },
      { "gm", group = "Marks", icon = { icon = "✅", color = "yellow" } },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.add({ { "gx", desc = "Open file with system app", mode = { "n", "v" } } }) -- shorter desc for URL opening (fixes single column display)
  end,
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
