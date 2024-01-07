local function full_featured_map(mode, lhs, rhs, options_or_desc)
  local options = {}
  if type(options_or_desc) == "table" then
    options = options_or_desc
  elseif type(options_or_desc) == "string" then
    options.desc = options_or_desc
  end

  if not options.desc then
    print("There is no description for mapping: " .. lhs)
    print("Please add it!")
  end

  if options.silent == nil then
    options.silent = true
  end

  if options.noremap == nil then
    options.noremap = true
  end

  vim.keymap.set(mode, lhs, rhs, options)
end

local M = {}

M.map = function(lhs, rhs, options)
  full_featured_map({ "n", "x", "o" }, lhs, rhs, options)
end

local modes = { "n", "i", "v", "c", "t", "o", "x", "s" }
for _, mode in ipairs(modes) do
  M[mode .. "map"] = function(lhs, rhs, options)
    full_featured_map(mode, lhs, rhs, options)
  end
end

return M
