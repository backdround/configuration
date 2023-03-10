local function on_last_column()
  local line, column = unpack(vim.api.nvim_win_get_cursor(0))
  local line_string = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
  return column == (line_string:len() - 1)
end

local function jump_through_forward(pattern)
  local flags = "neW"
  if not on_last_column() then
    flags = flags .. "c"
  end
  local line, col = unpack(vim.fn.searchpos(pattern, flags))

  if line == 0 then
    return
  end

  vim.api.nvim_win_set_cursor(0, { line, col })
end

local function on_first_column()
  local _, current_column = unpack(vim.api.nvim_win_get_cursor(0))
  return current_column == 0
end

local function jump_through_backward(pattern)
  local flags = "nbW"
  if not on_first_column() then
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
  vim.api.nvim_win_set_cursor(0, { line, col })
end

-- jump_through is suitable for jumps in/out of parentheses or quotes
local function jump_through(pattern, forward)
  if forward then
    jump_through_forward(pattern)
  else
    jump_through_backward(pattern)
  end
end

return jump_through
