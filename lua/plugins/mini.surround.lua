return {
  "echasnovski/mini.surround",
  recommended = true,
  opts = {
    mappings = {
      add = "gsa", -- Add surrounding in Normal and Visual modes
      delete = "gsd", -- Delete surrounding
      find = "gsf", -- Find surrounding (to the right)
      find_left = "gsF", -- Find surrounding (to the left)
      highlight = "gsh", -- Highlight surrounding
      replace = "gsr", -- Replace surrounding
      update_n_lines = "gsn", -- Update `n_lines`
    },
  },
  keys = {
    { "gsa", desc = "Add surrounding" },
    { "gsd", desc = "Delete surrounding" },
    { "gsf", desc = "Find surrounding (right)" },
    { "gsF", desc = "Find surrounding (left)" },
    { "gsh", desc = "Highlight surrounding" },
    { "gsr", desc = "Replace surrounding" },
    { "gsn", desc = "Update n_lines" },
  },
}
