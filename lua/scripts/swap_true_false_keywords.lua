vim.keymap.set("n", "<leader>S", function()
  local line = vim.api.nvim_get_current_line()

  local replacements = {
    ["true"] = "false",
    ["false"] = "true",
    ["True"] = "False",
    ["False"] = "True",
  }

  -- Check for any match in the line
  for pattern, replacement in pairs(replacements) do
    if line:find(pattern) then
      -- Replace the first occurrence
      local new_line = line:gsub(pattern, replacement, 1)
      vim.api.nvim_set_current_line(new_line)
      vim.cmd("write")
      return true
    end
  end

  return false
end, { desc = "Swap true/false keywords" })

require("which-key").add({
  { "<leader>S", group = "Swap true/false keywords", icon = "" },
})
