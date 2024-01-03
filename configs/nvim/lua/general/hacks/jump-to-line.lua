local is_operator_pending_mode = function()
  local mode = tostring(vim.fn.mode("true"))
  return mode:find("o") ~= nil
end

local on_current_line = function()
  return "\\%" .. vim.api.nvim_win_get_cursor(0)[1] .. "l"
end

local not_on_current_line = function()
  return "\\%" .. vim.api.nvim_win_get_cursor(0)[1] .. "l\\@!"
end

local get_to_line_functions = function(hop)
  local to_line = {}

  to_line.upward_left = function()
    hop({
      pattern = not_on_current_line() .. "\\v^[[:blank:]]*[^[:blank:]]?",
      direction = "backward",
      match_position = "end",
    })
  end

  to_line.upward_right = function()
    hop({
      pattern = not_on_current_line() .. "\\v$",
      direction = "backward",
      match_position = "end",
    })
  end

  to_line.left = function()
    local options = {
      pattern = on_current_line() .. "\\v^[[:blank:]]*[^[:blank:]]?",
      direction = "backward",
      match_position = "end",
    }
    if not hop(options) then
      options.direction = "forward"
      options.offset = -1
      hop(options)
    end
  end

  to_line.right = function()
    hop({
      pattern = on_current_line() .. "\\v$",
      direction = "forward",
      match_position = "end",
      offset = is_operator_pending_mode() and -1 or 0,
    })
  end

  to_line.downward_left = function()
    hop({
      pattern = not_on_current_line() .. "\\v^[[:blank:]]*[^[:blank:]]?",
      direction = "forward",
      match_position = "end",
      offset = is_operator_pending_mode() and -1 or 0,
    })
  end

  to_line.downward_right = function()
    hop({
      pattern = not_on_current_line() .. "\\v$",
      direction = "forward",
      match_position = "end",
      offset = is_operator_pending_mode() and -1 or 0,
    })
  end

  return to_line
end

return get_to_line_functions
