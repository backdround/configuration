-- Require without cache
local function load(module_name)
  package.loaded[module_name] = nil
  return require(module_name)
end

-- Apply module
local function apply(module_name, ...)
  local status, result = pcall(load, module_name)

  if not status then
    local error_message = result
    print(error_message)
    return nil
  end

  local module = result
  return module.apply(...)
end

-- Applies configs
local pm = load("plugins/manager")
-- General
apply("general.base", pm.add)
apply("general.options", pm.add)
apply("general.motions", pm.add)
apply("general.windows", pm.add)

-- Plugins general
apply("plugins/editing", pm.add)
apply("plugins/features", pm.add)
apply("plugins/languages", pm.add)
apply("plugins/ui", pm.add)
apply("plugins/lines", pm.add)

-- Plugins
apply("plugins/telescope", pm.add)
apply("plugins/treesitter", pm.add)
apply("plugins/nvim-cmp", pm.add)
apply("plugins/luasnip", pm.add)

pm.apply()
