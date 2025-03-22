return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  enabled = true,
  config = function()
    require("bufferline").setup({
      options = {
        mode = "tabs",
        name_formatter = function(tab)
          -- Check if tab has custom name
          if vim.t[tab.tabnr] and vim.t[tab.tabnr].custom_tabname then
            return vim.t[tab.tabnr].custom_tabname
          end
          -- Otherwise use default name
          return tab.name
        end,
      },
    })
  end,
}
