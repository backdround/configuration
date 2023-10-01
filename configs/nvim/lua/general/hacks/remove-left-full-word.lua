-- Returns start and stop indices of a last word (space separated).
local function find_last_word_indices(line)
  local last_word_start, _ = line:find("[^%s]+%s*$")
  return line:find("[^%s]+", last_word_start)
end

-- Returns start and stop indices of a space gap at the end of the line.
-- If there is no space gap, then it returns "nil, nil"
local function find_gap_indices_at_the_end(line)
  return line:find("%s+$")
end

local function get_cursor_position()
  return unpack(vim.api.nvim_win_get_cursor(0))
end

local function get_line(line_number)
  return vim.api.nvim_buf_get_lines(0, line_number - 1, line_number, true)[1]
end

local function set_line(line_number, line)
  vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, true, { line })
end

local function remove_line(line_number)
  vim.api.nvim_buf_set_lines(0, line_number - 1, line_number, true, {})
end

local function get_line_width(line_number)
  local line = get_line(line_number)
  if line then
    return line:len()
  end
  return 0
end

local function remove_left_full_word()
  local line, column = get_cursor_position()
  local line_string = get_line(line)

  -- Lines before and after cursor.
  local left_part = line_string:sub(0, column)
  local right_part = line_string:sub(column + 1)

  -- Find a target index from which to cut part of the string.
  local target_index_to_cut = nil

  local last_gap_start_index, _ = find_gap_indices_at_the_end(left_part)
  local last_word_start_index, _ = find_last_word_indices(left_part)

  if last_word_start_index then
    target_index_to_cut = last_word_start_index
  elseif last_gap_start_index then
    target_index_to_cut = last_gap_start_index
  end

  -- Remove part of the string from the target index.
  if target_index_to_cut then
    -- Replace the line by new line with removed full word.
    local new_left_part = left_part:sub(1, target_index_to_cut - 1)
    local new_line = new_left_part .. right_part
    vim.api.nvim_buf_set_lines(0, line - 1, line, true, { new_line })

    -- Set cursor after deletion.
    vim.api.nvim_win_set_cursor(0, { line, target_index_to_cut - 1 })
    return
  end
  -- If there is nothing to cut then move to the previous line.

  local previous_line = line - 1
  if previous_line < 1 then
    return
  end

  -- Concatenates line with previous line.
  local previous_line_string = get_line(line - 1)
  local new_cursor_position = { previous_line, get_line_width(previous_line) }

  remove_line(line)
  set_line(previous_line, previous_line_string .. right_part)
  vim.api.nvim_win_set_cursor(0, new_cursor_position)
end

return remove_left_full_word
