-- The module adds ability to a user to load plugins.

local utils = require("utilities")

---It installs lazy plugin manager if it is't present.
local function ensure_lazy_presence()
  -- Set lazy path
  local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  vim.opt.runtimepath:prepend(lazy_path)

  -- Check lazy presence
  if vim.loop.fs_stat(lazy_path) then
    return
  end

  -- Install lazy
  utils.notify("Lazy installation is in progress...")
  local clone_output = vim.fn.system({
    "git",
    "clone",
    "--depth=1",
    "https://github.com/folke/lazy.nvim.git",
    lazy_path,
  })

  -- Check the error code
  if vim.v.shell_error ~= 0 then
    local error_message = "Unable to clone lazy:\n" .. clone_output
    error(error_message)
  end

  -- Notify success
  utils.notify("Lazy's been installed successfully!")
end

local plugins = {}

---Adds a plugin to a list to dealt with it later.
---@param plugin string|table: lazy's plugin
local function add_plugin(plugin)
  utils.assert_string_or_table(plugin, "Plugin", 2)
  table.insert(plugins, plugin)
end

---Loads all previously given plugins.
local function load()
  ensure_lazy_presence()

  -- Change default mappings
  local config = require("lazy.view.config")
  config.commands.update.key = "<M-U>"
  config.commands.update.key_plugin = "<M-u>"
  config.keys.diff = "<M-d>"

  local lazy_options = {
    install = {
      colorscheme = { "melting" },
    },
    ui = {
      border = "single",
    },
  }

  -- Load plugins
  local lazy = require("lazy")
  lazy.setup(plugins, lazy_options)
end

return {
  add_plugin = add_plugin,
  load = load,
}
