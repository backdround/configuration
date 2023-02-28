local function fullmap(mode, lhs, rhs, optionsOrDesc)
  local options = {}
  if type(optionsOrDesc) == "table" then
    options = optionsOrDesc
  elseif type(optionsOrDesc) == "string" then
    options.desc = optionsOrDesc
  end

  if options.silent == nil then
    options.silent = true
  end

  if options.noremap == nil then
    options.noremap = true
  end

  vim.keymap.set(mode, lhs, rhs, options)
end

local mapTable = {}
local modes = { "n", "i", "v", "c", "t", "o", "x", "s" }
for _, mode in ipairs(modes) do
  mapTable[mode .. "map"] = function(lhs, rhs, options)
    fullmap(mode, lhs, rhs, options)
  end
end
mapTable["map"] = function(lhs, rhs, options)
  fullmap({ "n", "x", "o" }, lhs, rhs, options)
end

local function autocmd(uniqueGroup, event, options)
  options.group = uniqueGroup
  vim.api.nvim_create_augroup(uniqueGroup, { clear = true })

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

local function assertStringOrTable(value, name, level)
  if level then
    level = level + 1
  else
    level = 2
  end

  if type(name) ~= "string" then
    error("Name must be a string", 2)
  end

  if type(value) == "string" then
    return
  end

  if type(value) == "table" then
    return
  end

  error(name .. " must be a string or a table", level)
end

local function assertCallable(value, name, level)
  if level then
    level = level + 1
  else
    level = 2
  end

  if type(name) ~= "string" then
    error("Name must be a string", 2)
  end

  if vim.is_callable(value) then
    return
  end

  error(name .. " must be callable", level)
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

local function resetCurrentMode()
  if vim.fn.mode() ~= "n" then
    local keys = vim.api.nvim_replace_termcodes("<esc>", true, true, true)
    vim.api.nvim_feedkeys(keys, "n", false)
  end
end

local utilities = {
  autocmd = autocmd,
  notify = notify,
  assertStringOrTable = assertStringOrTable,
  assertCallable = assertCallable,
  wrap = wrap,
  feedkeys = feedkeys,
  resetCurrentMode = resetCurrentMode,
}

utilities = vim.tbl_extend("error", utilities, mapTable)
return utilities
