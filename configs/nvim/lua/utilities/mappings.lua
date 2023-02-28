local function fullFeaturedMap(mode, lhs, rhs, optionsOrDesc)
  local options = {}
  if type(optionsOrDesc) == "table" then
    options = optionsOrDesc
  elseif type(optionsOrDesc) == "string" then
    options.desc = optionsOrDesc
  end

  if options.silent == nil then
    options.silent = true
  end

  if options.noremap == nil then
    options.noremap = true
  end

  vim.keymap.set(mode, lhs, rhs, options)
end

local mapFunctions = {}

mapFunctions.map = function(lhs, rhs, options)
  fullFeaturedMap({ "n", "x", "o" }, lhs, rhs, options)
end

local modes = { "n", "i", "v", "c", "t", "o", "x", "s" }
for _, mode in ipairs(modes) do
  mapFunctions[mode .. "map"] = function(lhs, rhs, options)
    fullFeaturedMap(mode, lhs, rhs, options)
  end
end

return mapFunctions
