return {

  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- noice options here
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      opts = {
        stages = "static",
        timeout = 3000,
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
}
