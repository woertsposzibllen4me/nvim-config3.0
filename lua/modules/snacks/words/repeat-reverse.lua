local M = {}

function M.setup_snacks_words()
  if M.next_ref then
    return M.next_ref, M.prev_ref
  end

  M.next_ref, M.prev_ref = RepeatablePairs.track_pair(function()
    Snacks.words.jump(vim.v.count1)
  end, function()
    Snacks.words.jump(-vim.v.count1)
  end)

  return M.next_ref, M.prev_ref
end

return M
