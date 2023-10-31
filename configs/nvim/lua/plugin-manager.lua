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
  local leader = vim.api.nvim_replace_termcodes("<leader>", true, false, true)
  local keys = require("lazy.view.config").keys
  local commands = require("lazy.view.config").commands

  keys.hover          = leader .. "/"
  keys.diff           = leader .. "d"
  keys.close          = "<M-s>"
  keys.details        = "<M-o>"
  keys.profile_sort   = leader .. "<C-s>"
  keys.profile_filter = leader .. "<C-f>"
  keys.abort          = "<C-c>"

  commands.home.key           = "Y"
  commands.install.key        = leader .. "<M-i>"
  commands.install.key_plugin = leader .. "i"
  commands.update.key         = leader .. "<M-u>"
  commands.update.key_plugin  = leader .. "u"
  commands.sync.key           = leader .. "s"
  commands.clean.key          = leader .. "<M-x>"
  commands.clean.key_plugin   = leader .. "x"
  commands.check.key          = leader .. "<M-c>"
  commands.check.key_plugin   = leader .. "c"
  commands.log.key            = leader .. "<M-l>"
  commands.log.key_plugin     = leader .. "l"
  commands.restore.key        = leader .. "<M-r>"
  commands.restore.key_plugin = leader .. "r"
  commands.profile.key        = leader .. "p"
  commands.debug.key          = leader .. "D"
  commands.help.key           = "<C-_>" -- <C-/>
  commands.build.key_plugin   = leader .. "b"

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
