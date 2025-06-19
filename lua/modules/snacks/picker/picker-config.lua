local M = {}
M.path_inserts = require("modules.snacks.picker.actions.path-inserts")
M.setup_all_keys = require("modules.snacks.picker.keys.setup-all-keys")
return {
  enabled = true,
  formatters = { file = { truncate = 80, filename_first = true } },
  layouts = require("modules.snacks.picker.layouts.custom-layouts"),
  previewers = {
    diff = {
      builtin = false,
      cmd = { "delta" },
    },
    git = {
      builtin = false,
    },
  },
  sources = {
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
      filter = require("modules.snacks.picker.filters.filter-builtins").filter_recent,
    },
    explorer = require("modules.snacks.explorer.explorer-config"),
    grep = {
      finder = require("modules.snacks.picker.finders.egrepify").egrepify,
      layout = "grep_vertical",
      win = {
        input = {
          keys = M.setup_all_keys.setup_grep_input_keys(),
        },
      },
      actions = {
        toggle_and_search = require("modules.snacks.picker.actions.toggle-grep-and-search"),
      },
    },
  },
  actions = {
    insert_absolute_path = function(picker)
      M.path_inserts.insert_absolute_path(picker)
    end,
    insert_relative_path = function(picker)
      M.path_inserts.insert_relative_path(picker)
    end,
    insert_python_import_path = function(picker)
      M.path_inserts.insert_python_import_path(picker)
    end,
    clip_full_path = function(picker)
      M.path_inserts.clip_full_path(picker)
    end,
    flash = require("modules.snacks.picker.setup-flash"),
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
        -- adjust binds to match ahk remaps
        ["<Left>"] = { "toggle_hidden", mode = { "i", "n" } }, -- ["<a-h>"]
      },
    },
  },
}
