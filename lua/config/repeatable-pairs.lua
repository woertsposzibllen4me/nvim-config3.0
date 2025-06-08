-- This module allows to create pairs of functions that can be repeated or inverted.
local M = {}

-- Track last function and its opposite
local last_func = nil
local last_opposite = nil

local function repeat_last()
  if last_func then
    last_func()
  end
end

local function repeat_opposite()
  if last_opposite then
    last_opposite()
  end
end

-- Main function to create trackable pairs
function M.track_pair(func1, func2)
  local tracked1 = function()
    last_func = func1
    last_opposite = func2
    func1()
  end

  local tracked2 = function()
    last_func = func2
    last_opposite = func1
    func2()
  end

  return tracked1, tracked2
end

-- Setup repeat binds
function M.setup()
  -- f13 is setup in an ahk script to send F13 on <c-;> and <c-,> keypresses (not bindable in Neovim)
  vim.keymap.set({ "n", "t" }, "<F13>", repeat_last, { desc = "Repeat last" })
  vim.keymap.set({ "n", "t" }, "<S-F13>", repeat_opposite, { desc = "Repeat opposite" })
end

return M
