local utilities = require("utilities")

local function currentWordWithoutMoving()
  vim.fn.setreg("/", vim.fn.expand("<cword>"))
  vim.opt.hlsearch = true
end

local function normal(...)
  local cmd = {
    cmd = "normal",
    bang = true,
    args = {...},
  }

  local success, err = pcall(vim.api.nvim_cmd, cmd, {})

  -- Prints error without file context
  if not success then
    err = err:gsub(".*Vim[^:]*:", "", 1)
    vim.api.nvim_err_writeln(err)
  end
end

local function stableNext()
  if vim.v.searchforward == 1 then
    normal("n")
  else
    normal("N")
  end
end

local function stablePrevious()
  if vim.v.searchforward == 0 then
    normal("n")
  else
    normal("N")
  end
end

local function getMark(mark)
  local line, column = unpack(vim.api.nvim_buf_get_mark(0, mark))

  -- Checks that column unsigned(-1)
  local lineString = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
  if column > lineString:len() then
    column = lineString:len()
  end

  return line - 1, column
end

local function getVisualSelectionRange()
  local startRow, startColumn = getMark("<")
  local endRow, endColumn = getMark(">")
  if startRow < endRow or (startRow == endRow and startColumn <= endColumn) then
    return startRow, startColumn, endRow, endColumn + 1
  else
    return endRow, endColumn, startRow, startColumn + 1
  end
end

local function selectedText(doAfter)
  -- Leaves visual mode
  if vim.fn.mode() ~= "n" then
    escapeVisualKeys = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
    vim.api.nvim_feedkeys(escapeVisualKeys, "n", true)
  end

  -- Visual marks are saved in loop. So we continues the work in a defer function.
  vim.schedule(function()
    -- Gets selected text
    local startRow, startColumn, endRow, endColumn = getVisualSelectionRange()
    local selectedText = vim.api.nvim_buf_get_text(0, startRow, startColumn, endRow, endColumn, {})
    selectedText = table.concat(selectedText, "\\n")

    -- Sets cursor to left part of selected text (for next search conviniece)
    vim.api.nvim_win_set_cursor(0, {startRow + 1, startColumn})

    -- Sets the selected text as a search text
    vim.fn.setreg("/", selectedText)
    vim.opt.hlsearch = true

    -- Performs the given action after selection
    if doAfter then
      utilities.assertCallable(doAfter, "doAfter", 2)
      doAfter()
    end
  end)
end

-- "*" in visual mode, that can search multiline-pattern
local function selectedTextNext()
  selectedText(stableNext)
end

-- "#" in visual mode, that can search multiline-pattern
local function selectedTextPrevious()
  selectedText(stablePrevious)
end

return {
  currentWordWithoutMoving = currentWordWithoutMoving,
  stableNext = stableNext,
  stablePrevious = stablePrevious,
  selectedText = selectedText,
  selectedTextNext = selectedTextNext,
  selectedTextPrevious = selectedTextPrevious,
}
