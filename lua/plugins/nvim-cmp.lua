return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    -- Snippets
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- Load friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Basic completion setup
    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-f>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
      },
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
    })

    -- Setup for cmdline completion
    cmp.setup.cmdline(":", {
      mapping = vim.tbl_extend("force", cmp.mapping.preset.cmdline(), {
        ["<Tab>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "c" }),
      }),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })

    -- Setup for search completion
    cmp.setup.cmdline("/", {
      mapping = vim.tbl_extend("force", cmp.mapping.preset.cmdline(), {
        ["<Tab>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "c" }),
      }),
      sources = {
        { name = "buffer" },
      },
    })

    -- Movement inside snippets slots
    vim.keymap.set({ "i", "s" }, "<A-n>", function()
      return luasnip.jumpable(1) and "<Plug>luasnip-jump-next" or "<Tab>"
    end, { expr = true, silent = true })

    vim.keymap.set({ "i", "s" }, "<A-p>", function()
      return luasnip.jumpable(-1) and "<Plug>luasnip-jump-prev" or "<S-Tab>"
    end, { expr = true, silent = true })
  end,
}
