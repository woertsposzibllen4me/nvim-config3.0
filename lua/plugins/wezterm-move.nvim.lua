return {
  "letieu/wezterm-move.nvim",
  enabled = OnWindows and true, -- Better fitted for Windows
  keys = {
    {
      "<C-h>",
      function()
        require("wezterm-move").move("h")
      end,
    },
    {
      "<C-j>",
      function()
        require("wezterm-move").move("j")
      end,
    },
    {
      "<C-k>",
      function()
        require("wezterm-move").move("k")
        -- Check if we landed in neo-tree and auto-move right
        if vim.bo.filetype == "neo-tree" then
          require("wezterm-move").move("l")
        end
      end,
    },
    {
      "<C-l>",
      function()
        require("wezterm-move").move("l")
      end,
    },
  },
}
