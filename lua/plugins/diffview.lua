return {
  "sindrets/diffview.nvim",
  keys = {
    { "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
  },
  cmd = { "DiffviewOpen", "DiffviewClose" },
  config = function()
    -- Create autocmd to disable ugly cursorline in Diffview
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "DiffviewFiles",
      callback = function()
        vim.opt_local.cursorline = false
      end,
    })

    local actions = require("diffview.actions")
    require("diffview").setup({
      keymaps = {
        view = {
          ["q"] = actions.close,
          ["<C-j>"] = function()
            -- Store current cursor position
            local cur_pos = vim.api.nvim_win_get_cursor(0)

            -- Try to go to next change
            vim.cmd("normal! ]c")

            -- Get new cursor position
            local new_pos = vim.api.nvim_win_get_cursor(0)

            -- If cursor hasn't moved, we're at the last change
            if cur_pos[1] == new_pos[1] and cur_pos[2] == new_pos[2] then
              actions.select_next_entry()
            end
          end,
          ["<C-k>"] = function()
            -- Store current cursor position
            local cur_pos = vim.api.nvim_win_get_cursor(0)

            -- Try to go to previous change
            vim.cmd("normal! [c")

            -- Get new cursor position
            local new_pos = vim.api.nvim_win_get_cursor(0)

            -- If cursor hasn't moved, we're at the first change
            if cur_pos[1] == new_pos[1] and cur_pos[2] == new_pos[2] then
              actions.select_prev_entry()
            end
          end,
        },
        file_panel = {
          ["q"] = actions.close,
        },
        file_history_panel = {
          ["q"] = actions.close,
        },
      },
    })
  end,
}
