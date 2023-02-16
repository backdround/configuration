-- Require without cache
local function load(moduleName)
  package.loaded[moduleName] = nil
  return require(moduleName)
end

-- Apply module
local function apply(moduleName, ...)
  local status, result = pcall(load, moduleName)

  if not status then
    local errMessage = result
    print(errMessage)
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

-- Plugins
apply("plugins/telescope", pm.add)

pm.apply()