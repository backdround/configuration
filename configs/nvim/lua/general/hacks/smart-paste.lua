local u = require("utilities")

---Separate a line to indention and line content.
---@param line string
---@return string[]
local separate_line = function(line)
  local indention, trimmed_line = line:match("^(%s*)(.*)$")
  return { indention, trimmed_line }
end

---@param line string
---@return boolean
local only_whitespaces = function(line)
  return line:find("^%s*$") ~= nil
end

---Deduces how many spaces is one shiftwidth.
---@param lines string[]
---@return number
local deduce_lines_shiftwidth = function(lines)
  local indentions = {}
  for _, line in ipairs(lines) do
    local indention = separate_line(line)[1]
    table.insert(indentions, #indention)
  end

  table.sort(indentions)

  local shiftwidth = nil
  for i = 2, #indentions do
    local indention_difference = math.abs(indentions[i - 1] - indentions[i])
    if indention_difference ~= 0 then
      if shiftwidth == nil or indention_difference < shiftwidth then
        shiftwidth = indention_difference
      end
    end
  end

  return shiftwidth or 1
end

---@param lines string[]
---@return string[]
local remove_common_indention = function(lines)
  local minimal_indention = nil

  for _, line in ipairs(lines) do
    if line:len() ~= 0 then
      local line_indention = separate_line(line)[1]
      if minimal_indention == nil then
        minimal_indention = line_indention
      end

      if line_indention:len() < minimal_indention:len() then
        minimal_indention = line_indention
      end
    end
  end

  local common_indention = minimal_indention or ""

  local result_lines = {}

  for _, line in ipairs(lines) do
    local shrinked_line = line:gsub("^" .. common_indention, "")
    table.insert(result_lines, shrinked_line)
  end

  return result_lines
end

---Converts lines' indention whitespaces to buffer local type of indention.
---@class string[]
---@return string[]
local convert_indention_to_buffer_type = function(lines)
  local buffer_type = vim.opt.expandtab == true and "spaces" or "tabs"

  -- Get lines' type
  local lines_type = nil
  for i = 1, #lines do
    local indention = separate_line(lines[i])[1]
    if indention ~= "" then
      if indention:sub(1, 1) == "\t" then
        lines_type = "tabs"
        break
      elseif indention:sub(1, 1) == " " then
        lines_type = "spaces"
        break
      else
        -- Unknown type of indention
        return vim.deepcopy(lines)
      end
    end
  end

  if lines_type == nil then
    return vim.deepcopy(lines)
  end

  -- Convertion isn't required
  if lines_type == buffer_type then
    return vim.deepcopy(lines)
  end

  -- Convert
  local converted_lines = {}
  local shiftwidth = vim.fn.shiftwidth()
  local lines_shiftwidth = deduce_lines_shiftwidth(lines)

  for i = 1, #lines do
    local indention, line = unpack(separate_line(lines[i]))

    local new_indention = nil
    if lines_type == "tab" then
      new_indention = (" "):rep(shiftwidth * #indention)
    else
      new_indention = ("\t"):rep(math.ceil(#indention / lines_shiftwidth))
    end

    converted_lines[i] = new_indention .. line
  end

  return converted_lines
end

---@param lines string[]
---@param target_indention string The indention is considered as the first line indention
---@return string[]
local adjust_lines_indention_to_given_indention = function(lines, target_indention)
  local first_line_indention = separate_line(lines[1])[1]
  local indention_shift = #target_indention - #first_line_indention

  local indention_char = vim.opt.expandtab:get() == true and " " or "\t"

  local reindented_lines = {}
  for i = 1, #lines do
    local indention, line = unpack(separate_line(lines[i]))
    local new_indention = indention_char:rep(#indention + indention_shift)
    if line == "" then
      table.insert(reindented_lines, "")
    else
      table.insert(reindented_lines, new_indention .. line)
    end
  end

  return reindented_lines
end

---Pastes given register in insert mode
---The function should be mapped with: {
---  expr = true,
---  replace_keycodes = false,
---}
---@param register string
---@param auxiliary_register? string Register that is used for the work. It's "p" by default.
---@return string
local paste_register = function(register, auxiliary_register)
  local reginfo = vim.fn.getreginfo(register)
  auxiliary_register = auxiliary_register or "p"

  -- Check register validity
  if not reginfo or not reginfo.regcontents or #reginfo.regcontents == 0 then
    return ""
  end
  local lines = reginfo.regcontents

  -- Paste one line
  if #lines == 1 then
    local line = separate_line(lines[1])[2]

    if only_whitespaces(vim.api.nvim_get_current_line()) then
      return line .. u.replace_termcodes("<Cr>")
    end
    return line
  end

  -- Transform lines
  local transformed_lines = convert_indention_to_buffer_type(lines)
  transformed_lines = remove_common_indention(lines)

  local current_line = vim.api.nvim_get_current_line()
  local initial_indention = separate_line(current_line)[1]
  transformed_lines = adjust_lines_indention_to_given_indention(
    transformed_lines,
    initial_indention
  )

  -- Set lines as an auxiliary register to paste
  local result_text = separate_line(transformed_lines[1])[2] .. "\n"
  for i = 2, #transformed_lines do
    result_text = result_text .. transformed_lines[i] .. "\n"
  end

  vim.fn.setreg(auxiliary_register, result_text, "c")

  -- Calculate last indention
  local last_indention = initial_indention
  if vim.opt.expandtab:get() then
    local shiftwidth = vim.fn.shiftwidth()
    last_indention = ("\t"):rep(math.ceil(#last_indention / shiftwidth))
  end

  return u.replace_termcodes("<C-r><C-o>" .. auxiliary_register)
    .. last_indention
end

return paste_register
