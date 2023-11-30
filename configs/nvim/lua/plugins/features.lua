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
    "rmagatti/auto-session",
    enabled = not LightWeight,
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "/", "~/downloads/" },
      })
    end
  })
end

local function search_in_browser(add_plugin)
  add_plugin("tyru/open-browser.vim")
  u.nmap("<leader>/", "<Plug>(openbrowser-smart-search)", "Search in browser")
  u.xmap("<leader>/", "<Plug>(openbrowser-smart-search)", "Search in browser")
end

local function gutentags(add_plugin)
  add_plugin({
    "ludovicchabant/vim-gutentags",
    enabled = not LightWeight,
  })
  vim.g.gutentags_add_default_project_roots = 0
  vim.g.gutentags_project_root = { ".git" }
  vim.g.gutentags_cache_dir = vim.fn.stdpath("data") .. "/tags"
  vim.g.gutentags_file_list_command = "fd --type file --hidden --exclude .git"
end

local function annotations(add_plugin)
  add_plugin({
    "danymat/neogen",
    enabled = not LightWeight,
    config = function()
      local neogen = require("neogen")
      neogen.setup({
        snippet_engine = "luasnip",
        placeholders_text = {
          ["description"] = "[description]",
          ["tparam"] = "[tparam]",
          ["parameter"] = "[parameter]",
          ["return"] = "[return]",
          ["class"] = "[class]",
          ["throw"] = "[throw]",
          ["varargs"] = "[varargs]",
          ["type"] = "[type]",
          ["attribute"] = "[attribute]",
          ["args"] = "[args]",
          ["kwargs"] = "[kwargs]",
        },
        languages = {
          lua = {
            template = {
              annotation_convention = "emmylua"
            }
          }
        }
      })
      local description = "Generate annotation comment"
      u.nmap("bk", u.wrap(neogen.generate, { type = "any" }), description)
      description = "Generate annotation comment for file"
      u.nmap("bj", u.wrap(neogen.generate, { type = "file" }), description)
    end,
  })
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
  annotations(add_plugin)
  quickfix(add_plugin)
end

return {
  apply = apply,
}
