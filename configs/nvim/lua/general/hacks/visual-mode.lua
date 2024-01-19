local u = require("utilities")

-- Enters into a visual mode and proxies v:count inside.
local function enter(mode)
  local keys = u.replace_termcodes(mode)

  if vim.v.count > 1 then
    keys = keys .. tostring(vim.v.count)
  end

  vim.api.nvim_feedkeys(keys, "ni", false)
end

return {
  v = u.wrap(enter, "v"),
  V = u.wrap(enter, "V"),
  b = u.wrap(enter, "<C-v>"),
}
