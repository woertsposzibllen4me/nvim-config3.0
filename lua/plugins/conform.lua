return {
  "stevearc/conform.nvim",
  enabled = false,
  event = { "BufReadPre" },
  opts = {
    formatters_by_ft = {
      ["python"] = { "ruff_format" },
      ["yaml"] = { "prettier" },
      ["toml"] = { "taplo" },
      ["lua"] = { "stylua" },
    },
    formatters = {
      stylua = {
        prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      },
    },
    format_on_save = {
      timer = 500,
      lsp_fallback = true,
    },
  },
}
