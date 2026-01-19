return [[
id: package
language: python
rule:
  pattern: import %s
  not:
    pattern: import %s.$$$SUBMODULES
fix: import %s
---
id: package-as
language: python
rule:
  pattern: import %s as $ALIAS
  not:
    pattern: import %s.$$$SUBMODULES as $ALIAS
fix: import %s as $ALIAS
---
id: from-package
language: python
rule:
  pattern: from %s import $$$IMPORTS
  not:
    pattern: from %s.$$$SUBMODULES import $$$IMPORTS
fix: from %s import $$$IMPORTS
---
id: from-package-as
language: python
rule:
  pattern: from %s import $IMPORT as $ALIAS
  not:
    pattern: from %s.$$$SUBMODULES import $IMPORT as $ALIAS
fix: from %s import $IMPORT as $ALIAS
---
id: submodules
language: python
rule:
  pattern: import %s.$$$SUBMODULES
fix: import %s.$$$SUBMODULES
---
id: submodules-as
language: python
rule:
  pattern: import %s.$$$SUBMODULES as $$$ALIAS
fix: import %s.$$$SUBMODULES as $$$ALIAS
---
id: from-submodules
language: python
rule:
  pattern: from %s.$$$SUBMODULES import $$$IMPORTS
fix: from %s.$$$SUBMODULES import $$$IMPORTS
---
id: from-submodules-as
language: python
rule:
  pattern: from %s.$$$SUBMODULES import $$$IMPORTS as $$$ALIAS
fix: from %s.$$$SUBMODULES import $$$IMPORTS as $$$ALIAS
]]
