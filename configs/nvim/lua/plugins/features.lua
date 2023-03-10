local u = require("utilities")
local function rooter(add_plugin)
  add_plugin("airblade/vim-rooter")

  vim.g.rooter_patterns = { ".git/" }
  vim.g.rooter_silent_chdir = 1
  vim.g.rooter_resolve_links = 1
end

local function markdown(add_plugin)
  add_plugin({
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    config = function()
      local peek = require("peek")
      peek.setup({
        auto_load = false,
        app = "browser",
      })

      u.nmap("dm", peek.open, "Open preview")
    end,
  })
end

local function session(add_plugin)
  add_plugin({
    "xolox/vim-session",
    dependencies = {
      "xolox/vim-misc",
    },
  })

  -- Sets directories
  local base = vim.fn.stdpath("data")
  local session_directory = base .. "/sessions/"
  local session_lock_directory = base .. "/session-locks/"
  vim.fn.mkdir(session_directory, "p")
  vim.fn.mkdir(session_lock_directory, "p")

  vim.g.session_directory = session_directory
  vim.g.session_lock_directory = session_lock_directory

  -- Sets options
  vim.g.session_default_overwrite = 1
  vim.g.session_extension = ""
  vim.g.session_autoload = "no"
  vim.g.session_autosave = "yes"
  vim.g.session_autosave_periodic = 3
  vim.g.session_autosave_silent = 1
  vim.g.session_verbose_messages = 0
  vim.g.session_persist_font = 0
  vim.g.session_persist_collors = 0

  -- TODO: Set my own commands after get rid of startify.
  -- and switch this to 0.
  vim.g.session_command_aliases = 1
end

local function search_in_browser(add_plugin)
  add_plugin("tyru/open-browser.vim")
  u.nmap("<leader>/", "<Plug>(openbrowser-smart-search)", "Search in browser")
  u.xmap("<leader>/", "<Plug>(openbrowser-smart-search)", "Search in browser")
end

local function gutentags(add_plugin)
  add_plugin("ludovicchabant/vim-gutentags")
  vim.g.gutentags_add_default_project_roots = 0
  vim.g.gutentags_project_root = { ".git" }
  vim.g.gutentags_cache_dir = vim.fn.stdpath("data") .. "/tags"
  vim.g.gutentags_file_list_command = "fd --type file --hidden --exclude .git"
end

-- TODO: make more robust plugin.
local function scope(add_plugin)
  add_plugin({
    "tiagovla/scope.nvim",
    opts = {},
  })
end

-- TODO: remove this after switching to neovim 9.0 and beyond
local function editorconfig(add_plugin)
  add_plugin("gpanders/editorconfig.nvim")
  vim.g.editorconfig = false
end

local function quickfix(add_plugin)
  _ = add_plugin
  -- TODO: check nvim-bqf
end

local function apply(add_plugin)
  rooter(add_plugin)
  markdown(add_plugin)
  session(add_plugin)
  search_in_browser(add_plugin)
  gutentags(add_plugin)
  scope(add_plugin)
  editorconfig(add_plugin)
  quickfix(add_plugin)
end

return {
  apply = apply,
}
