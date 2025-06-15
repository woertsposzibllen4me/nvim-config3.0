return {
  "chrisgrieser/nvim-tinygit",
  dependencies = { "nvim-telescope/telescope.nvim" },
  cmd = { "Tinygit" },
  keys = {
    {
      "<leader>gi",
      "<cmd>Tinygit interactiveStaging<cr>",
      desc = "Interactive staging",
    },
    {
      "<leader>gc",
      "<cmd>Tinygit smartCommit<cr>",
      desc = "Smart commit",
    },
    {
      "<leader>gp",
      "<cmd>Tinygit push<cr>",
      desc = "Push",
    },
    {
      "<leader>ga",
      "<cmd>Tinygit amendOnlyMsg<cr>",
      desc = "Amend last commit message",
    },
    {
      "<leader>gA",
      "<cmd>Tinygit amendNoEdit<cr>",
      desc = "Amend last commit noEdit",
    },
    {
      "<leader>gH",
      "<cmd>Tinygit fileHistory<cr>",
      desc = "Grep history",
    },
    {
      "<leader>gU",
      "<cmd>Tinygit undoLastCommitOrAmend<cr>",
      desc = "Undo last commit or amend",
    },
    {
      "<leader>gF",
      "<cmd>Tinygit fixupCommit<cr>",
      desc = "Fixup commit",
    },
    {
      "<leader>gz",
      "<cmd>Tinygit stashPush<cr>",
      desc = "Stash changes",
    },
    {
      "<leader>gZ",
      "<cmd>Tinygit stashPop<cr>",
      desc = "Pop last stash",
    },
  },
}
