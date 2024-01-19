local utilities = require("utilities")

local function apply()
  local options = vim.opt

  -- Search
  options.incsearch = true
  options.hlsearch = true
  options.ignorecase = true
  options.smartcase = true

  -- Indentation
  options.tabstop = 2
  options.expandtab = true

  options.shiftwidth = 0 -- use tabstop
  options.softtabstop = -1 -- use shiftwidth

  options.shiftround = false
  options.smarttab = false
  options.smartindent = false
  options.autoindent = false

  -- Backup
  if LightWeight then
    options.backup = false
    options.writebackup = false
  else
    local backupdir = vim.fn.expand("~/.neovim-backup")
    vim.fn.mkdir(backupdir, "p")

    options.backup = true
    options.backupext = ".back"
    options.backupdir = { backupdir }
    options.backupskip:append({
      "/dev/shm/*",
      "~/.zsh_history",
      backupdir .. "/*",
    })
  end
  options.swapfile = false
  options.undofile = false

  -- Visual representation
  options.number = true
  options.relativenumber = true
  options.wrap = false
  options.cursorline = true
  options.colorcolumn = "80"

  options.list = true
  options.listchars = {
    tab = "  ",
    trail = "·",
  }
  options.fillchars = {
    eob = "-",
    fold = " ",
    vert = " ",
  }

  -- Folds
  -- selene: allow(global_usage)
  _G.fold_text = function()
    local count_of_lines = vim.v.foldend - vim.v.foldstart + 1

    local start_line = vim.v.foldstart
    local line =
      vim.api.nvim_buf_get_lines(0, start_line - 1, start_line, true)[1]

    local indent, rest = line:match("(%s*)(.*)")
    local indent_virtual_width = vim.fn.virtcol({ vim.v.foldstart, #indent })

    local new_virtual_indent_width = math.max(indent_virtual_width - 2, 0)
    local new_indent = "> " .. (" "):rep(new_virtual_indent_width)

    local title = new_indent .. rest .. ": " .. count_of_lines .. " lines"
    local free_space = tonumber(options.colorcolumn:get()[1]) - #title
    if free_space > 2 then
      title = title .. (" "):rep(free_space - 1) .. "<"
    end
    return title
  end

  options.foldenable = true
  options.foldtext = "v:lua.fold_text()"
  options.foldcolumn = "0"
  options.foldlevel = 8
  options.foldminlines = 1
  options.foldopen:remove("block")
  options.foldopen:remove("hor")
  options.foldexpr = "nvim_treesitter#foldexpr()"
  options.foldmethod = "expr"

  -- Language
  options.keymap = "custom_ru"
  options.iminsert = 0

  utilities.autocmd("UserResetLanguageInsert", "InsertLeave", {
    desc = "Reset language to english when leave insert",
    command = "set iminsert=0",
  })

  utilities.autocmd("UserResetLanguageCmdline", "CmdlineLeave", {
    desc = "Reset language to english when leave cmdline",
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
      vim.opt.formatoptions:remove({ "r", "o" })
    end,
  })

  -- Disable auto editorconfig's trailing space deletion for markdown files.
  local editorconfig = require("editorconfig")
  local real_trim = editorconfig.properties.trim_trailing_whitespace
  editorconfig.properties.trim_trailing_whitespace = function(bufnr, val)
    if vim.bo.filetype == "markdown" then
      return
    end
    real_trim(bufnr, val)
  end

  -- Use current directory name (project name) as the app title.
  vim.opt.title = true
  local function set_title()
    local cwd = { vim.loop.cwd() }
    if cwd[1] then
      vim.opt.titlestring = vim.fs.basename(cwd[1]) or "-"
    else
      vim.opt.titlestring = cwd[3]
    end
  end
  set_title()

  utilities.autocmd("UserSetTitle", "DirChanged", {
    desc = "Sets app title to a project name (directory name)",
    callback = set_title,
  })

  -- Nvimpager
  if nvimpager ~= nil then
    nvimpager.maps = false
  end

  -- Misc
  options.splitright = true
  options.completeopt = { "menu", "menuone", "noselect" }
  options.updatetime = 40
  options.timeout = false
  options.scrolloff = 10
  options.mouse = "a"
  options.cpoptions:remove("_")

  -- Attempt to ignore the bug:
  -- https://github.com/rmagatti/auto-session/issues/109
  -- https://github.com/nvim-telescope/telescope.nvim/issues/559
  options.sessionoptions:remove("folds")

  vim.schedule(function()
    vim.cmd("clearjumps")
  end)

  options.shada = "'0,s2,h"
  if LightWeight then
    options.shada = ""
  end
end

return {
  apply = apply,
}
