return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", {
        desc = "Toggle Neo-tree",
        silent = true,
        noremap = true,
      })

      require("neo-tree").setup({
        -- popup_border_style = "single",
        close_if_last_window = true,
        enable_git_status = true,
        enable_diagnostics = true,
        filesystem = {
          follow_current_file = {
            enabled = true,
          },
        },
        window = {
          mappings = {
            ["s"] = "none", -- unbind to be able to use flash
            ["<space>"] = "none", -- unbind to be able to use leader key
            ["S"] = "open_vsplit",
            ["Y"] = function(state)
              local node = state.tree:get_node()
              if node then
                local filepath = node:get_id()
                -- Get the filename without extension
                local filename = vim.fn.fnamemodify(filepath, ":t:r")
                vim.fn.setreg("+", filename)
                vim.notify("Yanked: " .. '"' .. filename .. '"' .. " to clipboard")
              end
            end,
          },
        },
      })

      -- Automatically open Neotree when opening a file
      local opened = false
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          local filetype = vim.bo.filetype
          if not opened and filetype ~= "dashboard" and filetype ~= "" then
            opened = true
            vim.defer_fn(function() -- needs tiny delay to avoid TeleScope error
              vim.cmd("Neotree show")
            end, 10)
          end
        end,
      })
    end,
  },
}
