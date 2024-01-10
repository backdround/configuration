local function autocmd(unique_group, event, options)
  options.group = unique_group
  vim.api.nvim_create_augroup(unique_group, { clear = true })

  vim.api.nvim_create_autocmd(event, options)
end

local function notify(message, time)
  time = time or "4000"
  vim.fn.system({
    "notify-send",
    "-t",
    tostring(time),
    message,
  })
end

local function wrap(f, ...)
  local args = { ... }
  return function()
    f(unpack(args))
  end
end

local function feedkeys(keys)
  keys = vim.api.nvim_replace_termcodes(keys, true, true, true)
  vim.api.nvim_feedkeys(keys, "n", false)
end

local function reset_current_mode()
  local keys = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
  vim.api.nvim_feedkeys(keys, "nx", false)
end

local function array_concatenate(array1, array2)
  local output_array = {}

  for _, value in ipairs(array1) do
    table.insert(output_array, value)
  end

  for _, value in ipairs(array2) do
    table.insert(output_array, value)
  end

  return output_array
end

return {
  autocmd = autocmd,
  notify = notify,
  wrap = wrap,
  feedkeys = feedkeys,
  reset_current_mode = reset_current_mode,
  array_concatenate = array_concatenate,
}
