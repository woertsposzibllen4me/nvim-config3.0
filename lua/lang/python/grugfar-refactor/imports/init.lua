local yaml_docs = require("lang.python.grugfar-refactor.imports.yaml_docs")
local absolute_template = require("lang.python.grugfar-refactor.imports.absolute_template")
local elect = require("lang.python.grugfar-refactor.imports.elect")

local M = {}

function M.refactor_python_imports_absolute_elect(relative_path, is_directory, opts)
  opts = opts or {}

  local tpl = absolute_template.generate(relative_path, is_directory)
  local docs = yaml_docs.split_yaml_docs(tpl)

  elect.elect_rules(docs, function(winners)
    elect.open_final_from_winners(winners, { notify = opts.notify })
  end)
end

return M
