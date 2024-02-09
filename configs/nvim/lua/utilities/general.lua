local assert_types = require("utilities.assert-types")
local M = {}

---@param key string
---@return string
M.replace_termcodes = function(key)
  assert_types({ key = { key, "string" } })
  return vim.api.nvim_replace_termcodes(key, true, false, true)
end

---Creates an autocmd with its own group.
---@param unique_group string
---@param event string|table
---@param options table
M.autocmd = function(unique_group, event, options)
  assert_types({
    unique_group = { unique_group, "string" },
    event = { event, "string", "table" },
    options = { options, "table" },
  })

  options.group = unique_group
  vim.api.nvim_create_augroup(unique_group, { clear = true })

  vim.api.nvim_create_autocmd(event, options)
end

---Sends a desktop notification.
---@param data any
---@param time? number|string
M.notify = function(data, time)
  assert_types({
    data = { data, "any" },
    time = { time, "number", "string", "nil" },
  })

  if type(data) ~= "string" then
    data = vim.inspect(data)
  end

  if data == "" then
    data = "{empty string}"
  end

  time = tostring(time or "30000")

  local notify_send = function(message)
    return vim
      .system({
        "notify-send",
        "-t",
        time,
        "--",
        message,
      }, {
        text = true,
      })
      :wait()
  end

  local result = notify_send(data)

  if result.stderr ~= "" then
    notify_send(result.stderr)
    vim.notify(data .. "\n")
  end
end

---Binds a given function to parameters.
---@param fn function
---@param ... any
---@return function
M.wrap = function(fn, ...)
  assert_types({ fn = { fn, "function" } })

  local args = { ... }
  return function(...)
    local united_args = M.array_extend(args, { ... })
    return fn(unpack(united_args))
  end
end

---@param keys string|any
---@param flags? string
M.feedkeys = function(keys, flags)
  assert_types({
    keys = { keys, "string" },
    flags = { flags, "string", "nil" },
  })

  keys = M.replace_termcodes(keys)
  flags = flags or "n"
  vim.api.nvim_feedkeys(keys, flags, false)
end

---Unites all given arrays.
---@param ... table arrays to concatenate
---@return table
M.array_extend = function(...)
  local arrays = { ... }
  for i, array in ipairs(arrays) do
    local array_name = ("arrays[%s]"):format(i)
    assert_types({ [array_name] = { array, "table" } })
  end

  local output_array = {}
  for _, array in ipairs(arrays) do
    for _, value in ipairs(array) do
      table.insert(output_array, value)
    end
  end

  return output_array
end

---Requires the given module even if the module has been required once.
---@param path string
---@return any
M.load = function(path)
  package.loaded[path] = nil
  return require(path)
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

return M
