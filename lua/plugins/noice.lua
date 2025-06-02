return {
  "folke/noice.nvim",
  event = "VeryLazy",
  enabled = true,
  opts = {
    presets = {
      lsp_doc_border = true,
    },
    routes = {
      {
        filter = {
          event = "notify",
          find = "Config Change Detected. Reloading",
        },
        view = "mini",
        opts = { timeout = 1000 },
      },
      {
        filter = {
          event = "msg_show",
          find = "written$",
        },
        view = "mini",
        opts = { timeout = 1000 },
      },
    },
    lsp = {
      signature = {
        enabled = true,
      },
      progress = {
        enabled = true,
      },
    },
  },
  keys = {
    {
      "<leader>na",
      "<cmd>NoiceAll<CR>",
      desc = "Show all notifications",
    },
    {
      "<leader>nd",
      "<cmd>NoiceDismiss<CR>",
      desc = "Dismiss notifications",
    },
  },
}
