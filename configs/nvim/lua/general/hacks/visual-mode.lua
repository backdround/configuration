-- Enters to visual mode. It proxies v:count insert mode
local function enter()
  local savedCount = nil
  if vim.v.count > 1 then
    savedCount = vim.v.count
    vim.v.count = 0
  end

  vim.cmd("normal! v")

  if savedCount then
    vim.api.nvim_feedkeys(tostring(savedCount), "n", false)
  end
end

return {
  enter = enter
}
