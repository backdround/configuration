local function new_update_time_delayer()
  local delayer = {
    _fake_update_time = 9999,
    _timer = vim.loop.new_timer(),
    -- Saves id who blocks option last
    -- Used for fix timers overlapping (because of vim.schedule_wrap)
    _last_blocker_id = {},
  }

  function delayer:_block()
    if vim.go.updatetime ~= self._fake_update_time then
      vim.go.updatetime = self._fake_update_time
    end
  end

  function delayer:_unblock(blocker_id, real_update_time)
    -- Allows to unblock only last blocker id
    if blocker_id ~= self._last_blocker_id then
      return
    end

    if vim.go.updatetime == real_update_time then
      return
    end

    vim.go.updatetime = real_update_time
  end

  function delayer:delay(time, real_update_time)
    local blocker_id = {}
    self._last_blocker_id = blocker_id
    self:_block()

    local unblock = vim.schedule_wrap(function()
      self:_unblock(blocker_id, real_update_time)
    end)

    self._timer:stop()
    self._timer:start(time, 0, unblock)
  end

  return delayer
end
-- Create only one delayer instance
local update_time_delayer = new_update_time_delayer()

local function delay_update_time(time, real_update_time)
  update_time_delayer:delay(time, real_update_time)
end

return delay_update_time
