local utils = require("utilities")

local function ensureLazy()
  -- Sets lazy path
  local lazyPath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  vim.opt.runtimepath:prepend(lazyPath)

  -- Checks lazy presence
  if vim.loop.fs_stat(lazyPath) then
    return "skipped"
  end

  -- Installs lazy
  utils.notify("Lazy installation ...")
  local cloneOutput = vim.fn.system({
    "git",
    "clone",
    "--depth=1",
    "https://github.com/folke/lazy.nvim.git",
    lazyPath,
  })

  -- Checks error
  if vim.v.shell_error ~= 0 then
    local errorMessage = "Unable to clone lazy\n" .. cloneOutput
    error(errorMessage)
  end

  -- Returns successfully
  utils.notify("Lazy installed success!")
  return "installed"
end

local plugins = {}

local function add(plugin)
  utils.assertStringOrTable(plugin, "Plugin", 2)
  table.insert(plugins, plugin)
end

local function apply()
  ensureLazy()

  -- Changes default mappings
  local config = require("lazy.view.config")
  config.commands.update.key = "<M-U>"
  config.commands.update.key_plugin = "<M-u>"
  config.keys.diff = "<M-d>"

  -- Loads plugins
  local lazy = require("lazy")
  lazy.setup(plugins)
end

return {
  add = add,
  apply = apply,
}
