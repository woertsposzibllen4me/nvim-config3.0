return [[
id: rel-from
language: python
rule:
  pattern: from .%s import $$$IMPORTS
fix: from .GRUGRENAME import $$$IMPORTS
---
id: rel-from-parent
language: python
rule:
  pattern: from .%s.%s import $$$IMPORTS
fix: from .%s.GRUGRENAME import $$$IMPORTS
]]
