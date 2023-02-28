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

return {
  assertStringOrTable = assertStringOrTable,
  assertCallable = assertCallable,
}
