return {
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    keys = {
      {
        "<C-H>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        desc = "Move to left split",
      },
      {
        "<C-J>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        desc = "Move to bottom split",
      },
      {
        "<C-K>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        desc = "Move to top split",
      },
      {
        "<C-L>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        desc = "Move to right split",
      },
    },
  },
}
