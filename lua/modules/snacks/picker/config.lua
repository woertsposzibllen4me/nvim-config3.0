return {
  enabled = true,
  formatters = { file = { truncate = 80, filename_first = true } },
  layouts = require("modules.snacks.picker.custom-layouts"),
  sources = vim.tbl_deep_extend("force", {
    lsp_definitions = {
      jump = { reuse_win = false }, -- Prevent using a different window for gd, etc.
    },
    lsp_declarations = {
      jump = { reuse_win = false },
    },
    lsp_implementations = {
      jump = { reuse_win = false },
    },
    lsp_references = {
      jump = { reuse_win = false },
    },
    lsp_type_definitions = {
      jump = { reuse_win = false },
    },
    qflist = {
      layout = "grep_vertical",
    },
    grep = {
      layout = "grep_vertical",
    },
    grep_buffers = {
      layout = "grep_vertical",
    },
    grep_word = {
      layout = "grep_vertical",
    },
    jumps = {
      layout = "grep_vertical",
    },
    command_history = {
      layout = "midscreen_dropdown",
    },
    search_history = {
      layout = "midscreen_dropdown",
    },
    recent = {
      filter = {
        cwd = true,
        filter = function(item, _)
          -- Skip if no file path
          if not item.file then
            return true
          end

          -- Paths to exclude
          local exclude_patterns = {
            -- Undo directory
            vim.fn.stdpath("state") .. "/undo",
            -- Git commit message files
            "%.git/COMMIT_EDITMSG$",
            "%.git/MERGE_MSG$",
            "/COMMIT_EDITMSG$",
            "/MERGE_MSG$",
            -- Add any other patterns you want to exclude
          }

          -- Check if the file path matches any exclusion pattern
          for _, pattern in ipairs(exclude_patterns) do
            if item.file:match(pattern) then
              return false -- Exclude this file
            end
          end

          return true -- Include this file
        end,
      },
    },
  }, require("modules.snacks.explorer.grep-filetree").setup_explorer_grep()),
  actions = {
    insert_absolute_path = function(picker)
      require("modules.snacks.picker.path-inserts").insert_absolute_path(picker)
    end,
    insert_relative_path = function(picker)
      require("modules.snacks.picker.path-inserts").insert_relative_path(picker)
    end,
    insert_python_import_path = function(picker)
      require("modules.snacks.picker.path-inserts").insert_python_import_path(picker)
    end,
    clip_full_path = function(picker)
      require("modules.snacks.picker.path-inserts").clip_full_path(picker)
    end,
    flash = function(picker)
      require("flash").jump({
        pattern = "^",
        label = { after = { 0, 0 } },
        search = {
          mode = "search",
          exclude = {
            function(win)
              return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
            end,
          },
        },
        action = function(match)
          local idx = picker.list:row2idx(match.pos[1])
          picker.list:_move(idx, true, true)
        end,
      })
    end,
  },
  win = {
    input = {
      keys = {
        ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
        ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
        ["-"] = { "insert_relative_path", mode = { "n" } },
        ["="] = { "insert_absolute_path", mode = { "n" } },
        ["<bs>"] = { "insert_python_import_path", mode = { "n" } },
        ["+"] = { "clip_full_path", mode = { "n" } },
        ["<c-l>"] = { "focus_preview", mode = { "i", "n" } },
        ["<c-h>"] = { "focus_list", mode = { "i", "n" } },
        ["<a-s>"] = { "flash", mode = { "n", "i" } },
      },
    },
  },
}
