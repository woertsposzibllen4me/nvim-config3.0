return {
  "aznhe21/actions-preview.nvim",
  opts = {
    backend = {
      "snacks",
      -- "telescope",
      -- "minipick",
      -- "nui",
    },
    snacks = {
      layout = require("modules.snacks.picker.custom-layouts").midscreen_dropdown_preview,
    },
  },
  keys = {
    {
      "<leader>cp",
      function()
        require("actions-preview").code_actions()
      end,
      desc = "Preview Code Actions",
      mode = { "n", "v" },
    },
  },
}
