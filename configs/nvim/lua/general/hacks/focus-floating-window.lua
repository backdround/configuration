---Focuses a floating window. If the current window is floating
---then focuses the next floating window.
local focus_floating_window = function()
  local windows = vim.api.nvim_tabpage_list_wins(0)

  local floating_windows = {}
  for _, window_id in ipairs(windows) do
    local config = vim.api.nvim_win_get_config(window_id)
    if config.relative ~= "" then
      table.insert(floating_windows, window_id)
    end
  end

  if #floating_windows == 0 then
    return
  end

  vim.fn.sort(floating_windows)

  local current_window = vim.api.nvim_get_current_win()
  local current_floating_window_id = vim.fn.index(
    floating_windows,
    current_window
  ) + 1

  if current_floating_window_id == 0 then
    vim.api.nvim_set_current_win(floating_windows[1])
    return
  end

  if current_floating_window_id + 1 > #floating_windows then
    vim.api.nvim_set_current_win(floating_windows[1])
    return
  end

  local next_window_id = floating_windows[current_floating_window_id + 1]
  vim.api.nvim_set_current_win(next_window_id)
end

return focus_floating_window
