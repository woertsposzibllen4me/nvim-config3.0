return {
  "junegunn/vim-easy-align",
  keys = {
    { "ga", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "EasyAlign" },
  },
  config = function()
    vim.g.easy_align_delimiters = {
      [";"] = {
        pattern = ";",
      },
      ["/"] = {
        pattern = [[//\+\|/\*\|\*/]],
      },
    }
  end,
}
