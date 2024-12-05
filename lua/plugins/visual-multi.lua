return {
  "mg979/vim-visual-multi",
  enabled = true,
  -- event = "BufReadPost",
  keys = {
    { "<M-L>", desc = "Add cursor at position" },
    { "<M-H>", desc = "Toggle cursor mappings" },
    { "<M-K>", desc = "Add cursor up" },
    { "<M-J>", desc = "Add cursor down" },
    { "<C-n>", desc = "Select next word" },
  },
  config = function()
    -- Hack around issue with conflicting insert mode <BS> mapping
    -- between this plugin and nvim-autopairs
    vim.api.nvim_create_autocmd("User", {
      pattern = "visual_multi_start",
      callback = function()
        pcall(vim.keymap.del, "i", "<BS>", { buffer = 0 })
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "visual_multi_exit",
      callback = function()
        require("nvim-autopairs").force_attach()
      end,
    })

    -- Fixes conflict with treesitter-textobjects bindings
    vim.g.VM_maps = {
      ["Goto Next"] = "]v",
      ["Goto Prev"] = "[v",
    }

    vim.cmd([[
      highlight link VM_Extend IncSearch 
      highlight link VM_Insert IncSearch 
      highlight link VM_Cursor IncSearch 
      highlight link MultiCursor IncSearch 
      ]])

    -- Dropoff cursor at current position
    vim.keymap.set("n", "<M-L>", "<Plug>(VM-Add-Cursor-At-Pos)", { noremap = true, silent = true })
    -- Toggle cursors shifting with HJKL
    vim.keymap.set("n", "<M-H>", "<Plug>(VM-Toggle-Mappings)", { noremap = true, silent = true })
    -- Add cursors up/down
    vim.keymap.set("n", "<M-K>", "<Plug>(VM-Add-Cursor-Up)", { noremap = true, silent = true })
    vim.keymap.set("n", "<M-J>", "<Plug>(VM-Add-Cursor-Down)", { noremap = true, silent = true })
  end,
}
