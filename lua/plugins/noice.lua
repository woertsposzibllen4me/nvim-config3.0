return {
  "folke/noice.nvim",
  event = "VeryLazy",
  enabled = true,
  opts = {
    -- noice options here
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      enabled = false, -- has many small redrawing issues with neo-tree renaming
      opts = {
        stages = "static",
        timeout = 2500,
        fps = 60,
        render = "default",
        -- background_colour = "#000000",
      },
      config = function(_, opts)
        require("notify").setup(opts)
        vim.notify = require("notify")
      end,
    },
  },
  keys = {
    {
      "<leader>nd",
      function()
        require("notify").dismiss({ silent = true, pending = true })
      end,
      desc = "Dismiss all notifications",
    },
    {
      "<leader>na",
      "<cmd>NoiceAll<CR>",
      desc = "Show all notifications",
    },
  },
}
