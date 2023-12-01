local lazy = require("plugin-manager.lazy")

---@class UserPluginSpecification
---@field url string
---@field enabled? boolean
---@field config? function
---@field opts? table
---@field build? string
---@field dependencies? table|string

local new = function()
  ---@class UserPluginManager
  ---@field plugins UserPluginSpecification[] list of plugins
  local m = {
    plugins = {}
  }

  ---Adds a plugin
  ---@param plugin UserPluginSpecification|string
  m.add = function(plugin)
    if type(plugin) == "string" then
      plugin = {
        url = "https://github.com/" .. plugin
      }
    end
    table.insert(m.plugins, plugin)
  end

  ---Loads all added plugins
  m.load = function()
    lazy.ensure_presence()
    lazy.set_mappings()
    lazy.load(m.plugins)
  end

  return m
end

return {
  new = new
}
