local u = require("utilities")

local dependencies = {
  "nvim-lua/plenary.nvim",
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  }
}

local function setup()
  local actions = require("telescope.actions")
  local telescope = require("telescope")

  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ["<esc>"] = actions.close,
          ["<M-e>"] = actions.select_horizontal,
          ["<M-u>"] = actions.select_vertical,
          ["<M-i>"] = actions.select_tab,
        },
      },
      sorting_strategy = "ascending",
      layout_strategy = "vertical",
      layout_config = {
        prompt_position = "top",
        height = 0.95,
        width = 0.7,
        anchor = "CENTER",
        mirror = true,
        preview_height = 0.55,
        preview_cutoff = 45,
      },
      borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    },
    extensions = {
      fzf = {},
    },
  })

  telescope.load_extension("fzf")
end

local function pickLocalFile()
  local builtin = require("telescope.builtin")

  local currentFileDirectory = vim.fn.expand("%:p:h")
  local command = {
    "fd", "--hidden", "--type", "file", "--exclude", ".git",
  }
  builtin.find_files({
    find_command = command,
    search_dirs = { currentFileDirectory },
  })
end

local function pickFile()
  local builtin = require("telescope.builtin")
  local command = {
    "fd", "--hidden", "--type", "file", "--exclude", ".git",
  }
  builtin.find_files({ find_command = command })
end

local function pickAnyFile()
  local builtin = require("telescope.builtin")
  builtin.find_files({
    hidden = true,
    no_ignore = true
  })
end

local function setMappings()
  local builtin = require("telescope.builtin")

  -- Maps
  u.nmap("<leader><M-m>", u.wrap(builtin.keymaps, {
    modes = {"n", "i", "x", "o", "c"}
  }))
  u.nmap("<M-m>", u.wrap(builtin.keymaps, { modes = {"n"} }))
  u.imap("<M-m>", u.wrap(builtin.keymaps, { modes = {"i"} }))
  u.xmap("<M-m>", u.wrap(builtin.keymaps, { modes = {"x"} }))
  u.omap("<M-m>", u.wrap(builtin.keymaps, { modes = {"o"} }))
  u.cmap("<M-m>", u.wrap(builtin.keymaps, { modes = {"c"} }))

  -- Files
  u.nmap("<leader>t", pickFile)
  u.nmap("<leader><M-t>", pickLocalFile)
  u.nmap("<leader><C-t>", pickAnyFile)

  -- Tags
  u.nmap("<leader>n", u.wrap(builtin.tags, { fname_width = 60}))
  u.nmap("<leader><M-n>", builtin.current_buffer_tags)

  -- Grep
  u.nmap("<leader>h", builtin.live_grep)
  u.nmap("<leader><M-h>", builtin.current_buffer_fuzzy_find)

  -- Helps
  u.nmap("<leader>d", builtin.help_tags)
  u.nmap("<leader><M-d>", u.wrap(builtin.man_pages, { sections = {"ALL"} }))
end

local function apply(addPlugin)
  addPlugin({
    "nvim-telescope/telescope.nvim",
    dependencies = dependencies,
    config = function()
      setup()
      setMappings()
    end,
  })
end

return {
  apply = apply
}
