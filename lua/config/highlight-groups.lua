-- Less intrusive folding
vim.api.nvim_set_hl(0, "Folded", {
  -- bg = "#27283d",
  fg = "#5a5b5c",
})

-- Word diff
vim.api.nvim_set_hl(0, "DiffText", { bg = "#633f01" })

-- Clearer match in pickers
vim.api.nvim_set_hl(0, "CustomMatch", { fg = "#73ffdc", bold = true })
vim.api.nvim_set_hl(0, "CustomMatchFuzzy", { fg = "#f1ff73", bold = true })

-- Darker terminal
vim.api.nvim_set_hl(0, "CustomTerminalBg", { bg = "#1d243b" })

-- Sligthly more visible Copilot hints
vim.api.nvim_set_hl(0, "CopilotSuggestion", { fg = "#495169" })
vim.api.nvim_set_hl(0, "CopilotAnnotation", { fg = "#495169" })
