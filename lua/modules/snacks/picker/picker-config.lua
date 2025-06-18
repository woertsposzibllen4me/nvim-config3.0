local M = {}
M.path_inserts = require("modules.snacks.picker.path-inserts")
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
      filter = require("modules.snacks.picker.filter-builtins").filter_recent,
    egrepify = {
      format = "file",
      live = true,
      supports_live = true,
      layout = "grep_vertical",
      finder = require("modules.snacks.picker.finders.egrepify").egrepify,
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
      },
    },
  },
}
