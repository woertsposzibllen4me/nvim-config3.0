require("which-key").add({
  {
    'dm',
    function()
      vim.api.nvim_echo({ { "Delete mark: ", "Normal" } }, false, {})

      -- Set a timer for timeout
      local timer = vim.loop.new_timer()
      local timed_out = false

      if timer == nil then
        return
      end

      timer:start(2000, 0, function()
        timed_out = true
        timer:close()
        vim.schedule(function()
          print('Delete mark: timeout')
        end)
      end)

      local char = vim.fn.getchar()

      if not timed_out then
        timer:close()
        local mark = vim.fn.nr2char(char)
        vim.cmd('delmarks ' .. mark)
        print('Deleted mark: ' .. mark)
        vim.cmd("redraw!")
      end
    end,
    desc = 'Delete mark',
    mode = 'n'
  }
})
