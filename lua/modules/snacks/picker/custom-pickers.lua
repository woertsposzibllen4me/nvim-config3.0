local M = {}
local function qf_live_grep()
  local qflist = vim.fn.getqflist()
  local filetable = {}
  local hashlist = {}

  for _, value in pairs(qflist) do
    local name = vim.api.nvim_buf_get_name(value.bufnr)
    if not hashlist[name] then
      hashlist[name] = true
      table.insert(filetable, name)
    end
  end

  Snacks.picker.grep({
    dirs = filetable,
    live = true,
    title = "Live grep in QF files (" .. #filetable .. " files)",
  })
end

M.grep_quickfix = { "<leader>qg", qf_live_grep, desc = "grep Quickfix Files" }
return M
