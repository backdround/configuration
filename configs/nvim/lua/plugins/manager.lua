local utils = require("utilities")

local function ensure_lazy()
  -- Sets lazy path
  local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  vim.opt.runtimepath:prepend(lazy_path)

  -- Checks lazy presence
  if vim.loop.fs_stat(lazy_path) then
    return "skipped"
  end

  -- Installs lazy
  utils.notify("Lazy installation ...")
  local clone_output = vim.fn.system({
    "git",
    "clone",
    "--depth=1",
    "https://github.com/folke/lazy.nvim.git",
    lazy_path,
  })

  -- Checks error
  if vim.v.shell_error ~= 0 then
    local error_message = "Unable to clone lazy\n" .. clone_output
    error(error_message)
  end

  -- Returns successfully
  utils.notify("Lazy installed success!")
  return "installed"
end

local plugins = {}

local function add(plugin)
  utils.assert_string_or_table(plugin, "Plugin", 2)
  table.insert(plugins, plugin)
end

local function apply()
  ensure_lazy()

  -- Changes default mappings
  local config = require("lazy.view.config")
  config.commands.update.key = "<M-U>"
  config.commands.update.key_plugin = "<M-u>"
  config.keys.diff = "<M-d>"

  -- Makes options
  local options = {
    install = {
      colorscheme = { "melting" },
    },
    ui = {
      border = "single",
    },
  }

  -- Loads plugins
  local lazy = require("lazy")
  lazy.setup(plugins, options)
end

return {
  add = add,
  apply = apply,
}
