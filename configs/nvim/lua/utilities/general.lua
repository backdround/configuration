local function autocmd(unique_group, event, options)
  options.group = unique_group
  vim.api.nvim_create_augroup(unique_group, { clear = true })

  vim.api.nvim_create_autocmd(event, options)
end

local function notify(message, time)
  time = time or "2000"
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

return {
  autocmd = autocmd,
  notify = notify,
  wrap = wrap,
  feedkeys = feedkeys,
  reset_current_mode = reset_current_mode,
}
