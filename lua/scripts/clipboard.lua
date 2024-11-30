function append_file_to_system_register()
  vim.cmd('normal! ggVG"my')
  local current_clipboard = vim.fn.getreg("+")
  local m_register = vim.fn.getreg("m")
  vim.fn.setreg("+", current_clipboard .. m_register)
end

function append_empty_reg_to_system_reg()
  local unnamed_register = vim.fn.getreg('"')
  local system_register = vim.fn.getreg("+")

  -- Count the number of lines in the unnamed register
  local lines_added = select(2, string.gsub(unnamed_register, "\n", "\n"))

  local new_register_content = system_register .. "\n" .. unnamed_register
  vim.fn.setreg("+", new_register_content)

  -- Count the total number of lines in the new system register
  local total_lines = select(2, string.gsub(new_register_content, "\n", "\n"))

  -- Create and show the notification
  local notification_message = string.format(
    "Added %d %s to system register\nTotal lines: %d",
    lines_added,
    lines_added == 1 and "line" or "lines",
    total_lines
  )
  vim.notify(notification_message, vim.log.levels.INFO, { title = "Register Update" })
end

vim.keymap.set("n", "<leader>ya", 'ggVG"+y', { noremap = true, silent = true, desc = "Copy file to system clipboard" })

vim.keymap.set("n", "<leader>yA", append_file_to_system_register, { desc = "Append file content to system clipboard" })

vim.keymap.set(
  "n",
  "<leader>+",
  append_empty_reg_to_system_reg,
  { noremap = true, silent = true, desc = 'Append " register to system clipboard' }
)
