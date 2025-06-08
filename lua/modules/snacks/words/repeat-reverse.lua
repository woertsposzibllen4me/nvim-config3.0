local M = {}

function M.setup_snacks_words()
  if M.next_ref then
    return M.next_ref, M.prev_ref
  end

  local function next_ref()
    Snacks.words.jump(vim.v.count1)
  end

  local function prev_ref()
    Snacks.words.jump(-vim.v.count1)
  end

  M.next_ref, M.prev_ref = RepeatablePairs.track_pair(next_ref, prev_ref)

  return M.next_ref, M.prev_ref
end

return M
