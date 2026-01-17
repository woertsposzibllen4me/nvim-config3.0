return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    on_highlights = function(hl, c)
      hl["@string.documentation.python"] = {
        fg = c.comment,
        italic = false,
      }
    end,
  },
}
