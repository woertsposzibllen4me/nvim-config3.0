return {
  "theHamsta/nvim-dap-virtual-text",
  enabled = false,
  lazy = true,
  opts = {},

  -- reference for hl:
  -- Folded = {
  --   fg = "#5A5B5C"
  -- }

  vim.api.nvim_set_hl(0, "DapVirtualText", {
    cterm = {
      italic = true,
    },
    fg = "#5A5B5C",
    italic = true,
  }),
  vim.api.nvim_set_hl(0, "NvimDapVirtualText", {
    cterm = {
      italic = true,
    },
    fg = "#5A5B5C",
    italic = true,
  }),
}
