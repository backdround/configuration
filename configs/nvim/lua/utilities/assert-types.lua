---@class UserTypeAssert
---@field [1] any Real value
---@field [number] string Possible types (or "any")

---@param data table<string, UserTypeAssert>
---@param error_level? number error level
local assert_types = function(data, error_level)
  error_level = error_level or 3

  -- Parameter asserts
  if type(error_level) ~= "number" then
    error("The given level must be a number or nil", 2)
  end

  if type(data) ~= "table" then
    error("The given validation data must be a table", 2)
  end

  for name, parameter in pairs(data) do
    if type(name) ~= "string" then
      local message = "The validation name must be a string, but it's "
        .. type(name)
      error(message, 2)
    end

    if #parameter < 2 then
      error(name .. " possible types aren't set", 2)
    end

    for i = 2,#parameter do
      local potential_type = parameter[i]
      if type(potential_type) ~= "string" then
        error("The validation type must be a string", 2)
      end
    end
  end

  -- Type checks
  for name, parameter in pairs(data) do
    local parameter_type = type(parameter[1])
    local ok = false
    for i = 2,#parameter do
      local potential_type = parameter[i]
      if parameter_type == potential_type or potential_type == "any" then
        ok = true
        break
      end
    end

    if not ok then
      local message = "The " .. name .. " must be a " .. parameter[2]
      for i = 3,#parameter do
        message = message .. "|" .. parameter[i]
      end
      message = message .. " but it's a " .. type(parameter[1])
      message = message .. ": \n" .. vim.inspect(parameter[1])
      error(message, error_level)
    end
  end
end

return assert_types
