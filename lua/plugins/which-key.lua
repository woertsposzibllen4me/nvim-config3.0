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
      { "<leader>g", icon = { icon = "󰊢", hl = "DevIconGitLogo" }, group = "Git", mode = { "n", "v" } },
      { "<leader>go", icon = { icon = "󰊢", hl = "DevIconGitLogo" }, group = "Open...", mode = { "n", "v" } },
      { "<leader>gh", group = "Hunks", mode = { "n", "v" } },
      { "<leader>q", group = "Quit", mode = { "n", "v" } },
      { "<leader>n", group = "Notifications" },
      { "<leader>y", icon = { icon = "", color = "yellow", }, group = "Yank", },
      { "<leader>x", group = "Diagnostics" },
      { "<leader>w", group = "Windows" },
      { "<leader>D", group = "DadBod UI" },
      { "<leader>d",  icon = { icon = "🪲"}, group = "Debug" },
      { "<leader>c", group = "QuickFix" },
      { "<leader>s", group = "Search" },
      { "<leader>sg", group = "Git Search" },
      { "gl", icon = { icon = "", color = "blue", }, group = "Vim Lsp" },
      { "<leader>gd", icon = { icon = "", color = "orange", }, group = "Diffview", },
      {"<leader>t", icon = { icon = "", color = "blue", }, group = "Terminal", },
    })
  end,
}
