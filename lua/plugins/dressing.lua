return {
  "stevearc/dressing.nvim",
  event = { "BufReadPost", "BufNewFile" },
  enabled = true, -- TODO: check for when "snacks.input" implements undo, then maybe we replace this.
  opts = {},
}
