------------------------------------------------------------
-- Utility functions

-- Returns start and stop indices of a last big word (space separated).
local function find_last_big_word_indices(s)
  local result = s:match("[^%s]+%s*$")
  if result then
    return s:find("[^%s]+%s*$")
  else
    return s:find("%s+$")
  end
end

-- Returns start and stop indices of a first big word (space separated).
local function find_first_big_word_indices(s)
  local result = s:match("^%s*[^%s]+")
  if result then
    return s:find("^%s*[^%s]+")
  else
    return s:find("^%s+")
  end
end

local function get_cursor_position()
  return unpack(vim.api.nvim_win_get_cursor(0))
end

local function set_cursor_position(line_index, column_index)
  vim.api.nvim_win_set_cursor(0, { line_index, column_index })
end

local function get_line(line_index)
  return vim.api.nvim_buf_get_lines(0, line_index - 1, line_index, true)[1]
end

local function set_line(line_index, line)
  vim.api.nvim_buf_set_lines(0, line_index - 1, line_index, true, { line })
end

local function delete_line(line_index)
  vim.api.nvim_buf_set_lines(0, line_index - 1, line_index, true, {})
end

local function get_last_line_index()
  return vim.fn.line("$")
end

local function concatenate_two_lines(forward)
  -- Get first line to concatenate.
  local first_line_index , _ = get_cursor_position()
  if not forward then
    first_line_index = first_line_index - 1
  end
  if first_line_index < 1 then
    return
  end

  -- Get second line to concatenate.
  local second_line_index = first_line_index + 1
  if second_line_index > get_last_line_index() then
    return
  end

  -- Concatenate lines
  local new_line = get_line(first_line_index) .. get_line(second_line_index)
  local first_line_width = get_line(first_line_index):len()

  set_line(first_line_index, new_line)
  delete_line(second_line_index)

  set_cursor_position(first_line_index, first_line_width)
end

local function delete_string_to_position(target_column_index)
  local cursor_line_index, cursor_column_index = get_cursor_position()
  local line = get_line(cursor_line_index)

  local min = math.min(cursor_column_index, target_column_index)
  local max = math.max(cursor_column_index, target_column_index)

  if target_column_index <= cursor_column_index then
    local final_line = line:sub(0, min - 1) .. line:sub(max + 1)
    set_line(cursor_line_index, final_line)
    set_cursor_position(cursor_line_index, target_column_index - 1)
  else
    local final_line = line:sub(0, min) .. line:sub(max + 1)
    set_line(cursor_line_index, final_line)
  end
end

------------------------------------------------------------
-- Delete functions

local function delete_left_big_word()
  local line_index, column_index = get_cursor_position()
  local line = get_line(line_index)

  local left_part = line:sub(0, column_index)
  local target_index, _ = find_last_big_word_indices(left_part)

  if target_index == nil then
    concatenate_two_lines(false)
  else
    delete_string_to_position(target_index)
  end
end

local function delete_right_big_word()
  local line_index, column_index = get_cursor_position()
  local line = get_line(line_index)

  local right_part = line:sub(column_index + 1)
  local _, target_index = find_first_big_word_indices(right_part)

  if target_index == nil then
    concatenate_two_lines(true)
  else
    delete_string_to_position(target_index + column_index)
  end
end

return {
  full_left = delete_left_big_word,
  full_right = delete_right_big_word,
}
