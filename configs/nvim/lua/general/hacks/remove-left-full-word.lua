-- Returns start and stop indexes of a last word (space separated).
local function get_last_word_indexes(line)
  return line:find("[^%s]+%s*$")
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
  local line, column = unpack(vim.api.nvim_win_get_cursor(0))
  local line_string = get_line(line)

  -- Lines before and after cursor.
  local left_part = line_string:sub(0, column)
  local right_part = line_string:sub(column + 1)

  local word_start_index, _ = get_last_word_indexes(left_part)

  -- If there are no words before cursor
  if word_start_index == nil then
    local previous_line = line - 1
    if previous_line < 1 then
      return
    end

    -- Concatenates line with previous line
    local previous_line_string = get_line(line - 1)
    local new_cursor_position = { previous_line, get_line_width(previous_line) }

    remove_line(line)
    set_line(previous_line, previous_line_string .. right_part)
    vim.api.nvim_win_set_cursor(0, new_cursor_position)
    return
  end

  -- Replace the line by new line with removed full word.
  local new_left_part = left_part:sub(1, word_start_index - 1)
  local new_line = new_left_part .. right_part
  vim.api.nvim_buf_set_lines(0, line - 1, line, true, { new_line })

  -- Sets cursor after deletion
  vim.api.nvim_win_set_cursor(0, { line, word_start_index - 1 })
end

return remove_left_full_word
