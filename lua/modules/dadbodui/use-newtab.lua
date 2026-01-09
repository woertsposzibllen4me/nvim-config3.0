local M = {}

-- Open dadbod-ui in a new tab or switch to it if already open
M.toggle_dbui_tab = function()
  local dbui_tab = nil
  for tab = 1, vim.fn.tabpagenr("$") do
    local buflist = vim.fn.tabpagebuflist(tab)
    for _, buf in ipairs(buflist) do
      if vim.fn.getbufvar(buf, "&filetype") == "dbui" then
        dbui_tab = tab
        break
      end
    end
    if dbui_tab then
      break
    end
  end
  if dbui_tab then
    vim.cmd("tabnext " .. dbui_tab)
  else
    vim.cmd("tabnew")
    vim.cmd("DBUI")
  end
end
return M
