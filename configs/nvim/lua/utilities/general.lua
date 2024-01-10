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
---@param wait_for_finish? boolean
M.feedkeys = function(keys, wait_for_finish)
  keys = tostring(keys)

  local flags = "n"
  if wait_for_finish then
    flags = "nx"
  end

  keys = replace_termcodes(keys)
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

return M
