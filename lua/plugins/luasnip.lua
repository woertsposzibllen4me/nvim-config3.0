return {
  "L3MON4D3/LuaSnip",
  -- keys = {
  --   { "<C-k>", mode = { "i", "s" } },
  --   { "<C-j>", mode = { "i", "s" } },
  --   { "<C-l>", mode = { "i" } },
  --   { "<C-e>", mode = { "i", "s" } },
  -- },
  config = function()
    local ls = require("luasnip")

    require("luasnip.loaders.from_vscode").lazy_load()

    -- Movement inside snippets slots
    vim.keymap.set({ "i", "s" }, "<C-k>", function()
      return ls.jumpable(1) and "<Plug>luasnip-jump-next" or "<Tab>"
    end, { expr = true, silent = true })

    vim.keymap.set({ "i", "s" }, "<C-j>", function()
      return ls.jumpable(-1) and "<Plug>luasnip-jump-prev" or "<S-Tab>"
    end, { expr = true, silent = true })

    vim.keymap.set({ "i" }, "<C-l>", function()
      ls.expand()
    end, { silent = true })

    vim.keymap.set({ "i", "s" }, "<C-e>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { silent = true })
  end,
}
