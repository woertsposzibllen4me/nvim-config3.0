return [[
id: rel-from-submodule
language: python
rule:
  pattern: from .%s.$$$SUBMODULES import $$$IMPORTS
fix: from .GRUGRENAME.$$$SUBMODULES import $$$IMPORTS
]]
