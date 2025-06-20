return {
  "stevearc/dressing.nvim",
  enabled = true, -- TODO: check for when "snacks.input" implements undo, then maybe we replace this.
  event = { "BufReadPost", "BufNewFile" },
  opts = {},
}
