return {
  "simeji/winresizer",
  event = "VeryLazy",
  config = function()
    vim.g.winresizer_horiz_resize = 1
    vim.g.winresizer_vert_resize = 1
    vim.g.winresizer_start_key = "<F24>" -- doesn't work, still starts with default C-e, need to change src code or override bind

    vim.keymap.set("n", "<leader>we", "<cmd>WinResizerStartResize<CR>", {
      silent = true,
      desc = "Start window edit mode",
    })
  end,
}
