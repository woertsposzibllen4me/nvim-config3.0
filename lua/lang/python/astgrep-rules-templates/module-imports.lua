local M = {}

-- Normalize path separators to forward slashes
local function normalize_separators(path)
  return path:gsub("\\", "/")
end

-- Normalize path to handle __init__.py and convert to dotted notation
local function normalize_path(relative_path, is_directory)
  local normalized = normalize_separators(relative_path)

  if is_directory then
    return normalized:gsub("/", ".")
  else
    local without_ext = normalized:gsub("%.py$", "")
    if without_ext:match("/__init__$") then
      without_ext = without_ext:gsub("/__init__$", "")
    end
    return without_ext:gsub("/", ".")
  end
end

function M.generate_absolute_template(relative_path, is_directory)
  local dotted_path = normalize_path(relative_path, is_directory)
  local parent_path = dotted_path:match("(.+)%.[^%.]+$") or ""
  local new_dotted_path = parent_path .. ".NEW_NAME_PLACEHOLDER"

  if is_directory then
    -- Directory template with submodules
    return string.format(
      [[
id: replace-submodule-from-import
language: python
rule:
  pattern: from %s.$SUBMODULES import $IMPORTS
fix: from %s.$SUBMODULES import $IMPORTS
---
id: replace-submodule-from-import-multiline
language: python
rule:
  pattern: |
    from %s.$SUBMODULES import (
        $$$IMPORTS
    )
fix: |
    from %s.$SUBMODULES import (
        $$$IMPORTS
    )
---
id: replace-direct-import
language: python
rule:
  pattern: import %s
fix: import %s
---
id: replace-alias-import
language: python
rule:
  pattern: import %s as $ALIAS
fix: import %s as $ALIAS
]],
      dotted_path,
      new_dotted_path,
      dotted_path,
      new_dotted_path,
      dotted_path,
      new_dotted_path,
      dotted_path,
      new_dotted_path
    )
  else
    -- File template
    return string.format(
      [[
id: replace-from-import
language: python
rule:
  pattern: from %s import $IMPORTS
fix: from %s import $IMPORTS
---
id: replace-from-import-multiline
language: python
rule:
  pattern: |
    from %s import (
        $$$IMPORTS
    )
fix: |
    from %s import (
        $$$IMPORTS
    )
---
id: replace-direct-import
language: python
rule:
  pattern: import %s
fix: import %s
---
id: replace-alias-import
language: python
rule:
  pattern: import %s as $ALIAS
fix: import %s as $ALIAS
]],
      dotted_path,
      new_dotted_path,
      dotted_path,
      new_dotted_path,
      dotted_path,
      new_dotted_path,
      dotted_path,
      new_dotted_path
    )
  end
end

function M.generate_relative_template_with_scope(relative_path, is_directory)
  if is_directory then
    local dir_name = vim.fn.fnamemodify(relative_path, ":t") -- e.g., "core"
    local parent_dir = vim.fn.fnamemodify(relative_path, ":h") -- e.g., "src/apps/shopwatcher"

    return string.format(
      [[
id: replace-relative-dir-submodule
language: python
rule:
  pattern: from .%s.$SUBMODULES import $IMPORTS
fix: from .NEW_NAME_PLACEHOLDER.$SUBMODULES import $IMPORTS
---
id: replace-relative-dir-submodule-multiline
language: python
rule:
  pattern: |
    from .%s.$SUBMODULES import (
        $$$IMPORTS
    )
fix: |
    from .NEW_NAME_PLACEHOLDER.$SUBMODULES import (
        $$$IMPORTS
    )
]],
      dir_name,
      dir_name,
      dir_name,
      dir_name
    ),
      parent_dir
  else
    local dotted_path = normalize_path(relative_path, false)
    local module_name = dotted_path:match("%.([^%.]+)$") or dotted_path
    local parent_module = dotted_path:match("%.([^%.]+)%.[^%.]+$")

    local parent_dir = vim.fn.fnamemodify(relative_path, ":h")
    local grandparent_dir = vim.fn.fnamemodify(parent_dir, ":h")

    if parent_module then
      return string.format(
        [[
id: replace-relative-from-parent
language: python
rule:
  pattern: from .%s.%s import $IMPORTS
fix: from .%s.NEW_NAME_PLACEHOLDER import $IMPORTS
---
id: replace-relative-from-parent-multiline
language: python
rule:
  pattern: |
    from .%s.%s import (
        $$$IMPORTS
    )
fix: |
    from .%s.NEW_NAME_PLACEHOLDER import (
        $$$IMPORTS
    )
---
id: replace-relative-direct-sibling
language: python
rule:
  pattern: from .%s import $IMPORTS
fix: from .NEW_NAME_PLACEHOLDER import $IMPORTS
---
id: replace-relative-direct-sibling-multiline
language: python
rule:
  pattern: |
    from .%s import (
        $$$IMPORTS
    )
fix: |
    from .NEW_NAME_PLACEHOLDER import (
        $$$IMPORTS
    )
]],
        parent_module,
        module_name,
        parent_module,
        parent_module,
        module_name,
        parent_module,
        module_name,
        module_name
      ),
        grandparent_dir
    else
      return string.format(
        [[
id: replace-relative-direct-sibling
language: python
rule:
  pattern: from .%s import $IMPORTS
fix: from .NEW_NAME_PLACEHOLDER import $IMPORTS
---
id: replace-relative-direct-sibling-multiline
language: python
rule:
  pattern: |
    from .%s import (
        $$$IMPORTS
    )
fix: |
    from .NEW_NAME_PLACEHOLDER import (
        $$$IMPORTS
    )
]],
        module_name,
        module_name
      ),
        parent_dir
    end
  end
end

return M
