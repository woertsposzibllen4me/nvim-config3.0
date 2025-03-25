local M = {}
local function insert_path(picker, use_relative, as_python_import)
  local item = picker:current()
  if item == nil then
    vim.notify("No selection", vim.log.levels.WARN)
    return
  end

  local path = item.file
  if path == nil then
    vim.notify("No path", vim.log.levels.WARN)
    return
  end

  -- Convert path format
  local function convert_path(p)
    return p:gsub("\\", "/")
  end

  local function get_relative_path(p)
    local relative = vim.fn.fnamemodify(p, ":.")
    return convert_path(relative)
  end

  if use_relative then
    path = get_relative_path(path)
  else
    path = convert_path(path)
  end

  if as_python_import then
    path = path:gsub("/__init__%.py$", "")
    path = path:gsub("%.py$", "")
    path = path:gsub("/", ".")
    path = path:gsub("^%.", "")
    path = "from " .. path .. " import "
  end

  picker:close()
  -- Insert the path
  vim.api.nvim_put({ path }, "", false, true)
end

-- Register custom actions with Snacks
M.insert_absolute_path = function(picker)
  insert_path(picker, false, false)
end

M.insert_relative_path = function(picker)
  insert_path(picker, true, false)
end

M.insert_python_import_path = function(picker)
  insert_path(picker, true, true)
end

return M
