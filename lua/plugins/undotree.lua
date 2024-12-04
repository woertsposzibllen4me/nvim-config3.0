vim.g.undotree_DiffCommand = "FC"
return {
  "mbbill/undotree",
  cmd = "UndotreeToggle",
  keys = {
    {
      "<leader>U",
      "<cmd>UndotreeToggle | UndotreeFocus <cr>",
      desc = "Toggle Undotree",
    },
  },
}
