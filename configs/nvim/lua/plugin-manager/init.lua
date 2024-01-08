local lazy = require("plugin-manager.lazy")

---@class UserPluginSpecification
---@field url string
---@field enabled? boolean
---@field config? function
---@field opts? table
---@field build? string
---@field dependencies? table|string
---@field keys? table

---Adds desc field to all keys that aren't descripted.
---@param keys table
---@return table
local describe_keys = function(keys, plugin_name)
  local keys_description = "Not loaded " .. plugin_name .. " key"

  if type(keys) == "string" then
    keys = { keys }
  end

  local described_keys = {}
  for _, key in ipairs(keys) do
    local new_key = {
      desc = keys_description,
    }

    if type(key) == "string" then
      new_key[1] = key
    else
      new_key = vim.tbl_extend("force", new_key, key)
    end

    table.insert(described_keys, new_key)
  end
  return described_keys
end

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

    if plugin.keys then
      local plugin_name = plugin.url:gsub("^.*/", ""):gsub("%.git$", "")
      plugin.keys = describe_keys(plugin.keys, plugin_name)
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
