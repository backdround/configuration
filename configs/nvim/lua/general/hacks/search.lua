local utilities = require("utilities")

local function search_current_word_without_moving()
  local current_word = vim.fn.expand("<cword>")
  if current_word == "" then
    return
  end

  -- Sets highlight
  vim.fn.setreg("/", vim.fn.expand("<cword>"))
  vim.opt.hlsearch = true

  -- Sets cursor to the first character of the current_word
  -- (for next search conviniece).
  vim.fn.search(current_word, "ce")
  vim.fn.search(current_word, "cb")
end

local function normal(...)
  local cmd = {
    cmd = "normal",
    bang = true,
    args = { ... },
  }

  local success, err = pcall(vim.api.nvim_cmd, cmd, {})

  -- Prints error without file context
  if not success then
    err = err:gsub(".*Vim[^:]*:", "", 1)
    vim.api.nvim_err_writeln(err)
  end
end

local function search_stable_next()
  if vim.v.searchforward == 1 then
    normal("n")
  else
    normal("N")
  end
end

local function search_stable_previous()
  if vim.v.searchforward == 0 then
    normal("n")
  else
    normal("N")
  end
end

local function get_mark(mark)
  local line, column = unpack(vim.api.nvim_buf_get_mark(0, mark))

  -- Checks that column unsigned(-1)
  local line_string = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
  if column > line_string:len() then
    column = line_string:len()
  end

  return line - 1, column
end

local function get_visual_selection_range()
  local start_row, start_column = get_mark("<")
  local end_row, end_column = get_mark(">")
  if
    start_row < end_row or (start_row == end_row and start_column <= end_column)
  then
    return start_row, start_column, end_row, end_column + 1
  else
    return end_row, end_column, start_row, start_column + 1
  end
end

local function search_selected_text(do_after)
  -- Leaves visual mode
  utilities.reset_current_mode()

  -- Gets selected text
  local start_row, start_column, end_row, end_column =
    get_visual_selection_range()
  local selected_text = vim.api.nvim_buf_get_text(
    0,
    start_row,
    start_column,
    end_row,
    end_column,
    {}
  )
  selected_text = table.concat(selected_text, "\\n")

  -- Sets cursor to left part of selected text (for next search conviniece)
  vim.api.nvim_win_set_cursor(0, { start_row + 1, start_column })

  -- Sets the selected text as a search text
  vim.fn.setreg("/", selected_text)
  vim.opt.hlsearch = true

  -- Performs the given action after selection
  if do_after then
    utilities.assert_callable(do_after, "do_after", 2)
    do_after()
  end
end

-- "*" in visual mode, that can search multiline-pattern
local function search_selected_text_next()
  search_selected_text(search_stable_next)
end

-- "#" in visual mode, that can search multiline-pattern
local function search_selected_text_previous()
  search_selected_text(search_stable_previous)
end

return {
  current_word_without_moving = search_current_word_without_moving,
  stable_next = search_stable_next,
  stable_previous = search_stable_previous,
  selected_text = search_selected_text,
  selected_text_next = search_selected_text_next,
  selected_text_previous = search_selected_text_previous,
}
