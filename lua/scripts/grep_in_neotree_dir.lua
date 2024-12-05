local function live_grep_neotree_dir()
  -- Get the neo-tree state
  local state = require("neo-tree.sources.manager").get_state("filesystem")
  if not state then
    return
  end
  -- Get the node under the cursor
  local node = state.tree:get_node()
  if not node then
    return
  end
  local path
  if node.type == "directory" then
    path = node:get_id()
  elseif node.type == "file" then
    path = vim.fn.fnamemodify(node:get_id(), ":h")
  else
    print("Not a file or directory")
    return
  end

  -- Create a title for the picker
  local title = "Grep in: " .. vim.fn.fnamemodify(path, ":~:.")

  -- Use Telescope to live_grep in the selected directory with a custom title
  require("telescope.builtin").live_grep({
    search_dirs = { path },
    prompt_title = title,
    entry_maker = require("plugins.custom_pickers.live_grep").entry_maker(),
    layout_strategy = "vertical",
  })
end

-- Set up the keymap
vim.api.nvim_create_autocmd("FileType", {
  pattern = "neo-tree",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "<leader>sG", "", {
      noremap = true,
      silent = true,
      callback = live_grep_neotree_dir,
      desc = "Live grep in neotree node",
    })
  end,
})
