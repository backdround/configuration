--- It is "require()" but without cache.
local function load_module(module_name)
  package.loaded[module_name] = nil
  return require(module_name)
end

--- It finds and performs a module with the given arguments.
local function apply(module_name, ...)
  -- Load module
  local status, result = pcall(load_module, module_name)

  if not status then
    vim.api.nvim_err_writeln(result)
    return
  end

  local module = result

  -- Apply module
  status, result = pcall(module.apply, ...)
  if not status then
    vim.api.nvim_err_writeln(result)
  end
end


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

-- Apply all modules
local plugin_manager = load_module("plugin-manager")
for _, module_name in ipairs(module_names) do
  apply(module_name, plugin_manager.add_plugin)
end

-- Load all registred plugins
plugin_manager.load()
