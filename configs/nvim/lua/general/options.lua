local utilities = require("utilities")

local function apply(addPlugin)
  local options = vim.opt

  -- Search
  options.incsearch = true
  options.hlsearch = true
  options.ignorecase = true
  options.smartcase = true

  -- Indentation
  options.tabstop = 2
  options.shiftwidth = 2
  options.expandtab = true
  options.smarttab = false
  options.smartindent = false

  -- Backup
  local backupdir = vim.fn.expand("~/.neovim-backup")
  vim.fn.mkdir(backupdir, "p")

  options.backup = true
  options.backupext = ".back"
  options.backupdir = backupdir
  options.backupskip = options.backupskip + "/dev/shm/*" + backupdir

  -- Visual representation
  options.number = true
  options.relativenumber = true
  options.wrap = false
  options.cursorline = true
  options.colorcolumn = "80"

  options.list = true
  options.listchars = "tab:  ,trail:·"
  options.fillchars = "fold: ,"
  options.fillchars = "vert: ,"

  -- Colors
  options.termguicolors = true
  addPlugin{ "backdround/melting", config = function()
    vim.cmd.colorscheme("melting")
  end }

  -- Language
  options.keymap = "custom_ru"
  options.iminsert = 0

  utilities.autocmd("UserResetLanguage", "InsertLeave", {
    desc = "Reset language to english when leave insert",
    command = "set iminsert=0",
  })

  -- Remove default plugins
  vim.g.no_plugin_maps = 1
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_matchit = 1

  -- Disable autocomment
  utilities.autocmd("UserDisableAutocomment", "BufEnter", {
    desc = "Disable auto insert comments when cursor is on comment line",
    callback = function()
      vim.opt.formatoptions:remove({"r", "o"})
    end,
  })

  -- Use current directory name (project name) as the app title.
  vim.opt.title = true
  local function setTitle()
    local currentDirectoryName = vim.fs.basename(vim.fn.getcwd())
    vim.opt.titlestring = currentDirectoryName
  end
  utilities.autocmd("UserSetTitle", "DirChanged", {
    desc = "Set app title to project name (directory name)",
    callback = setTitle,
  })
  setTitle()

  -- Misc
  options.updatetime = 40
  options.timeout = false
  options.scrolloff = 10
  options.mouse = "a"
  options.swapfile = false
end

return {
  apply = apply
}