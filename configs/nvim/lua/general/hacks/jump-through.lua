---@module "jump-through"
--- The file contains functions that allow a user to jump forward or backward
--- through a given pattern. It works like "f" / "t", but puttern may be
--- anything, it jumps multiline and through the pattern.

------------------------------------------------------------
-- Utility functions

local function on_last_column()
  local line, column = unpack(vim.api.nvim_win_get_cursor(0))
  local line_string = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
  return column == (line_string:len() - 1)
end

local function on_first_column()
  local _, current_column = unpack(vim.api.nvim_win_get_cursor(0))
  return current_column == 0
end

local function set_cursor_position(line_index, column_index)
  vim.api.nvim_win_set_cursor(0, { line_index, column_index })
end

local function get_search_skipper(count)
  local check = function()
    count = count - 1
    return count
  end
  return check
end

------------------------------------------------------------
-- Jump functions

local function jump_forward_through(pattern)
  local flags = "neW"
  if not on_last_column() then
    flags = flags .. "c"
  end

  -- Search pattern position
  local skipper = get_search_skipper(vim.v.count1)
  local line, column = unpack(vim.fn.searchpos(pattern, flags, nil, nil, skipper))

  -- Pattern wasn't found.
  if line == 0 then
    return
  end

  set_cursor_position(line, column)
end

local function jump_backward_through(pattern)
  local flags = "nbW"
  if not on_first_column() then
    flags = flags .. "c"
  end

  -- Search pattern position
  local skipper = get_search_skipper(vim.v.count1)
  local line, column = unpack(vim.fn.searchpos(pattern, flags, nil, nil, skipper))

  column = column - 2
  if column < 0 then
    column = 0
  end

  -- Pattern wasn't found.
  if line == 0 then
    return
  end

  set_cursor_position(line, column)
end

return {
  forward = function(pattern)
    return function()
      jump_forward_through(pattern)
    end
  end,

  backward = function(pattern)
    return function()
      jump_backward_through(pattern)
    end
  end,
}
