-- Store original DiffText highlight
local original_difftext = nil

local word_diff_toggle = Snacks.toggle.new({
  name = "Word Diff Highlighting",
  get = function()
    local difftext_hl = vim.api.nvim_get_hl(0, { name = "DiffText" })
    return difftext_hl.link ~= "DiffChange"
  end,
  set = function(state)
    local difftext_hl = vim.api.nvim_get_hl(0, { name = "DiffText" })

    if state then
      -- Turn ON word diff - restore original highlighting
      if original_difftext then
        vim.api.nvim_set_hl(0, "DiffText", original_difftext)
      else
        vim.api.nvim_set_hl(0, "DiffText", { link = "" })
      end
    else
      -- Turn OFF word diff - store current and link to DiffChange
      original_difftext = {
        fg = difftext_hl.fg,
        bg = difftext_hl.bg,
        bold = difftext_hl.bold,
        italic = difftext_hl.italic,
        underline = difftext_hl.underline,
      }
      vim.api.nvim_set_hl(0, "DiffText", { link = "DiffChange" })
    end
  end,
})

return word_diff_toggle
