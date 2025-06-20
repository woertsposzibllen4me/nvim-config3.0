return {
  "cbochs/portal.nvim",
  enabled = false,
  dependencies = {
    "cbochs/grapple.nvim",
    -- "ThePrimeagen/harpoon",
  },
  keys = {
    {
      "<leader>o",
      function()
        require("modules.portal.clear-winbar").setup_clear_portal_winbar("debug")
        vim.cmd("Portal jumplist backward")
      end,
      desc = "Portal Jump Backward",
    },
    {
      "<leader>i",
      function()
        require("modules.portal.clear-winbar").setup_clear_portal_winbar("debug")
        vim.cmd("Portal jumplist forward")
      end,
      desc = "Portal Jump Forward",
    },
  },
}
