return {
  "artemave/workspace-diagnostics.nvim",
  keys = {
    {
      "<leader>xw",
      function()
        for _, client in ipairs(vim.lsp.get_clients()) do
          require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
        end
      end,
      desc = "Populate Workspace Diagnostics",
    },
  },
}
