local M = {}

function M.generate_directory_template(dotted_path)
  local parent_path = dotted_path:match("(.+)%.[^%.]+$") or ""
  local new_dotted_path = parent_path .. ".NEW_NAME_PLACEHOLDER"

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
end

function M.generate_file_template(dotted_path)
  local module_path = dotted_path:match("(.+)%.[^%.]+$") or ""
  local new_dotted_path = module_path .. ".NEW_NAME_PLACEHOLDER"

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

return M
