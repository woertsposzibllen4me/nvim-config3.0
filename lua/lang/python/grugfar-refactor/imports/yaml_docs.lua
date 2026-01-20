local M = {}

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

function M.split_yaml_docs(yaml)
  yaml = yaml or ""
  local docs, cur = {}, {}

  local function push()
    local txt = trim(table.concat(cur, "\n"))
    if txt ~= "" then
      local id = txt:match("\n?id:%s*([%w%-%_]+)")
      table.insert(docs, { id = id or "unknown", yaml = txt })
    end
    cur = {}
  end

  for line in (yaml .. "\n"):gmatch("([^\n]*)\n") do
    if trim(line) == "---" then
      push()
    else
      table.insert(cur, line)
    end
  end

  push()
  return docs
end

function M.concat_yaml_docs(docs)
  local parts = {}
  for _, d in ipairs(docs or {}) do
    table.insert(parts, trim(d.yaml))
  end
  return table.concat(parts, "\n---\n")
end

return M
