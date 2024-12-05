return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    {
      "<leader>G",
      function()
        local grug = require("grug-far")
        local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
        grug.open({
          transient = true,
          prefills = {
            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
          },
        })
      end,
      mode = { "n", "v" },
      desc = "Search and Replace (GrugFar)",
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
