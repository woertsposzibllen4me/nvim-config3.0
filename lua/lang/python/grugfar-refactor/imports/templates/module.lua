return [[
id: module
language: python
rule:
  pattern: import %s
  not:
    pattern: import %s.$$$SUBMODULES
fix: import %s
---
id: module-as
language: python
rule:
  pattern: import %s as $ALIAS
  not:
    pattern: import %s.$$$SUBMODULES as $ALIAS
fix: import %s as $ALIAS
---
id: from-module
language: python
rule:
  pattern: from %s import $$$IMPORTS
  not:
    pattern: from %s.$$$SUBMODULES import $$$IMPORTS
fix: from %s import $$$IMPORTS
---
id: from-module-as
language: python
rule:
  pattern: from %s import $IMPORT as $ALIAS
  not:
    pattern: from %s.$$$SUBMODULES import $IMPORT as $ALIAS
fix: from %s import $IMPORT as $ALIAS
---
id: from-parent
language: python
rule:
  pattern: from %s import %s
fix: from %s import GRUGRENAME
---
id: from-parent-as
language: python
rule:
  pattern: from %s import %s as $ALIAS
fix: from %s import GRUGRENAME as $ALIAS
---
id: from-parent-as-()
language: python
rule:
  pattern: |
    from %s import (
        %s as $ALIAS
    )
fix: |
  from %s import (
      GRUGRENAME as $ALIAS
  )
---
id: from-parent-a,b,c
language: python
rule:
  pattern: from %s import $$$PRE, %s, $$$POST
fix: from %s import $$$PRE, GRUGRENAME, $$$POST
]]
