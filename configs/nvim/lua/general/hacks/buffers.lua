local function isValid(bufferId)
  if not bufferId or bufferId < 1 then
    return false
  end
  local exists = vim.api.nvim_buf_is_valid(bufferId)
  local listed = vim.bo[bufferId].buflisted
  return listed and exists
end

local function getIds()
  local bufferIds = vim.api.nvim_list_bufs()
  local validIds = {}
  for _, id in ipairs(bufferIds) do
    if isValid(id) then
      table.insert(validIds, id)
    end
  end
  return validIds
end

local function getBufferObject(id)
  local bufferObject = {}
  bufferObject.id = id

  bufferObject.name = function()
    local name = vim.api.nvim_buf_get_name(id)
    if name == "" then
      name = "[No Name]"
    else
      name = vim.fn.fnamemodify(name, ":t")
    end
    return name
  end

  bufferObject.isCurrent = function()
    return vim.api.nvim_win_get_buf(0) == id
  end

  bufferObject.isModified = function()
    return vim.bo[id].modified
  end

  bufferObject.isVisible = function()
    return vim.fn.bufwinid(id) ~= -1
  end

  return bufferObject
end

local function get()
  local bufferObjects = {}

  for _, id in ipairs(getIds()) do
    local bufferObject = getBufferObject(id)
    table.insert(bufferObjects, bufferObject)
  end
  return bufferObjects
end

return {
  get = get,
}
