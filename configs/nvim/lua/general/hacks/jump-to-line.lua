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
---It resets v:count, be careful.
local save_position_into_jumplist = function()
  local mode = u.mode()
  if mode == "normal" or mode == "visual" then
    vim.cmd.normal({ args = { "m'" }, bang = true })
  end
end

local get_to_line_functions = function(hop)
  local to_line = {}

  to_line.upward_left = function()
    local count = vim.v.count1
    save_position_into_jumplist()
    hop({
      pattern = not_on_current_line() .. "\\v^[[:blank:]]*[^[:blank:]]?",
      direction = "backward",
      match_position = "end",
      count = count,
    })
  end

  to_line.upward_right = function()
    local count = vim.v.count1
    save_position_into_jumplist()
    hop({
      pattern = not_on_current_line() .. "\\v$",
      direction = "backward",
      match_position = "end",
      count = count,
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
    local count = vim.v.count1
    save_position_into_jumplist()
    hop({
      pattern = not_on_current_line() .. "\\v^[[:blank:]]*[^[:blank:]]?",
      direction = "forward",
      match_position = "end",
      offset = is_operator_pending_mode() and -1 or 0,
      count = count,
    })
  end

  to_line.downward_right = function()
    local count = vim.v.count1
    save_position_into_jumplist()
    hop({
      pattern = not_on_current_line() .. "\\v$",
      direction = "forward",
      match_position = "end",
      offset = is_operator_pending_mode() and -1 or 0,
      count = count,
    })
  end

  return to_line
end

return get_to_line_functions
