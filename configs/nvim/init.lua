
local module_names = {
  -- General modules
  "general.base",
  "general.options",
  "general.motions",
  "general.windows",
  "general.languages",

  -- General plugin modules
  "plugins/editing",
  "plugins/features",
  "plugins/lsp",
  "plugins/ui",
  "plugins/lines",

  -- Plugins
  "plugins/telescope",
  "plugins/treesitter",
  "plugins/nvim-cmp",
  "plugins/luasnip",
}

---Finds and performs the given module by name
---@param module_name string
---@param register_plugin function
local function apply(module_name, register_plugin)
  -- Load module
  local status, result = pcall(require, module_name)

  if not status then
    vim.api.nvim_err_writeln(result)
    return
  end

  local module = result

  -- Apply module
  status, result = pcall(module.apply, register_plugin)
  if not status then
    vim.api.nvim_err_writeln(result)
  end
end

-- Apply all modules
local plugin_manager = require("plugin-manager")
for _, module_name in ipairs(module_names) do
  apply(module_name, plugin_manager.add_plugin)
end

-- Load all registred plugins
plugin_manager.load()
