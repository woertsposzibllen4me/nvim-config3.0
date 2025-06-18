vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- Setup some globals for debugging (lazy-loaded)
    ---@diagnostic disable-next-line: duplicate-set-field
    _G.dd = function(...)
      Snacks.debug.inspect(...)
    end
    ---@diagnostic disable-next-line: duplicate-set-field
    _G.bt = function()
      Snacks.debug.backtrace()
    end
    vim.print = _G.dd -- Override print to use snacks for `:=` command
  end,
})
