return {
  "folke/snacks.nvim",
  lazy = false,
  enabled = true,
  init = function()
    _G.Snacks = require("snacks")
    vim.api.nvim_set_hl(0, "SnacksPickerMatch", { link = "CustomMatch" })
    -- vim.api.nvim_create_autocmd("BufEnter", {
    --   pattern = "*",
    --   callback = function(event)
    --     local buf = event.buf
    --     if vim.bo[buf].filetype == "snacks_picker_preview" then
    --       local filename = vim.api.nvim_buf_get_name(buf)
    --       if filename and filename ~= "" then
    --         local ft = vim.filetype.match({ filename = filename })
    --         if ft then
    --           vim.bo[buf].filetype = ft
    --         end
    --       end
    --     end
    --   end,
    -- })
  end,
  opts = {
    -- bigfile = { enabled = true },
    dashboard = require("modules.snacks.dashboard-config"),
    -- explorer = { enabled = true },
    -- indent = { enabled = true },
    input = { enabled = false },
    notifier = {
      enabled = true,
      filter = function(notif)
        if notif.msg:find("Plugin Updates") then
          notif.timeout = 1000
        end
        return true
      end,
    },
    -- quickfile = { enabled = true },
    -- scope = { enabled = true },
    -- scroll = { enabled = true },
    toggle = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    picker = {
      enabled = true,
      formatters = { file = { truncate = 80, filename_first = true } },
      layouts = require("modules.snacks.picker.custom-layouts"),
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
      },
      actions = {
        insert_absolute_path = function(picker)
          require("scripts.snacks-path-insert").insert_absolute_path(picker)
        end,
        insert_relative_path = function(picker)
          require("scripts.snacks-path-insert").insert_relative_path(picker)
        end,
        insert_python_import_path = function(picker)
          require("scripts.snacks-path-insert").insert_python_import_path(picker)
        end,
        clip_full_path = function(picker)
          require("scripts.snacks-path-insert").clip_full_path(picker)
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
    },
  },
  -- stylua: ignore
 keys = {
   -- toggle
    { "<leader>us", function() Snacks.toggle.option("spell") end, desc = "Toggle Spell Check" },
    { "<leader>ui", function() Snacks.toggle.inlay_hints() end, desc = "Toggle Inlay Hints" },
   -- Notifier
    {"<leader>nn", function() Snacks.notifier.show_history() end, desc = "Notifier History"},
   -- Words
    { "]r", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" },},
    { "[r", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
   -- Top Pickers & Explorer
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>s:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>E", function() Snacks.explorer() end, desc = "File Explorer" },
    -- { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    -- { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    -- { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>sgll", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>sglf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    { "<leader>sgla", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>sgb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>sgs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>sgt", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>sgd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>s,", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sC", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config"), title = "Config Files" }) end, desc = "Find Config File" },
    { "<leader>sc", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sf", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sn", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sr", function() Snacks.picker.recent() end, desc = "Recent" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    { "zp", function() Snacks.picker.spelling() end, desc = "Spelling Picker" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
  },
}
