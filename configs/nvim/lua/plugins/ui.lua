local u = require("utilities")

-- TODO: remove devicons after switch to lualine
local function devicons(addPlugin)
  addPlugin("ryanoasis/vim-devicons")
  vim.g.WebDevIconsUnicodeDecorateFolderNodes = 1
  vim.g.DevIconsEnableFoldersOpenClose = 1
  vim.g.DevIconsEnableFolderExtensionPatternMatching = 1
end

-- TODO: Switch to lualine
local function airline(addPlugin)
  addPlugin({
    "vim-airline/vim-airline",
    dependencies = "ludovicchabant/vim-gutentags"
  })

  vim.g["airline#extensions#disable_rtp_load"] = 1
  vim.g.airline_extensions = {
    "tabline", "quickfix", "gutentags", "coc"
  }

  vim.g.airline_highlighting_cache = 1
  vim.g.airline_inactive_collapse = 0
  vim.g.airline_powerline_fonts = 1

  vim.g.airline_section_b = ""
  vim.g.airline_section_y = ""
  vim.g.airline_section_x = "%y"
  vim.g.airline_section_c = "%t%m"
  vim.g.airline_section_z = "%#__accent_bold#%p%% %l/%L%#__restore__#"

  vim.g.airline_left_sep = ""
  vim.g.airline_left_alt_sep = "╱"
  vim.g.airline_right_sep = ""
  vim.g.airline_right_alt_sep = "╱"

  vim.g["airline#extensions#tabline#enabled"] = 1
  vim.g["airline#extensions#tabline#show_close_button"] = 0
  vim.g["airline#extensions#tabline#tab_nr_type"] = 1
  vim.g["airline#extensions#tabline#fnamemod"] = ":t"

  vim.g["airline#extensions#tabline#show_buffers"] = 0
  vim.g["airline#extensions#tabline#show_splits"] = 1
  vim.g["airline#extensions#tabline#show_tab_count"] = 0

  -- Fix mode truncation (truncated at 79 symbols).
  u.autocmd("UserDisableAirlineShortMode", "User", {
    desc = "Sets less aggressive short mode",
    pattern = "AirlineAfterInit",
    command = [[
      function! airline#parts#mode()
        return airline#util#shorten(get(w:, 'airline_current_mode', ''), 50, 1)
      endfunction
    ]]
  })
end

local function floaterm(addPlugin)
  addPlugin("voldikss/vim-floaterm")
  vim.g.floaterm_width = 0.92
  vim.g.floaterm_height = 0.92
  vim.g.floaterm_wintype = "floating"
  vim.g.floaterm_position = "center"
  vim.g.floaterm_title = ""
  vim.g.floaterm_autoinsert = true

  vim.g.floaterm_keymap_toggle = "<F1>"
  u.tmap("<F2>", "<C-\\><C-n>")
  u.nmap("<F2>", "<Cmd>FloatermToggle<Cr><C-\\><C-n>")
  vim.g.floaterm_keymap_kill = '<F3>'
end

local function startify(addPlugin)
  -- TODO: Switch thist to something simplier.
  addPlugin("mhinz/vim-startify")
  vim.g.startify_change_to_dir = 0
  vim.g.startify_change_to_vcs_root = 0
  vim.g.startify_update_oldfiles = 1
  vim.g.startify_fortune_use_unicode = 1
  vim.g.startify_padding_left = 8
  vim.g.startify_files_number = 5

  vim.g.startify_bookmarks = {
    { ci = "~/.config/i3/config"},
    { cv = "~/configuration/configs/nvim/init.vim"},
    { cz = "~/configuration/configs/terminal/zshrc"},
  }

  vim.g.startify_lists = {
    { type = "sessions",  header = {"Sessions"}                           },
    { type = "bookmarks", header = {"Bookmarks"}                          },
    { type = "files",     header = {"MRU"},  indices = {"U", "E", "O", "A"}},
  }

  vim.g.startify_session_dir = "~/.local/share/nvim/sessions/"
  vim.g.startify_session_persistence = 1
  vim.g.startify_session_sort = 1
  vim.g.startify_session_number = 9
end

local function apply(addPlugin)
  devicons(addPlugin)
  airline(addPlugin)
  floaterm(addPlugin)
  startify(addPlugin)
end

return {
  apply = apply,
}
