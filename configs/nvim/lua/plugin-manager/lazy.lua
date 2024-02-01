-- The file works with lazy.nvim
local u = require("utilities")

local M = {}

---Installs lazy plugin manager if it is't present.
M.ensure_presence = function()
  -- Set lazy path
  local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  -- Check lazy presence
  if vim.loop.fs_stat(lazy_path) then
    vim.opt.runtimepath:prepend(lazy_path)
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

  -- Should be prepended only after lazy has been cloned.
  vim.opt.runtimepath:prepend(lazy_path)

  -- Notify success
  u.notify("Lazy's been installed successfully!")
end

M.set_mappings = function()
  local leader = "<M-d>"
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
  commands.install.key        = leader .. "I"
  commands.install.key_plugin = leader .. "i"
  commands.update.key         = leader .. "U"
  commands.update.key_plugin  = leader .. "u"
  commands.sync.key           = leader .. "s"
  commands.clean.key          = leader .. "X"
  commands.clean.key_plugin   = leader .. "x"
  commands.check.key          = leader .. "C"
  commands.check.key_plugin   = leader .. "c"
  commands.log.key            = leader .. "L"
  commands.log.key_plugin     = leader .. "l"
  commands.restore.key        = leader .. "R"
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
      missing = false,
    },
    ui = {
      border = "single",
    },
    performance = {
      cache = {
        enabled = true,
      },
      rtp = {
        disabled_plugins = {
          "gzip",
          "matchit",
          -- "matchparen", -- highlights match parenthesis
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      }
    },
  }

  local lazy = require("lazy")
  u.allow_mapping_from("lua/lazy/core/handler/keys.lua")
  lazy.setup(plugins, lazy_options)
end

return M
