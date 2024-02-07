local assert_types = require("utilities.assert-types")

---@class UserLogger
---@field log fun(self: UserLogger, message: string) Write a message in log
---@field get fun(self: UserLogger): string Returns remembered log
---@field [string] any Private fields

---Creates a new logger that writes in a file and remember current log.
---@param filename string Name for a file where the log is written.
---@param rewrite? boolean Rewrite an existing log.
---@return UserLogger
local new = function(filename, rewrite)
  assert_types({
    filename = { filename, "string" },
    append = { rewrite, "boolean", "nil" },
  })

  if rewrite == nil then
    rewrite = false
  end

  local logger = {
    _filepath = vim.fn.stdpath("log") .. "/" .. filename,
    _log = "",
  }

  if rewrite then
    os.remove(logger._filepath)
  end

  ---Write a message in log
  ---@param self UserLogger
  ---@param message string
  logger.log = function(self, message)
    assert_types({
      self = { self, "table" },
      message = { message, "string" },
    })

    -- Get message
    if self._something_was_logged == nil then
      self._something_was_logged = true
    else
      message = "\n" .. message
    end

    if message:len() > 0 and message:sub(-1) ~= "\n" then
      message = message .. "\n"
    end

    -- Remember it internaly
    self._log = self._log .. message

    -- Write to the log file
    local log_file, error_message = io.open(self._filepath, "a")
    if log_file == nil then
      error(error_message)
    end

    log_file:write(message)
    io.close(log_file)
  end

  ---Returns remembered log
  ---@param self UserLogger
  ---@return string log
  logger.get = function(self)
    assert_types({ self = { self, "table" } })
    return self._log
  end

  return logger
end

return {
  new = new
}
