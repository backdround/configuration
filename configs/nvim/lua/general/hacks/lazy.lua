local M = {}

---@param modes string
---@param keys table
M.generate_keys = function(modes, keys)
  vim.validate({
    modes = { modes, "string" },
    keys = { keys, "table" }
  })

  local mode = {}
  for i = 1, #modes do
    local m = modes:sub(i, i)
    table.insert(mode, m)
  end

  local output_keys = {}
  for _, key in ipairs(keys) do
    table.insert(output_keys, {
      key,
      mode = mode,
    })
  end

  return output_keys
end

return M
