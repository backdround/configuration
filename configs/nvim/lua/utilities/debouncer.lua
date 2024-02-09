---Creates a new debouncer
---@param on_start? function to perform on run
---@param on_finish function to perform after timeout
---@param timeout number ms time to wait before performing on_finish
---@return table
local function new(on_start, on_finish, timeout)
  local d = {
    _timer = vim.loop.new_timer(),
    _running = false,
    _last_finisher_id = 0,

    on_start = on_start,
    on_finish = on_finish,
    timeout = timeout,
  }

   d.run = function()
    if not d._running and d.on_start ~= nil then
      d.on_start()
    end

    local finisher_id = d._last_finisher_id + 1
    d._last_finisher_id = finisher_id

    local finisher = vim.schedule_wrap(function()
      -- Allow to finish only last finisher
      if finisher_id ~= d._last_finisher_id then
        return
      end

      d._running = false
      d.on_finish()
    end)

    d._running = true
    d._timer:stop()
    d._timer:start(timeout, 0, finisher)
  end

  return d
end

return {
  new = new,
}
