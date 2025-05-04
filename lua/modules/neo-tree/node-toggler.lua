local M = {}
M.navigate_up = function(state)
  local node = state.tree:get_node()
  if (node.type == "directory" or node:has_children()) and node:is_expanded() then
    state.commands.toggle_node(state)
  else
    require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
  end
end

M.navigate_down = function(state)
  local node = state.tree:get_node()
  if node.type == "directory" or node:has_children() then
    if not node:is_expanded() then
      state.commands.toggle_node(state)
    else
      require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
    end
  end
end
return M
