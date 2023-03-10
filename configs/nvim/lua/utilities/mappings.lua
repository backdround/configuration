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

-- Map stab mapping to the given rhs' at the given mode.
-- Use it to disable mappings that are checked with hasmapto()
local stab_counter = 0
M.map_stab = function(mode, rhss)
  for _, rhs in ipairs(rhss) do
    stab_counter = stab_counter + 1
    local stab_mapping = string.format("<Plug>(user-stab-%s)", stab_counter)
    local stab_description = "User stab %s" .. stab_counter

    full_featured_map(mode, stab_mapping, rhs, stab_description)
  end
end

return M
