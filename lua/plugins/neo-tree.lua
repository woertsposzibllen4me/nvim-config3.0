return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
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

      local neo_tree_opened = false

      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          if neo_tree_opened then
            return
          end

          local filetype = vim.bo.filetype
          if filetype ~= "dashboard" and filetype ~= "" then
            neo_tree_opened = true
            vim.defer_fn(function() -- necessary to avoid entering top of buffer after live grepping at startup
              vim.cmd("Neotree show")
            end, 0)
          end
        end,
      })
    end,
  },
}
