local M = {}

local function normalize_separators(path)
  return path:gsub("\\", "/")
end

function M.normalize_path(relative_path, is_directory)
  local normalized = normalize_separators(relative_path)

  if is_directory then
    return normalized:gsub("/", ".")
  end

  local without_ext = normalized:gsub("%.py$", "")
  if without_ext:match("/__init__$") then
    without_ext = without_ext:gsub("/__init__$", "")
  end
  return without_ext:gsub("/", ".")
end

return M
