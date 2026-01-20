local function noop() end
return _G.Logger or { debug = noop, info = noop, warn = noop, error = noop }
