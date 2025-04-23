return {
  "sindrets/diffview.nvim",
  keys = {
    { "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
  },
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewLog" },
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
            local cur_pos = vim.api.nvim_win_get_cursor(0)
            vim.cmd("normal! ]c")
            local new_pos = vim.api.nvim_win_get_cursor(0)

            if cur_pos[1] == new_pos[1] and cur_pos[2] == new_pos[2] then
              local last_change_pos = vim.api.nvim_win_get_cursor(0)
              vim.cmd("normal! G")
              local eof_pos = vim.api.nvim_win_get_cursor(0)

              if last_change_pos[1] == eof_pos[1] and last_change_pos[2] == eof_pos[2] then
                actions.select_next_entry()
              end
            end
          end,
          ["<C-k>"] = function()
            local cur_pos = vim.api.nvim_win_get_cursor(0)
            vim.cmd("normal! [c")
            local new_pos = vim.api.nvim_win_get_cursor(0)

            if cur_pos[1] == new_pos[1] and cur_pos[2] == new_pos[2] then
              local first_change_pos = vim.api.nvim_win_get_cursor(0)
              vim.cmd("normal! gg")
              local bof_pos = vim.api.nvim_win_get_cursor(0)

              if first_change_pos[1] == bof_pos[1] and first_change_pos[2] == bof_pos[2] then
                actions.select_prev_entry()
              end
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
