---@module "delete-word"
--- The file contains functions that allow a user to delete a full or a simple
--- word to the left or to the right. It is similar to <C-w>, but it works to
--- any direction and it's more reliable (doesn't depend on just inserted text).

------------------------------------------------------------
-- Utility functions

-- Returns start index of a last big word (space separated).
local function find_last_big_word_start(s)
  local word_start = s:find("[^%s]+%s*$")
  local space_start = s:find("%s+$")
  return word_start or space_start
end

-- Returns start index of a first big word (space separated).
local function find_first_big_word_stop(s)
  local _, word_stop = s:find("^%s*[^%s]+")
  local _, space_stop = s:find("^%s+")
  return word_stop or space_stop
end

-- Returns start index of a last word.
local function find_last_word_start(s)
  local word_start = s:find("[a-zA-Z0-9_]+%s*$")
  local non_word_start = s:find("[^a-zA-Z0-9_%s]+%s*$")
  local space_start = s:find("%s+$")
  return word_start or non_word_start or space_start
end

-- Returns end index of a first word.
local function find_first_word_stop(s)
  local _, word_stop = s:find("^%s*[a-zA-Z0-9_]+")
  local _, non_word_stop = s:find("^%s*[^a-zA-Z0-9_%s]+")
  local _, space_stop = s:find("^%s+")
  return word_stop or non_word_stop or space_stop
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

local function wrap(f, ...)
  local args = {...}
  return function()
    return f(unpack(args))
  end
end

local function concatenate_two_lines(forward)
  -- Get lines to concatenate.
  local first_line_index , _ = get_cursor_position()
  if not forward then
    first_line_index = first_line_index - 1
  end
  local second_line_index = first_line_index + 1

  -- Check out of file
  if first_line_index < 1 or second_line_index > get_last_line_index() then
    return
  end

  -- Set cursor
  local first_line_width = get_line(first_line_index):len()
  set_cursor_position(first_line_index, first_line_width)

  -- Concatenate lines
  local new_line = get_line(first_line_index) .. get_line(second_line_index)
  set_line(first_line_index, new_line)
  delete_line(second_line_index)
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

local function perform_deletion(forward, find_target_column)
  local line_index, column_index = get_cursor_position()
  local line = get_line(line_index)

  -- get target_column
  local target_column
  if forward then
    local right_part = line:sub(column_index + 1)
    target_column = find_target_column(right_part)
  else
    local left_part = line:sub(0, column_index)
    target_column = find_target_column(left_part)
  end

  -- If there is no match, then concatenate two lines
  if target_column == nil then
    concatenate_two_lines(forward)
    return
  end

  if forward then
    target_column = target_column + column_index
  end
  delete_string_to_position(target_column)
end

return {
  left = wrap(perform_deletion, false, find_last_word_start),
  right = wrap(perform_deletion, true, find_first_word_stop),
  full_left = wrap(perform_deletion, false, find_last_big_word_start),
  full_right = wrap(perform_deletion, true, find_first_big_word_stop),
}
