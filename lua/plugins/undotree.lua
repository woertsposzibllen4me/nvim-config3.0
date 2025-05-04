return {
  "mbbill/undotree",
  cmd = "UndotreeToggle",
  keys = {
    {
      "<leader>U",
      function()
        local function is_neotree_open()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].filetype == "neo-tree" then
              return true
            end
          end
          return false
        end

        local function is_undotree_open()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].filetype == "undotree" then
              return true
            end
          end
          return false
        end

        local neotree_was_open = is_neotree_open()
        local undotree_was_open = is_undotree_open()

        vim.cmd("Neotree close")

        if neotree_was_open and not vim.g.neotree_closed_by_undotree then
          vim.g.neotree_closed_by_undotree = true
        end

        vim.cmd("UndotreeToggle")

        if undotree_was_open then
          if vim.g.neotree_closed_by_undotree then
            vim.cmd("Neotree show")
          end
        elseif not undotree_was_open then
          vim.cmd("UndotreeFocus")
        end
      end,
      desc = "Toggle Undotree",
    },
  },
  config = function()
    if vim.fn.has("win32") == 1 then
      -- Check if diff is available in the PATH
      if vim.fn.executable("diff") == 1 then
        vim.g.undotree_DiffCommand = "diff"
      else
        vim.g.undotree_DiffCommand = "FC"
      end
    end

    -- Create an autocmd to handle when Undotree is closed by any method
    vim.api.nvim_create_autocmd("BufWinLeave", {
      callback = function(ev)
        if vim.bo[ev.buf].filetype == "undotree" and vim.g.neotree_closed_by_undotree then
          vim.schedule(function()
            vim.cmd("Neotree show")
            vim.g.neotree_closed_by_undotree = false
          end)
        end
      end,
    })
  end,
}
