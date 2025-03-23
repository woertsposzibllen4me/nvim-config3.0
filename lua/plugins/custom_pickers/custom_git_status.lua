local M = {}

function M.entry_maker(opts)
  opts = opts or {}
  local make_entry = require("telescope.make_entry")
  local entry_display = require("telescope.pickers.entry_display")
  local utils = require("telescope.utils")

  -- Get the default git status entry maker
  local git_status_entry = make_entry.gen_from_git_status(opts)

  local make_display = function(entry)
    local icon, icon_hl = utils.get_devicons(entry.value)

    local displayer = entry_display.create({
      separator = " ",
      items = {
        { width = 2 }, -- For git status (e.g., M, ??)
        { width = vim.fn.strdisplaywidth(icon) },
        { width = nil },
        { remaining = true },
      },
    })

    local name = entry.value and vim.fn.fnamemodify(entry.value, ":t") or "[No Name]"
    local display_path = ""

    if entry.value then
      local path = vim.fn.fnamemodify(entry.value, ":h")
      display_path = utils.transform_path({
        path_display = { shorten = { len = 3, exclude = { -1, -2, -3 } } },
      }, path)
    end

    return displayer({
      { entry.status or "  ", "TelescopeResultsIdentifier" },
      { icon, icon_hl },
      name,
      { display_path, "TelescopeResultsComment" },
    })
  end

  return function(entry)
    local result = git_status_entry(entry)

    if result then
      -- Check if this is an untracked file (starts with ??)
      if entry:sub(1, 2) == "??" then
        -- For untracked files, extract the file path
        local file_path = entry:sub(4) -- Remove the "?? " prefix

        -- Override the path for preview
        result.path = file_path
      end

      -- Store the git status
      result.status = entry:sub(1, 2)

      -- Use our custom display function
      result.display = make_display
    end

    return result
  end
end

return M
