return {
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    "folke/snacks.nvim", -- for rename support
    "kwkarlwang/bufresize.nvim", -- for automatic resize support
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

    -- Create base event handlers
    local event_handlers = {
      { event = events.FILE_MOVED, handler = on_move },
      { event = events.FILE_RENAMED, handler = on_move },
      {
        event = "neo_tree_popup_input_ready",
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
    }

    -- Add bufresize event handlers if the plugin is loaded
    if _G.Bufresize then
      local handlers = {
        {
          event = "neo_tree_window_before_open",
          handler = function()
            _G.Bufresize.register()
            _G.Bufresize.block_register()
          end,
        },
        {
          event = "neo_tree_window_after_open",
          handler = function()
            _G.Bufresize.resize_open()
          end,
        },
        {
          event = "neo_tree_window_before_close",
          handler = function()
            _G.Bufresize.register()
            _G.Bufresize.block_register()
          end,
        },
        {
          event = "neo_tree_window_after_close",
          handler = function()
            _G.Bufresize.resize_close()
          end,
        },
      }

      for _, handler in ipairs(handlers) do
        table.insert(event_handlers, handler)
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
      commands = {
        copy_selector = require("modules.neo-tree.copy_selector").copy_selected_path,
        close_towards_up = require("modules.neo-tree.node_toggler").navigate_up,
        open_towards_down = require("modules.neo-tree.node_toggler").navigate_down,
      },
      window = {
        mappings = {
          ["s"] = "none", -- unbind to be able to use flash
          ["<space>"] = "none", -- unbind to be able to use leader key
          ["S"] = "open_vsplit",
          ["L"] = "focus_preview",
          ["Y"] = "copy_selector",
          ["h"] = "close_towards_up", -- Navigate to parent directory / Close current directory
          ["l"] = "open_towards_down", -- Open current directory / Navigate to first child
        },
      },
      event_handlers = event_handlers,
    })

    -- Open neo-tree automatically when entering our first (filetype) buffer of size >= 140 columns
    local neo_tree_opened = false
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        if neo_tree_opened then
          return
        end
        local filetype = vim.bo.filetype
        local buftype = vim.bo.buftype
        local win_width = vim.api.nvim_win_get_width(0)

        if filetype ~= "dashboard" and filetype ~= "" and buftype == "" and win_width >= 140 then
          neo_tree_opened = true -- To run successfully only once
          vim.defer_fn(function() -- defer 0 necessary to avoid bugs
            vim.cmd("Neotree show")
          end, 0)
        end
      end,
    })
  end,
}
