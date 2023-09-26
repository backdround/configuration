local u = require("utilities")

-- Enters into a visual mode.
-- It proxies v:count inside a visual mode
local function enter(mode)
  local saved_count = nil
  if vim.v.count > 1 then
    saved_count = vim.v.count
    vim.v.count = 0
  end

  mode = vim.api.nvim_replace_termcodes(mode, true, true, true)
  vim.cmd("normal! " .. mode)

  if saved_count then
    vim.api.nvim_feedkeys(tostring(saved_count), "n", false)
  end
end

return {
  v = u.wrap(enter, "v"),
  V = u.wrap(enter, "V"),
  b = u.wrap(enter, "<C-v>"),
}
