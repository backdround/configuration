local function inBound(value, min, max)
  if value < min then
    return min
  end

  if value > max then
    return max
  end

  return value
end

local function onLastColumn()
  local line, column = unpack(vim.api.nvim_win_get_cursor(0))
  local lineString =  vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
  return column == (lineString:len() - 1)
end

local function jumpThroughForward(pattern)
  local flags = "neW"
  if not onLastColumn() then
    flags = flags .. "c"
  end
  local line, col = unpack(vim.fn.searchpos(pattern, flags))

  if line == 0 then
    return
  end

  vim.api.nvim_win_set_cursor(0, {line, col})
end

local function onFirstColumn()
  local _, currentColumn = unpack(vim.api.nvim_win_get_cursor(0))
  return currentColumn == 0
end

local function jumpThroughBackward(pattern)
  local flags = "nbW"
  if not onFirstColumn() then
    flags = flags .. "c"
  end
  local line, col = unpack(vim.fn.searchpos(pattern, flags))

  if line == 0 then
    return
  end

  col = col - 2
  if col < 0 then
    col = 0
  end
  vim.api.nvim_win_set_cursor(0, {line, col})
end

-- jumpThrough is suitable for jumps in/out of parentheses or quotes
local function jumpThrough(pattern, forward)
  if forward then
    jumpThroughForward(pattern)
  else
    jumpThroughBackward(pattern)
  end
end

return jumpThrough
