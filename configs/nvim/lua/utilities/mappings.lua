local function fullFeaturedMap(mode, lhs, rhs, optionsOrDesc)
  local options = {}
  if type(optionsOrDesc) == "table" then
    options = optionsOrDesc
  elseif type(optionsOrDesc) == "string" then
    options.desc = optionsOrDesc
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
  fullFeaturedMap({ "n", "x", "o" }, lhs, rhs, options)
end

local modes = { "n", "i", "v", "c", "t", "o", "x", "s" }
for _, mode in ipairs(modes) do
  M[mode .. "map"] = function(lhs, rhs, options)
    fullFeaturedMap(mode, lhs, rhs, options)
  end
end

-- Map stab mapping to the given rhs' at the given mode.
-- Use it to disable mappings that are checked with hasmapto()
local stabCounter = 0
M.mapStab =  function(mode, rhss)
  for _, rhs in ipairs(rhss) do
    stabCounter = stabCounter + 1
    local stabMapping = string.format("<Plug>(user-stab-%s)", stabCounter)
    local stabDescription = "User stab %s" .. stabCounter

    fullFeaturedMap(mode, stabMapping, rhs, stabDescription)
  end
end

return M
