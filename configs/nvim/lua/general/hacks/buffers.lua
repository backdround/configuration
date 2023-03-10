local function is_valid(buffer_id)
  if not buffer_id or buffer_id < 1 then
    return false
  end
  local exists = vim.api.nvim_buf_is_valid(buffer_id)
  local listed = vim.bo[buffer_id].buflisted
  return listed and exists
end

local function get_ids()
  local buffer_ids = vim.api.nvim_list_bufs()
  local valid_ids = {}
  for _, id in ipairs(buffer_ids) do
    if is_valid(id) then
      table.insert(valid_ids, id)
    end
  end
  return valid_ids
end

local function get_buffer_object(id)
  local buffer_object = {}
  buffer_object.id = id

  buffer_object.name = function()
    local name = vim.api.nvim_buf_get_name(id)
    if name == "" then
      name = "[No Name]"
    else
      name = vim.fn.fnamemodify(name, ":t")
    end
    return name
  end

  buffer_object.is_current = function()
    return vim.api.nvim_win_get_buf(0) == id
  end

  buffer_object.is_modified = function()
    return vim.bo[id].modified
  end

  buffer_object.is_visible = function()
    return vim.fn.bufwinid(id) ~= -1
  end

  return buffer_object
end

local function get()
  local buffer_objects = {}

  for _, id in ipairs(get_ids()) do
    local buffer_object = get_buffer_object(id)
    table.insert(buffer_objects, buffer_object)
  end
  return buffer_objects
end

return {
  get = get,
}
