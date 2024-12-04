return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local null_ls = require("null-ls")
      local h = require("null-ls.helpers")
      local methods = require("null-ls.methods")

      -- taplo formatter for toml files
      local taplo = h.make_builtin({
        name = "taplo",
        method = methods.internal.FORMATTING,
        filetypes = { "toml" },
        generator_opts = {
          command = "taplo",
          args = { "format", "-" },
          to_stdin = true,
        },
        factory = h.formatter_factory,
      })

      null_ls.setup({
        sources = {
          taplo,
        },
        autostart = true,
      })
    end,
  },
}
