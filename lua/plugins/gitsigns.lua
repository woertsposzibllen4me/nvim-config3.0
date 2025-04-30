return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  commit = "ee7e50dfbdf49e3acfa416fd3ad3abbdb658582c", -- Locked for now due to Windows issues  TODO: Check upstream
  config = function()
    require("gitsigns").setup({

      -- Define signs for unstaged changes
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },

      -- Define signs for staged changes
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },

      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        -- Helper function for mapping keys
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- Helper function for setting tab-specific keymaps
        local function set_diff_tab_keymaps(new_tab)
          local function set_tab_keymap(mode, lhs, rhs, tab_opts)
            tab_opts = vim.tbl_extend("force", tab_opts or {}, {
              callback = function()
                if vim.api.nvim_get_current_tabpage() == new_tab then
                  rhs()
                end
              end,
            })
            vim.keymap.set(mode, lhs, "", tab_opts)
          end

          -- Tab-specific keymaps
          set_tab_keymap("n", "q", function()
            vim.cmd("tabclose")
            -- Restore original Ctrl+J and Ctrl+K bindings
            vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to window below" })
            vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to window above" })
          end, { desc = "Close diff tab" })

          -- Navigation in diff view
          set_tab_keymap("n", "<C-k>", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gs.prev_hunk()
            end
            vim.cmd("normal! zz")
          end, { desc = "Next change in diff" })

          set_tab_keymap("n", "<C-j>", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gs.next_hunk()
            end
            vim.cmd("normal! zz")
          end, { desc = "Previous change in diff" })
        end

        -- Hunk navigation
        map("n", "]g", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.next_hunk()
          end
          vim.defer_fn(function()
            vim.cmd("normal! zz")
          end, 5)
        end, "Next Hunk")

        map("n", "[g", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.prev_hunk()
          end
          vim.defer_fn(function()
            vim.cmd("normal! zz")
          end, 5)
        end, "Prev Hunk")

        -- Jump to first/last hunk
        map("n", "]G", function()
          gs.nav_hunk("last")
        end, "Last Hunk")

        map("n", "[G", function()
          gs.nav_hunk("first")
        end, "First Hunk")

        -- Hunk operations
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")

        -- Blame operations
        map("n", "<leader>ghb", function()
          gs.blame_line({ full = true })
        end, "Blame Line")

        map("n", "<leader>ghB", function()
          gs.blame()
        end, "Blame Buffer")

        -- Diff operations in new tab with custom name (requires bufferline plugin)
        vim.api.nvim_set_keymap("n", "<leader>ghd", "", {
          noremap = true,
          silent = true,
          callback = function()
            vim.cmd("tabnew")
            vim.cmd("buffer #")
            gs.diffthis()
            local new_tab = vim.api.nvim_get_current_tabpage()
            set_diff_tab_keymaps(new_tab)

            local tabnr = vim.api.nvim_tabpage_get_number(new_tab)
            -- Create or ensure a table exists for this tab
            if not vim.t[tabnr] then
              vim.t[tabnr] = {}
            end

            local bufname = vim.fn.expand("%:t")
            vim.t[tabnr].custom_tabname = "GitSignsDiff: " .. (bufname ~= "" and bufname or "[No Name]")
            vim.cmd("redrawtabline")
          end,
          desc = "Open diff in new tab",
        })

        vim.api.nvim_set_keymap("n", "<leader>ghD", "", {
          noremap = true,
          silent = true,
          callback = function()
            vim.cmd("tabnew")
            vim.cmd("buffer #")
            gs.diffthis("~")
            local new_tab = vim.api.nvim_get_current_tabpage()
            set_diff_tab_keymaps(new_tab)
          end,
          desc = "Open diff with ~ in new tab",
        })

        -- Text object for hunks
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    })
  end,
}
