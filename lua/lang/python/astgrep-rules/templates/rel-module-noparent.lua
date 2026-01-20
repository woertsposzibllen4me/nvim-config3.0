return [[
id: rel-from
language: python
rule:
  pattern: from .%s import $$$IMPORTS
fix: from .GRUGRENAME import $$$IMPORTS
]]
