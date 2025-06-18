return {
  function(picker)
    local current = picker.opts.and_search ~= false
    picker.opts.and_search = not current
    local status = picker.opts.and_search and "enabled" or "disabled"
    vim.notify("AND search " .. status, vim.log.levels.INFO)
    -- Trigger a refresh of the search
    picker:find()
  end,
}
