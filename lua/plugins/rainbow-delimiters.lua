return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    dependencies = "nvim-treesitter/nvim-treesitter",
    enabled = true,
    event = { "BufRead", "BufNewFile" },
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")

      vim.api.nvim_set_hl(0, "RainbowDelimiterEnhancedGreen", { fg = "#739c84" })

      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          powershell = rainbow_delimiters.strategy["global"],
        },
        query = {
          [""] = "rainbow-delimiters",
          powershell = "rainbow-delimiters",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          -- "RainbowDelimiterEnhancedGreen", -- Our slightly brighter green
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      }
      -- Explicitly enable for PowerShell files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "ps1",
        callback = function()
          rainbow_delimiters.enable(0) -- 0 means current buffer
        end,
      })
    end,
  },
}
