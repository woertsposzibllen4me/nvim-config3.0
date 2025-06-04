local M = {}

local luasnip = require("luasnip")

-- Load friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()
-- Movement inside snippets slots
vim.keymap.set({ "i", "s" }, "<C-k>", function()
  return luasnip.jumpable(1) and "<Plug>luasnip-jump-next" or "<Tab>"
end, { expr = true, silent = true })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
  return luasnip.jumpable(-1) and "<Plug>luasnip-jump-prev" or "<S-Tab>"
end, { expr = true, silent = true })

-- Add any additional snippet-specific configuration here
-- For example:
-- luasnip.config.set_config({
--   history = true,
--   updateevents = "TextChanged,TextChangedI",
-- })

-- You can also add custom snippets here:
-- require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/snippets"})

return M
