local M = {}

local function get_instance_by_name_safe(grug_far, name)
  local ok, inst = pcall(grug_far.get_instance, name)
  if not ok then
    return nil
  end
  return inst
end

function M.wait_for_instance(grug_far, name, cb, opts)
  opts = opts or {}
  local interval = opts.interval_ms or 25

  local function step()
    local inst = get_instance_by_name_safe(grug_far, name)
    if inst and inst:is_valid() then
      cb(inst)
      return
    end
    vim.defer_fn(step, interval)
  end

  step()
end

function M.wait_for_search_terminal(inst, cb, opts)
  opts = opts or {}
  local interval = opts.interval_ms or 20

  local function step()
    if not inst or not inst:is_valid() then
      cb(false, { matches = 0, files = 0 }, "invalid")
      return
    end

    local info = inst:get_status_info() or {}
    local status = info.status
    local stats = info.stats or { matches = 0, files = 0 }

    if status == "progress" then
      vim.defer_fn(step, interval)
      return
    end

    if status == "success" then
      cb(true, stats, "success")
      return
    end

    if status == "error" then
      cb(false, stats, "error")
      return
    end

    vim.defer_fn(step, interval)
  end

  step()
end

return M
