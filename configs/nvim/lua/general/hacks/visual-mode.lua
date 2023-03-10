-- Enters to visual mode. It proxies v:count insert mode
local function enter()
  local saved_count = nil
  if vim.v.count > 1 then
    saved_count = vim.v.count
    vim.v.count = 0
  end

  vim.cmd("normal! v")

  if saved_count then
    vim.api.nvim_feedkeys(tostring(saved_count), "n", false)
  end
end

return {
  enter = enter,
}
