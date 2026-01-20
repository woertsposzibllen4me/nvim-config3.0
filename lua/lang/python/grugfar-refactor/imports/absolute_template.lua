local path = require("lang.python.grugfar-refactor.imports.path")

local M = {}

function M.generate(relative_path, is_directory)
  local dotted_path = path.normalize_path(relative_path, is_directory)
  local parent_path = dotted_path:match("(.+)%.[^%.]+$") or ""
  local replacement_path = parent_path .. ".GRUGRENAME"

  if is_directory then
    local package_template = require("lang.python.grugfar-refactor.imports.templates.package")
    return string.format(
      package_template,
      -- id: package
      dotted_path,
      dotted_path,
      replacement_path,
      -- id: package-as
      dotted_path,
      dotted_path,
      replacement_path,
      -- id: from-package
      dotted_path,
      dotted_path,
      replacement_path,
      -- id: from-package-as
      dotted_path,
      dotted_path,
      replacement_path,
      -- id: submodules
      dotted_path,
      replacement_path,
      -- id: submodules-as
      dotted_path,
      replacement_path,
      -- id: from-submodules
      dotted_path,
      replacement_path,
      -- id: from-submodules-as
      dotted_path,
      replacement_path
    )
  end

  local module_template = require("lang.python.grugfar-refactor.imports.templates.module")
  local module_name = dotted_path:match("%.([^%.]+)$") or dotted_path

  return string.format(
    module_template,
    -- id: module
    dotted_path,
    dotted_path,
    replacement_path,
    -- id: module-as
    dotted_path,
    dotted_path,
    replacement_path,
    -- id: from-module
    dotted_path,
    dotted_path,
    replacement_path,
    -- id: from-module-as
    dotted_path,
    dotted_path,
    replacement_path,
    -- id: parent-import
    parent_path,
    module_name,
    parent_path,
    -- id: parent-import-as
    parent_path,
    module_name,
    parent_path,
    -- id: parent-import-as-parentheses
    parent_path,
    module_name,
    parent_path,
    -- id: parent-import-multiple
    parent_path,
    module_name,
    parent_path
  )
end

return M
