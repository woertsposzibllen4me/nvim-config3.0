return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = "BufReadPost",
  enabled = true,
  config = function()
    require("bufferline").setup({
      options = {
        mode = "tabs",
        max_name_length = 30,
        name_formatter = function(buf)
          ---@cast buf {name: string, path: string, bufnr: number, buffers: table, tabnr: number}
          -- Check if tab has custom name
          if vim.t[buf.tabnr] and vim.t[buf.tabnr].custom_tabname then
            return vim.t[buf.tabnr].custom_tabname
          end
          -- Otherwise use default name
          return buf.name
        end,
      },
    })
  end,
}
