local u = require("utilities")
local function rooter(addPlugin)
  addPlugin("airblade/vim-rooter")

  vim.g.rooter_patterns = {".git/"}
  vim.g.rooter_silent_chdir = 1
  vim.g.rooter_resolve_links = 1
end

local function session(addPlugin)
  addPlugin({
    "xolox/vim-session",
    dependencies = {
      "xolox/vim-misc"
    },
  })

  -- Sets directories
  local base = vim.fn.stdpath("data")
  local sessionDirectory = base .. "/sessions/"
  local sessionLockDirectory = base .. "/session-locks/"
  vim.fn.mkdir(sessionDirectory, "p")
  vim.fn.mkdir(sessionLockDirectory, "p")

  vim.g.session_directory =  sessionDirectory
  vim.g.session_lock_directory = sessionLockDirectory

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

local function focus(addPlugin)
  addPlugin("junegunn/limelight.vim")
  vim.g.limelight_conceal_guifg = "#446666"
  vim.g.limelight_paragraph_span = 4

  addPlugin("junegunn/goyo.vim")
  vim.g.goyo_width = "150"
  vim.g.goyo_height = "95"
  vim.g.goyo_linenr = 0

  u.nmap("<M-n>", "<Cmd>Goyo<CR>")

  u.autocmd("UserFocusModeEnter", "User", {
    pattern = "GoyoEnter", command = "Limelight",
  })

  u.autocmd("UserFocusModeLeave", "User", {
    pattern = "GoyoLeave", command = "Limelight!",
  })
end

local function searchInBrowser(addPlugin)
  addPlugin("tyru/open-browser.vim")
  u.nmap("<leader>/", "<Plug>(openbrowser-smart-search)")
  u.xmap("<leader>/", "<Plug>(openbrowser-smart-search)")
end

local function gutentags(addPlugin)
  addPlugin("ludovicchabant/vim-gutentags")
  vim.g.gutentags_add_default_project_roots = 0
  vim.g.gutentags_project_root = {".git"}
  vim.g.gutentags_cache_dir = vim.fn.stdpath("data") .. "/tags"
  vim.g.gutentags_file_list_command= "fd --type file --hidden --exclude .git"
end

local function quickfix(addPlugin)
  _ = addPlugin
  -- TODO: check nvim-bqf
end

local function apply(addPlugin)
  rooter(addPlugin)
  session(addPlugin)
  focus(addPlugin)
  searchInBrowser(addPlugin)
  gutentags(addPlugin)
  quickfix(addPlugin)
end

return {
  apply = apply
}
