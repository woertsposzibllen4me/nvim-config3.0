return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim", -- for rename support
    },
    config = function()
      vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", {
        desc = "Toggle Neo-tree",
        silent = true,
        noremap = true,
      })

      local events = require("neo-tree.events")

      local function on_move(data)
        if Snacks and Snacks.rename and Snacks.rename.on_rename_file then
          Snacks.rename.on_rename_file(data.source, data.destination)
        else
          vim.notify("Snacks rename module not initialized", vim.log.levels.WARN)
        end
      end

      require("neo-tree").setup({
        -- popup_border_style = "single",
        close_if_last_window = true,
        enable_git_status = true,
        enable_diagnostics = true,
        filesystem = {
          follow_current_file = {
            enabled = true,
          },
        },
        window = {
          mappings = {
            ["s"] = "none", -- unbind to be able to use flash
            ["<space>"] = "none", -- unbind to be able to use leader key
            ["S"] = "open_vsplit",
            ["Y"] = function(state)
              local node = state.tree:get_node()
              if node then
                local filepath = node:get_id()
                -- Get the filename without extension
                local filename = vim.fn.fnamemodify(filepath, ":t:r")
                vim.fn.setreg("+", filename)
                vim.notify("Yanked: " .. '"' .. filename .. '"' .. " to clipboard")
              end
            end,
          },
        },
        event_handlers = {
          { event = events.FILE_MOVED, handler = on_move },
          { event = events.FILE_RENAMED, handler = on_move },
          {
            event = "neo_tree_popup_input_ready",
            ---@param args { bufnr: integer, winid: integer }
            handler = function(args)
              -- map <esc> to enter normal mode (by default closes prompt)
              -- don't forget `opts.buffer` to specify the buffer of the popup.
              vim.keymap.set("i", "<esc>", vim.cmd.stopinsert, { noremap = true, buffer = args.bufnr })
            end,
          },
          {
            event = "neo_tree_popup_input_ready",
            handler = function(args)
              -- Map <CR> in normal mode to confirm/save the input
              vim.keymap.set("n", "<CR>", function()
                vim.cmd.startinsert()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
              end, { buffer = args.bufnr, noremap = true })
            end,
          },
        },
      })

      -- Open neo-tree automatically when first entering a (filetype) buffer
      local neo_tree_opened = false
      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function()
          if neo_tree_opened then
            return
          end
          local filetype = vim.bo.filetype
          local buftype = vim.bo.buftype
          if filetype ~= "dashboard" and filetype ~= "" and buftype == "" then
            neo_tree_opened = true
            vim.defer_fn(function() -- defer 0 necessary to avoid bugs
              vim.cmd("Neotree show")
            end, 0)
          end
        end,
      })

      -- Close Neo-tree when quitting Neovim to avoid issues with persisting sessions
      vim.api.nvim_create_autocmd("QuitPre", {
        callback = function()
          vim.cmd("Neotree close")
        end,
      })
    end,
  },
}
