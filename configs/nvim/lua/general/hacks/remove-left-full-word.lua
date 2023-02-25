-- Returns start and stop indexes of a last word (space separated).
local function getLastWordIndexes(line)
  return line:find("[^%s]+%s*$")
end

local function getLine(lineNumber)
  return vim.api.nvim_buf_get_lines(0, lineNumber - 1, lineNumber, true)[1]
end

local function setLine(lineNumber, line)
  vim.api.nvim_buf_set_lines(0, lineNumber - 1, lineNumber, true, { line })
end

local function removeLine(lineNumber)
  vim.api.nvim_buf_set_lines(0, lineNumber - 1, lineNumber, true, {})
end

local function getLineWidth(lineNumber)
  local line = getLine(lineNumber)
  if line then
    return line:len()
  end
  return 0
end

local function removeLeftFullWord()
  local line, column = unpack(vim.api.nvim_win_get_cursor(0))
  local lineString = getLine(line)

  -- Lines before and after cursor.
  local leftPart = lineString:sub(0, column)
  local rightPart = lineString:sub(column + 1)

  local wordStartIndex, _ = getLastWordIndexes(leftPart)

  -- If there are no words before cursor
  if wordStartIndex == nil then
    local previousLine = line - 1
    if previousLine < 1 then
      return
    end

    -- Concatenates line with previous line
    local previousLineString = getLine(line - 1)
    local newCursorPosition = { previousLine, getLineWidth(previousLine) }

    removeLine(line)
    setLine(previousLine, previousLineString .. rightPart)
    vim.api.nvim_win_set_cursor(0, newCursorPosition)
    return
  end

  -- Replace the line by new line with removed full word.
  local newLeftPart = leftPart:sub(1, wordStartIndex - 1)
  local newLine = newLeftPart .. rightPart
  vim.api.nvim_buf_set_lines(0, line - 1, line, true, { newLine })

  -- Sets cursor after deletion
  vim.api.nvim_win_set_cursor(0, { line, wordStartIndex - 1 })
end

return removeLeftFullWord
