---Focuses a floating window. If the current window is floating
---then focuses the next floating window.
local focus_floating_window = function()
  local current_tab_window_ids_plain = vim.api.nvim_tabpage_list_wins(0)
  vim.fn.sort(current_tab_window_ids_plain)
  local current_tab_window_ids = vim.iter(current_tab_window_ids_plain)

  -- Filter out non floating windows.
  current_tab_window_ids:filter(function(window_id)
    local config = vim.api.nvim_win_get_config(window_id)
    return config.relative ~= ""
  end)

  -- Get first floating window
  local first_floating_window = current_tab_window_ids:peek()

  -- Get after the current floating window
  local current_window = vim.api.nvim_get_current_win()
  current_tab_window_ids:find(current_window)
  local next_floating_window_id = current_tab_window_ids:next()

  -- Set focus
  if next_floating_window_id ~= nil then
    vim.api.nvim_set_current_win(next_floating_window_id)
  elseif first_floating_window ~= nil then
    vim.api.nvim_set_current_win(first_floating_window)
  end
end

return focus_floating_window
