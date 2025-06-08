--- This module allows to create pairs of functions that can be repeated or inverted.
--- @class RepeatablePairs
local M = {}

--- Track last function and its opposite
--- @type function?
local last_func = nil
--- @type function?
local last_opposite = nil

--- Repeat the last executed function
local function repeat_last()
  if last_func then
    last_func()
  end
end

--- Execute the opposite of the last executed function
local function repeat_opposite()
  if last_opposite then
    last_opposite()
  end
end

--- Create a pair of trackable functions that remember each other as opposites.
--- We can then repeat the functions with <C-;> or reverse them with <C-,>
--- @param func1 function First function in the pair
--- @param func2 function Second function in the pair (opposite of func1)
--- @return function tracked1 Wrapped version of func1 that tracks state
--- @return function tracked2 Wrapped version of func2 that tracks state
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

--- Setup repeat keybinds. We're using F13 and Shift+F13 since we cannot bind
--- Ctrl+; and Ctrl+ directly in Neovim.
--- F13 is setup in an AHK script to send F13 on Ctrl+; and Ctrl+, keypresses
function M.setup()
  vim.keymap.set({ "n", "t" }, "<F13>", repeat_last, { desc = "Repeat last" })
  vim.keymap.set({ "n", "t" }, "<S-F13>", repeat_opposite, { desc = "Repeat opposite" })
end

return M
