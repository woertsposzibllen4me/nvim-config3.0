return {
  "folke/which-key.nvim",
  enabled = true,
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
      { "]'", group = "Alternative next", icon = { icon = "⏭️" } },
      { "['", group = "Alternative previous", icon = { icon = "⏮️" } },

      -- Yazi/Yank
      { "<leader>yo", icon = { icon = "💥" }, desc = "Open yazi at current file" },
      { "<leader>yw", icon = { icon = "💥" }, desc = "Open yazi in working directory" },
      { "<leader>Y", icon = { icon = "💥" }, desc = "Resume yazi session" },
      { "<leader>y", group = "Yank/Yazi", icon = { icon = "", color = "yellow" } },

      -- Upper/lowercase
      { "gU", desc = "UPPERCASE", icon = { icon = "🔠" }, mode = { "n", "v" } },
      { "gu", desc = "lowercase", icon = { icon = "🔡" }, mode = { "n", "v" } },

      -- Standalone groups
      { "<leader>f", group = "Telescope" },
      { "<leader>t", group = "Terminal", icon = { icon = "", color = "blue" } },
      { "<leader>l", group = "Line diffs", icon = { icon = "󰈙", color = "blue" } },
      { "<leader>b", group = "Bring Open..", icon = { icon = "", color = "yellow" } },
      { "<leader>q", group = "Quit/Session", mode = { "n", "v" } },
      { "<leader>n", group = "Notifications" },
      { "<leader>x", group = "Diagnostics" },
      { "<leader>w", group = "Window" },
      { "<leader>D", group = "DadBod UI" },
      { "<leader>d", group = "Debug", icon = { icon = "🪲" } },
      { "<leader>c", group = "QuickFix/Actions" },
      { "<Leader>u", group = "Utilities", icon = { icon = "🛠️" } },
      { "gH", group = "Peek Definitions", icon = { icon = "👁️" } },
      { "gm", group = "Marks", icon = { icon = "✅" } },

      -- Standalone descs

      -- Unused but considered:
      -- { "<leader>N", desc = "Toggle No Neck Pain", icon = { icon = "☕", color = "blue" } },
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
