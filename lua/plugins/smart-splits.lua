return {
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    enabled = not OnWindows and true, -- We don't use it on Windows (slow
    -- and inconsistent, we have an alternative plugin)
    opts = {
      at_edge = "stop",
    },
    keys = {
      {
        "<C-h>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        desc = "Move to left split",
      },
      {
        "<C-j>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        desc = "Move to bottom split",
      },
      {
        "<C-k>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        desc = "Move to top split",
      },
      {
        "<C-l>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        desc = "Move to right split",
      },
      {
        "<M-Left>",
        function()
          require("smart-splits").resize_left()
        end,
        desc = "Resize left split",
      },
      {
        "<M-Down>",
        function()
          require("smart-splits").resize_down()
        end,
        desc = "Resize bottom split",
      },
      {
        "<M-Up>",
        function()
          require("smart-splits").resize_up()
        end,
        desc = "Resize top split",
      },
      {
        "<M-Right>",
        function()
          require("smart-splits").resize_right()
        end,
        desc = "Resize right split",
      },
    },
  },
}
