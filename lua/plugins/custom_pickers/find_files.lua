local M = {}

function M.entry_maker(opts)
  opts = opts or {}
  local make_entry = require("telescope.make_entry")
  local entry_display = require("telescope.pickers.entry_display")
  local utils = require("telescope.utils")

  -- Load the FZF sorter
  require("telescope").extensions.fzf.native_fzf_sorter()

  -- Get the default file maker
  local plain_file_maker = make_entry.gen_from_file(opts)

  local make_display = function(entry)
    -- Get icon and its highlight
    local icon, icon_hl = utils.get_devicons(entry.name)

    local displayer = entry_display.create({
      separator = " ",
      items = {
        { width = vim.fn.strdisplaywidth(icon) },
        { width = nil },
        { remaining = true },
      },
    })

    -- Transform the path for display only with normal order
    local name = entry.filename and vim.fn.fnamemodify(entry.filename, ":t") or "[No Name]"

    local display_path = ""
    if entry.filename then
      local path = vim.fn.fnamemodify(entry.filename, ":h")

      display_path = utils.transform_path({
        path_display = { shorten = { len = 3, exclude = { -1, -2, -3 } } },
      }, path)
    end

    return displayer({
      { icon, icon_hl },
      name,
      { display_path, "TelescopeResultsComment" }, -- Using built-in gray highlight group
    })
  end

  -- Return the entry maker function
  return function(entry)
    -- First get the default entry properties
    local file_entry = plain_file_maker(entry)
    if file_entry == nil then
      return nil
    end

    -- Add our custom display while keeping all original entry data
    file_entry.name = vim.fn.fnamemodify(entry, ":t")
    file_entry.display = make_display

    return file_entry
  end
end

return M
