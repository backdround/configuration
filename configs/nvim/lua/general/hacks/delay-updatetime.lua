local function newUpdateTimeDelayer()
  local delayer = {
    realUpdateTime = vim.go.updatetime,
    _fakeUpdateTime = 9999,
    _timer = vim.loop.new_timer(),
    -- Saves id who blocks option last
    -- Used for fix timers overlapping (because of vim.schedule_wrap)
    _lastBlockerId = {},
  }

  function delayer:_block()
    if vim.go.updatetime ~= self._fakeUpdateTime then
      vim.go.updatetime = self._fakeUpdateTime
    end
  end

  function delayer:_unblock(blockerId)
    -- Allows to unblock only last blocker id
    if blockerId ~= self._lastBlockerId then
      return
    end

    if vim.go.updatetime == self.realUpdateTime then
      return
    end

    -- Restores updatetime value
    if vim.go.updatetime == self._fakeUpdateTime then
      vim.go.updatetime = self.realUpdateTime
      return
    end

    -- Real updatetime value has been changed
    self.realUpdateTime = vim.go.updatetime
  end

  function delayer:delay(time)
    local blockerId = {}
    self._lastBlockerId = blockerId
    self:_block()

    local unblock = vim.schedule_wrap(function()
      self:_unblock(blockerId)
    end)

    self._timer:stop()
    self._timer:start(time, 0, unblock)
  end

  return delayer
end
-- Create only one delayer instance
local updateTimeDelayer = newUpdateTimeDelayer()

local function delayUpdateTime(time)
  updateTimeDelayer:delay(time)
end

return delayUpdateTime
