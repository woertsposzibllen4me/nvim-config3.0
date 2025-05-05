return {
  "sindrets/diffview.nvim",
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
  },
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewLog" },
  config = function()
    -- For reference, default highlight group values
    -- DiffviewFilePanelInsertions = {
    --   default = true,
    --   link = "diffAdded",
    -- }
    --
    -- diffAdded = {
    --   bg = "#273849",
    --   fg = "#B8DB87",
    -- }
    -- DiffviewFilePanelDeletions = {
    --   default = true,
    --   link = "diffRemoved",
    -- }
    --
    -- diffRemoved = {
    --   bg = "#3A273A",
    --   fg = "#E26A75",
    -- }
    -- DiffviewStatusModified = {
    --   default = true,
    --   link = "diffChanged",
    -- }
    --
    -- DiffviewStatusCopied = {
    --   default = true,
    --   link = "diffChanged",
    -- }
    --
    -- DiffviewStatusRenamed = {
    --   default = true,
    --   link = "diffChanged",
    -- }
    --
    -- diffChanged = {
    --   bg = "#252A3F",
    --   fg = "#7CA1F2",
    -- }

    vim.api.nvim_set_hl(0, "DiffviewFilePanelInsertions", { fg = "#B8DB87", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffviewStatusAdded", { fg = "#B8DB87", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffviewStatusUntracked", { fg = "#B8DB87", bg = "NONE" })

    vim.api.nvim_set_hl(0, "DiffviewFilePanelDeletions", { fg = "#E26A75", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffviewStatusBroken", { fg = "#E26A75", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffviewStatusDeleted", { fg = "#E26A75", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffviewStatusUnknown", { fg = "#E26A75", bg = "NONE" })

    vim.api.nvim_set_hl(0, "DiffviewStatusModified", { fg = "#7CA1F2", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffviewStatusCopied", { fg = "#7CA1F2", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffviewStatusRenamed", { fg = "#7CA1F2", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffviewStatusUnmerged", { fg = "#7CA1F2", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffviewStatusTypeChange", { fg = "#7CA1F2", bg = "NONE" })

    vim.api.nvim_set_hl(0, "DiffviewFilePanelTitle", { link = "@markup.heading.2.markdown" })
    vim.api.nvim_set_hl(0, "DiffviewFilePanelCounter", { link = "@markup.heading.2.markdown" })

    local actions = require("diffview.actions")
    local default_wrap_state = vim.o.wrap
    local default_cursorline_state = vim.o.cursorline

    vim.api.nvim_create_autocmd("User", {
      pattern = "DiffviewClose",
      callback = function()
        vim.o.wrap = default_wrap_state
        vim.o.cursorline = default_cursorline_state
      end,
    })

    require("diffview").setup({
      hooks = {
        view_opened = function(view)
          default_wrap_state = vim.o.wrap
          default_cursorline_state = vim.o.cursorline
        end,
        diff_buf_read = function(bufnr)
          if vim.opt_local.wrap ~= false or vim.opt_local.cursorline ~= false then
            vim.opt_local.wrap = false
            vim.opt_local.cursorline = false
          end
        end,
      },
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
