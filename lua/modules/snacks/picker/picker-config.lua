return {
  enabled = true,
  formatters = { file = { truncate = 80, filename_first = true } },
  layouts = require("modules.snacks.picker.custom-layouts"),
  previewers = {
    diff = {
      builtin = false,
      cmd = { "delta" },
    },
    git = {
      builtin = false,
    },
  },
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
    grep = require("modules.snacks.picker.grep-globs").setup_grep_with_globs(),
    grep_buffers = {
      layout = "grep_vertical",
    },
    grep_word = {
      layout = "grep_vertical",
    },
    jumps = {
      layout = "grep_vertical",
    },
    todo_comments = {
      layout = "grep_vertical",
    },
    command_history = {
      layout = "midscreen_dropdown",
    },
    search_history = {
      layout = "midscreen_dropdown",
    },
    recent = {
      filter = require("modules.snacks.picker.filter-builtins").filter_recent,
    },
    explorer = {
      win = {
        list = {
          keys = {
            ["<c-j>"] = false,
            ["<c-k>"] = false,
          },
        },
      },
    },
  }, require("modules.snacks.explorer.grep-snacks-filetree").setup_explorer_grep()),
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
