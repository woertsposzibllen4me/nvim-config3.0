local M = {}

function M.entry_maker(opts)
  opts = opts or {}
  local make_entry = require("telescope.make_entry")
  local entry_display = require("telescope.pickers.entry_display")
  local utils = require("telescope.utils")
  -- Load the FZF sorter
  require("telescope").extensions.fzf.native_fzf_sorter()
  -- Get the default grep maker
  local plain_grep_maker = make_entry.gen_from_vimgrep(opts)

  local make_display = function(entry)
    -- Get icon and its highlight
    local icon, icon_hl = utils.get_devicons(entry.filename)

    -- Get filename and path separately
    local filename = vim.fn.fnamemodify(entry.filename, ":t")
    local path = vim.fn.fnamemodify(entry.filename, ":h")

    -- Transform the path for display
    local display_path = utils.transform_path({
      path_display = { shorten = { len = 3, exclude = { -1, 2 } } },
    }, path)

    local line_col = entry.lnum .. ":" .. entry.col
    local line_col_width = vim.fn.strdisplaywidth(line_col)

    local displayer = entry_display.create({
      separator = " ",
      items = {
        { width = vim.fn.strdisplaywidth(icon) }, -- icon width
        { width = #filename },
        { width = line_col_width },
        { remaining = true },
        { width = #display_path },
      },
    })

    return displayer({
      { icon, icon_hl },
      { filename },
      { line_col, "TelescopeResultsNumber" },
      { entry.text:gsub("^%s+", ""), "TelescopeResultsIdentifier" },
      { display_path, "TelescopeResultsComment" },
    })
  end

  -- Return the entry maker function
  return function(entry)
    -- First get the default entry properties
    local grep_entry = plain_grep_maker(entry)
    if grep_entry == nil then
      return nil
    end
    -- Add our custom display while keeping all original entry data
    grep_entry.display = make_display
    return grep_entry
  end
end

return M
