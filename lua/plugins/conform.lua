return {
  "stevearc/conform.nvim",
  enabled = true,
  event = { "BufReadPre" },
  opts = {
    formatters_by_ft = {
      ["python"] = { "ruff_format" },
      ["yaml"] = { "prettier" },
      ["json"] = { "prettier" },
      ["toml"] = { "taplo" },
      ["lua"] = { "stylua" },
      ["zsh"] = { "beautysh" },
      ["sh"] = { "shfmt" },
    },
    formatters = {
      stylua = {
        prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
      },
      beautysh = {
        prepend_args = { "--indent-size", "2" },
      },
    },
    format_on_save = {
      timer = 500,
      lsp_fallback = true,
    },
  },
}
