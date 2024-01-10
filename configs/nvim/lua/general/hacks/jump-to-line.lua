local u = require("utilities")

local is_operator_pending_mode = function()
  return u.mode() == "operator-pending"
end

local on_current_line = function()
  return "\\%" .. vim.api.nvim_win_get_cursor(0)[1] .. "l"
end

local not_on_current_line = function()
  return "\\%" .. vim.api.nvim_win_get_cursor(0)[1] .. "l\\@!"
end

---Saves the current position into jumplist.
local save_position_into_jumplist = function()
  local mode = u.mode()
  if mode == "normal" or mode == "visual" then
    local count = vim.v.count
    vim.cmd.normal({ args = { "m'" }, bang = true })
    if count ~= 0 then
      u.feedkeys(count, "ni")
      u.perform_empty_keymap({ "n", "x" })
    end
  end
end

local get_to_line_functions = function(hop)
  local to_line = {}

  to_line.upward_left = function()
    save_position_into_jumplist()
    hop({
      pattern = not_on_current_line() .. "\\v^[[:blank:]]*[^[:blank:]]?",
      direction = "backward",
      match_position = "end",
    })
  end

  to_line.upward_right = function()
    save_position_into_jumplist()
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
      options.offset = is_operator_pending_mode() and -1 or 0
      options.accept_policy = "from-cursor"
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
    save_position_into_jumplist()
    hop({
      pattern = not_on_current_line() .. "\\v^[[:blank:]]*[^[:blank:]]?",
      direction = "forward",
      match_position = "end",
      offset = is_operator_pending_mode() and -1 or 0,
    })
  end

  to_line.downward_right = function()
    save_position_into_jumplist()
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
