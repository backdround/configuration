---@module "jump-to-line"
--- The file consists functions that allow user to move to starts or ends
--- of previous or next lines. It works like "-z" / "+z" / "+$" and so on,
--- but this works well with v:count and in operator-pending mode.

------------------------------------------------------------
-- Utility functions

local function is_operator_pending_mode()
  return vim.fn.mode(true):find("o") ~= nil
end

local function line(line_index)
  return vim.api.nvim_buf_get_lines(0, line_index - 1, line_index, true)[1]
end

local function current_line_index()
  local index, _ = unpack(vim.api.nvim_win_get_cursor(0))
  return index
end

local function current_column_index()
  local _, index = unpack(vim.api.nvim_win_get_cursor(0))
  return index
end

local function backward_line_index(count)
  count = math.max(1, count)

  local backward_line = current_line_index() - count
  backward_line = math.max(1, backward_line)

  return backward_line
end

local function forward_line_index(count)
  count = math.max(1, count)

  local forward_line = current_line_index() + count
  forward_line = math.min(vim.fn.line("$"), forward_line)

  return forward_line
end

local function first_symbol_index(line_index)
  return line(line_index):match("^%s*"):len()
end

local function last_symbol_index(line_index)
  return line(line_index):len()
end

local function select_region(row1, column1, row2, column2)
  vim.api.nvim_buf_set_mark(0, "<", row1, column1, {})
  vim.api.nvim_buf_set_mark(0, ">", row2, column2, {})
  vim.cmd("normal! gv")
end

------------------------------------------------------------
-- Jump functions

local function jump_to_start_of_previous_line()
  local target_line = backward_line_index(vim.v.count1)
  local target_column = first_symbol_index(target_line)

  if not is_operator_pending_mode() then
    vim.api.nvim_win_set_cursor(0, { target_line, target_column })
    return
  end

  local initial_column = current_column_index()
  local initial_line = current_line_index()

  if initial_line == 1 then
    return
  end

  if initial_column == 0 then
    initial_line = initial_line - 1
    initial_column = last_symbol_index(initial_line)
  else
    initial_column = initial_column - 1
  end

  select_region(initial_line, initial_column, target_line, target_column)
end


local function jump_to_end_of_previous_line()
  local target_line = backward_line_index(vim.v.count1)
  local target_column = last_symbol_index(target_line)

  if not is_operator_pending_mode() then
    vim.api.nvim_win_set_cursor(0, { target_line, target_column })
    return
  end

  local initial_column = current_column_index()
  local initial_line = current_line_index()

  if initial_line == 1 then
    return
  end

  if initial_column == 0 then
    initial_line = initial_line - 1
    initial_column = last_symbol_index(initial_line)
  else
    initial_column = initial_column - 1
  end

  select_region(initial_line, initial_column, target_line, target_column)
end

local function jump_to_start_of_next_line()
  local target_line = forward_line_index(vim.v.count1)
  local target_column = first_symbol_index(target_line)

  if not is_operator_pending_mode() then
    vim.api.nvim_win_set_cursor(0, { target_line, target_column })
    return
  end

  local initial_column = current_column_index()
  local initial_line = current_line_index()

  if initial_line == vim.fn.line("$") then
    return
  end

  if target_column == 0 then
    target_line = target_line - 1
    target_column = last_symbol_index(target_line)
  else
    target_column = target_column - 1
  end

  select_region(initial_line, initial_column, target_line, target_column)
end

local function jump_to_end_of_next_line()
  local target_line = forward_line_index(vim.v.count1)
  local target_column = last_symbol_index(target_line)

  if not is_operator_pending_mode() then
    vim.api.nvim_win_set_cursor(0, { target_line, target_column })
    return
  end

  local initial_column = current_column_index()
  local initial_line = current_line_index()

  if initial_line == vim.fn.line("$") then
    return
  end

  if last_symbol_index(target_line) == 0 then
    target_line = target_line - 1
    target_column = last_symbol_index(target_line)
  else
    target_column = target_column - 1
  end

  select_region(initial_line, initial_column, target_line, target_column)
end

local function jump_to_start_of_current_line()
  local target_line = current_line_index()
  local target_column = first_symbol_index(target_line)
  vim.api.nvim_win_set_cursor(0, { target_line, target_column })
end

return {
  start_previous = jump_to_start_of_previous_line,
  end_previous = jump_to_end_of_previous_line,
  start_next = jump_to_start_of_next_line,
  end_next = jump_to_end_of_next_line,
  start = jump_to_start_of_current_line,
}
