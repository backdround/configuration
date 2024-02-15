local assert_types = require("utilities.assert-types")

---@class User_ProfilerTime
---@field sec number count of seconds
---@field nsec number count of nanoseconds

---@return User_ProfilerTime
local get_time = function()
  ---@diagnostic disable-next-line: undefined-field, return-type-mismatch
  return vim.loop.clock_gettime("monotonic")
end

---Calculate elapsed time
---@param end_time User_ProfilerTime
---@param start_time User_ProfilerTime
---@return number milliseconds between end_time and start_time
local difftime = function(end_time, start_time)
  local sec = end_time.sec - start_time.sec
  local nsec = end_time.nsec - start_time.nsec
  return (nsec / 1000000) + sec * 1000
end

---@class User_ProfilerResult
---@field result any last function result
---@field time number elapsed milliseconds

---Performs the given function count of times and measure elapsed times
---@param fn fun(): any function to perform
---@param count? number count of times
---@return User_ProfilerResult
local profile = function(fn, count)
  assert_types({
    fn = { fn, "function" },
    count = { count, "number", "nil" }
  })

  count = count or 1
  local result = nil

  local start_time = get_time()
  for _ = 1, count do
    result = { fn() }
  end
  local end_time = get_time()

  local result_time = difftime(end_time, start_time)
  return { result = result, time = result_time }
end

return {
  profile = profile,
}
