local M = {}

local replace_termcodes = function(key)
  return vim.api.nvim_replace_termcodes(key, true, false, true)
end

---Creates an autocmd with its own group.
---@param unique_group string
---@param event string
---@param options table
M.autocmd = function(unique_group, event, options)
  options.group = unique_group
  vim.api.nvim_create_augroup(unique_group, { clear = true })

  vim.api.nvim_create_autocmd(event, options)
end

---Sends a desktop notification.
---@param data any
---@param time? number
M.notify = function(data, time)
  data = vim.inspect(data)
  vim.fn.system({
    "notify-send",
    "-t",
    tostring(time) or "9000",
    data,
  })
end

---Binds a given function to parameters.
---@param f function
---@param ... any
---@return function
M.wrap = function(f, ...)
  local args = { ... }
  return function()
    f(unpack(args))
  end
end

---@param keys string|any
---@param flags? string
M.feedkeys = function(keys, flags)
  keys = tostring(keys)
  keys = replace_termcodes(keys)
  flags = flags or "n"
  vim.api.nvim_feedkeys(keys, flags, false)
end

M.reset_current_mode = function()
  local exit = replace_termcodes("<C-\\><C-n>")
  local escape = replace_termcodes("<Esc>")
  vim.api.nvim_feedkeys(exit, "nx", false)
  vim.api.nvim_feedkeys(escape, "n", false)
end

---Unites all given arrays.
---@param ... table arrays to concatenate
---@return table
M.array_extend = function(...)
  local output_array = {}

  for _, array in ipairs({ ... }) do
    for _, value in ipairs(array) do
      table.insert(output_array, value)
    end
  end

  return output_array
end

---@return "operator-pending"|"visual"|"normal"|"insert"
M.mode = function()
  local m = vim.api.nvim_get_mode().mode

  if m:find("o") then
    return "operator-pending"
  elseif m:find("[vV]") then
    return "visual"
  elseif m:find("i") then
    return "insert"
  else
    return "normal"
  end
end

---Performs an empty function on by a keymap.
---It's useful for setting v:count.
---@param mode string|table
M.perform_empty_keymap = function(mode)
  local label = "<Plug>(user-empty-stub)"
  vim.keymap.set(mode, label, function() end)
  M.feedkeys(label, "nx")
  vim.keymap.del(mode, label)
end

---@class Config_TypeAssert
---@field [1] any Real value
---@field [...] string Possible types

---@param data table<string, Config_TypeAssert>
M.assert_types = function(data)
  -- Data asserts
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
      if parameter_type == potential_type then
        ok = true
        break
      end
    end

    if not ok then
      local message = "The " .. name .. " must be " .. parameter[2]
      for i = 3,#parameter do
        message = message .. "|" .. parameter[i]
      end
      message = message .. " but it's " .. type(parameter[1])
      error(message, 2)
    end
  end
end

return M
