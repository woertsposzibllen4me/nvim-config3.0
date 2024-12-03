return {
  "windwp/nvim-autopairs",
  enabled = true,
  event = "InsertEnter",
  config = function()
    local npairs = require("nvim-autopairs")
    npairs.setup({
      check_ts = true,
      fast_wrap = {},
    })
  end,
}
