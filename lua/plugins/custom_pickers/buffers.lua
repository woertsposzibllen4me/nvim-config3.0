local M = {}

function M.entry_maker(opts)
  opts = opts or {}
  local make_entry = require("telescope.make_entry")
  local entry_display = require("telescope.pickers.entry_display")
  local utils = require("telescope.utils")

  -- Load the FZF sorter
  require("telescope").extensions.fzf.native_fzf_sorter()

  -- Get the default buffer maker
  local plain_buffer_maker = make_entry.gen_from_buffer(opts)

  local make_display = function(entry)
    -- Get icon and its highlight
    local icon, icon_hl = utils.get_devicons(entry.filename or "")

    local displayer = entry_display.create({
      separator = " ",
      items = {
        { width = vim.fn.strdisplaywidth(icon) },
        { width = opts.bufnr_width or 4 },
        { width = nil },
        { remaining = true },
      },
    })

    -- Get just the filename
    local name = entry.filename and vim.fn.fnamemodify(entry.filename, ":t") or "[No Name]"

    -- Get the path for display, similar to find_files
    local display_path = ""
    if entry.filename then
      display_path = utils.transform_path({
        path_display = { shorten = { len = 3, exclude = { -1, -2, -3 } } },
      }, vim.fn.fnamemodify(entry.filename, ":h"))

      -- Remove everything after the last slash (if exists) to match find_files format
      display_path = display_path:match("(.+)\\[^\\]*$") or display_path
    end

    local indicators = {}
    if entry.indicator and entry.indicator ~= " " then
      table.insert(indicators, { entry.indicator, "TelescopeResultsSpecialComment" })
    end

    -- Final display
    return displayer({
      { entry.bufnr, "TelescopeResultsNumber" },
      { icon, icon_hl },
      name,
      { display_path, "TelescopeResultsComment" },
    })
  end

  -- Return the entry maker function
  return function(entry)
    -- First get the default entry properties
    local buffer_entry = plain_buffer_maker(entry)
    if buffer_entry == nil then
      return nil
    end

    -- Add our custom display while keeping all original entry data
    buffer_entry.display = make_display
    return buffer_entry
  end
end

return M
