-- The file works with lazy.nvim
local u = require("utilities")

local M = {}

---Installs lazy plugin manager if it is't present.
M.ensure_presence = function()
  -- Set lazy path
  local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  vim.opt.runtimepath:prepend(lazy_path)

  -- Check lazy presence
  if vim.loop.fs_stat(lazy_path) then
    return
  end

  -- Install lazy
  u.notify("Lazy installation is in progress...")
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
  u.notify("Lazy's been installed successfully!")
end

M.set_mappings = function()
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
end

---Loads given plugins.
---@param plugins UserPluginSpecification[]
M.load = function(plugins)
  local lazy_options = {
    install = {
      colorscheme = { "melting" },
    },
    ui = {
      border = "single",
    },
  }

  local lazy = require("lazy")
  lazy.setup(plugins, lazy_options)
end

return M
