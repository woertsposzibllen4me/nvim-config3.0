--- This module allows to create pairs of functions that can be repeated or inverted.
--- Integrates with nvim-treesitter-textobjects repeatable move system.
local M = {}

-- Lazy load the treesitter repeat module when needed
local ts_repeat_move = nil
local function get_ts_repeat_move()
  if ts_repeat_move == nil then
    local ok, module = pcall(require, "nvim-treesitter.textobjects.repeatable_move")
    ts_repeat_move = ok and module or false -- false means we tried and failed
  end
  return ts_repeat_move ~= false and ts_repeat_move or nil
end

--- @type function?
local last_func = nil
--- @type function?
local last_opposite = nil

--- Repeat the last executed function (fallback implementation)
local function repeat_last()
  if last_func then
    last_func()
  end
end

--- Execute the opposite of the last executed function (fallback implementation)
local function repeat_opposite()
  if last_opposite then
    last_opposite()
  end
end

--- Create a pair of trackable functions that remember each other as opposites.
--- Uses the treesitter repeat module if available, otherwise falls back to a local implementation
--- which uses <C-;> to repeat the last function and <C-,> to repeat the opposite.
--- @param func1 function First function in the pair
--- @param func2 function Second function in the pair (opposite of func1)
--- @return function tracked1 Wrapped version of func1 that tracks state
--- @return function tracked2 Wrapped version of func2 that tracks state
function M.track_pair(func1, func2)
  local ts_repeat = get_ts_repeat_move()

  if ts_repeat and ts_repeat.make_repeatable_move_pair then
    return ts_repeat.make_repeatable_move_pair(func1, func2)
  end

  vim.notify(
    "nvim-treesitter.textobjects.repeatable_move not found, using fallback implementation",
    vim.log.levels.WARN
  )

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

--- Setup repeat keybinds.
--- We're using F13 and Shift+F13 since we cannot bind Ctrl+; and Ctrl+,
--- directly in Neovim. F13 is setup in an AHK script to send F13 on Ctrl+; and
--- S-F13 on Ctrl+, keypresses
function M.setup()
  vim.keymap.set({ "n", "t" }, "<F13>", repeat_last, { desc = "Repeat last" })
  vim.keymap.set({ "n", "t" }, "<S-F13>", repeat_opposite, { desc = "Repeat opposite" })
end

return M
