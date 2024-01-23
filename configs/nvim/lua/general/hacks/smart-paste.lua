local u = require("utilities")

---@param lines string[]
---@return string[]
local function remove_common_prepending_gap(lines)
  local minimal_prepending_gap = nil

  for _, line in ipairs(lines) do
    if line:len() ~= 0 then
      local current_prepending_gap = line:match("^(%s*)")
      if minimal_prepending_gap == nil then
        minimal_prepending_gap = current_prepending_gap
      end

      if current_prepending_gap:len() < minimal_prepending_gap:len() then
        minimal_prepending_gap = current_prepending_gap
      end
    end
  end

  minimal_prepending_gap = minimal_prepending_gap or ""

  local result_lines = {}

  for _, line in ipairs(lines) do
    local shrinked_line = line:gsub("^" .. minimal_prepending_gap, "")
    table.insert(result_lines, shrinked_line)
  end

  return result_lines
end

---Pastes given register in insert mode
---The function should be mapped with { expr = true }.
---@param register string
---@return string
local paste_register = function(register)
  local reginfo = vim.fn.getreginfo(register)

  if
    not reginfo
    or not reginfo.regcontents
    or #reginfo.regcontents == 0
    or reginfo.regtype == nil
  then
    return ""
  end

  local lines = remove_common_prepending_gap(reginfo.regcontents)

  local line_is_empty = vim.api.nvim_get_current_line():find("^%s*$") ~= nil
  if not line_is_empty and #lines == 1 then
    return lines[1]
  end

  local cr = u.replace_termcodes("<Cr>")

  local result = ""
  for i = 1, #lines do
    result = result .. lines[i] .. cr
  end

  return result
end

return paste_register
