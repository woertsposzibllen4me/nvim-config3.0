-- helper to open snacks explorer without focusing it
local function show_snacks_no_focus()
  local current_win = vim.api.nvim_get_current_win()
  require("snacks").explorer()
  if vim.api.nvim_win_is_valid(current_win) then
    vim.defer_fn(function()
      vim.api.nvim_set_current_win(current_win)
    end, 30)
  end
end

return {
  "mbbill/undotree",
  enabled = true,
  cmd = "UndotreeToggle",
  keys = {
    {
      "<leader>U",

      function()
        local function is_buffer_open(buftype)
          for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[buf].filetype == buftype then
              return true
            end
          end
          return false
        end

        local snacks_explorer_was_open = is_buffer_open("snacks_picker_list")
        local neotree_was_open = is_buffer_open("neo-tree")
        local undotree_was_open = is_buffer_open("undotree")

        -- Close explorers if they're open and undotree is being opened
        if neotree_was_open and not vim.g.neotree_closed_by_undo then
          vim.g.neotree_closed_by_undo = true
          vim.cmd("Neotree close")
        end

        if snacks_explorer_was_open and not vim.g.snacks_closed_by_undo then
          vim.g.snacks_closed_by_undo = true
          require("snacks").explorer()
        end

        vim.cmd("UndotreeToggle")

        -- If undotree was open (now closing), restore previously open explorers
        if undotree_was_open then
          if vim.g.neotree_closed_by_undo then
            vim.cmd("Neotree show")
            vim.g.neotree_closed_by_undo = false
          end
          if vim.g.snacks_closed_by_undo then
            show_snacks_no_focus()
            vim.g.snacks_closed_by_undo = false
          end
        elseif not undotree_was_open then
          vim.cmd("UndotreeFocus")
        end
      end,
      desc = "Toggle Undotree",
    },
  },
  config = function()
    vim.g.undotree_SplitWidth = 38
    if OnWindows then
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
        if vim.bo[ev.buf].filetype == "undotree" then
          vim.schedule(function()
            if vim.g.neotree_closed_by_undo then
              vim.cmd("Neotree show")
              vim.g.neotree_closed_by_undo = false
            end
            if vim.g.snacks_closed_by_undo then
              show_snacks_no_focus()
              vim.g.snacks_closed_by_undo = false
            end
          end)
        end
      end,
    })
  end,
}
