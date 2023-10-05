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
local pm = load("plugin-manager")
-- General
apply("general.base", pm.add_plugin)
apply("general.options", pm.add_plugin)
apply("general.motions", pm.add_plugin)
apply("general.windows", pm.add_plugin)
apply("general.languages", pm.add_plugin)

-- Plugins general
apply("plugins/editing", pm.add_plugin)
apply("plugins/features", pm.add_plugin)
apply("plugins/lsp", pm.add_plugin)
apply("plugins/ui", pm.add_plugin)
apply("plugins/lines", pm.add_plugin)

-- Plugins
apply("plugins/telescope", pm.add_plugin)
apply("plugins/treesitter", pm.add_plugin)
apply("plugins/nvim-cmp", pm.add_plugin)
apply("plugins/luasnip", pm.add_plugin)

pm.load()
