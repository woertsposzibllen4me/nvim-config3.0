return {
  "mbbill/undotree",
  cmd = "UndotreeToggle",
  keys = {
    {
      "<leader>U",
      function()
        -- Define the is_undotree_open function locally within the keymap function
        local function is_undotree_open()
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].filetype == "undotree" then
              return true
            end
          end
          return false
        end

        -- if _G.Bufresize then
        --   if is_undotree_open() then
        --     _G.Bufresize.register()
        --     _G.Bufresize.block_register()
        --     vim.notify("call 1")
        --   else
        --     _G.Bufresize.register()
        --     _G.Bufresize.block_register()
        --     vim.notify("call 1'")
        --   end
        -- end

        vim.cmd("Neotree close")
        vim.cmd("UndotreeToggle")
        vim.cmd("UndotreeFocus")

        -- if _G.Bufresize then
        --   if is_undotree_open() then
        --     _G.Bufresize.resize_open()
        --     vim.notify("call 2")
        --   else
        --     _G.Bufresize.resize_close()
        --     vim.notify("call 2'")
        --   end
        -- end
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
  end,
}
