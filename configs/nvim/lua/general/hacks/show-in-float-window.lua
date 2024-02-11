local u = require("utilities")

local buffer_name_counter = 0

---Shows the given text in a float window
---@param text? string text to show in the window.
---@param window_config table nvim_open_win config
---@return number, number buffer and window ids
local show_in_float_window = function(text, window_config)
  u.assert_types({
    text = { text, "string", "nil" },
    window_config = { window_config, "table" },
  })

  text = text or ""

  local buffer_id = vim.api.nvim_create_buf(false, true)
  local window_id = vim.api.nvim_open_win(buffer_id, true, window_config)

  buffer_name_counter = buffer_name_counter + 1
  local buffer_name = "throwaway" .. tostring(buffer_name_counter)
  vim.api.nvim_buf_set_name(buffer_id, buffer_name)

  local lines = vim.fn.split(text, "\n")
  vim.api.nvim_buf_set_lines(buffer_id, 0, -1, true, lines)

  vim.bo[buffer_id].bufhidden = "wipe"

  return buffer_id, window_id
end

return show_in_float_window
