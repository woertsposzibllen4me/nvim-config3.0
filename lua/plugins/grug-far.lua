return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    -- {
    --   "<leader>rgr",
    --   function()
    --     local grug = require("grug-far")
    --     local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
    --     grug.open({
    --       transient = true,
    --       prefills = {
    --         filesFilter = ext and ext ~= "" and "*." .. ext or nil,
    --       },
    --     })
    --   end,
    --   mode = { "n", "v" },
    --   desc = "GrugFar (rg)",
    -- },
    -- {
    --   "<leader>rga",
    --   function()
    --     local grug = require("grug-far")
    --     local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
    --     grug.open({
    --       transient = true,
    --       engine = "astgrep",
    --       prefills = {
    --         filesFilter = ext and ext ~= "" and "*." .. ext or nil,
    --       },
    --     })
    --   end,
    --   mode = { "n", "v" },
    --   desc = "GrugFar (ast-grep)",
    -- },
    {
      "<leader>rg",
      function()
        require("grug-far").open()
      end,
      mode = { "n", "v" },
      desc = "GrugFar",
    },
    {
      "<leader>rw",
      ":GrugFarWithin<CR>",
      mode = { "n", "v" },
      desc = "GrugFar Within",
    },
  },
  config = function()
    local grug = require("grug-far")
    grug.setup({
      headerMaxWidth = 80,
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "grug-far",
      callback = function()
        vim.keymap.set("n", "q", function()
          vim.cmd("q")
        end, { buffer = true, silent = true })
      end,
    })
  end,
}
