local u = require("utilities")

local dependencies = {
  "nvim-lua/plenary.nvim",
  "benfowler/telescope-luasnip.nvim",
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  "nvim-telescope/telescope-ui-select.nvim",
}

local function setup()
  local actions = require("telescope.actions")
  local telescope = require("telescope")

  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ["<esc>"] = actions.close,
          ["<M-o>"] = actions.select_default,
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
      luasnip = {},
      fzf = {},
      ["ui-select"] = {},
    },
  })

  telescope.load_extension("luasnip")
  telescope.load_extension("fzf")
  telescope.load_extension("ui-select")
end

local function pickLocalFile()
  local builtin = require("telescope.builtin")

  local currentFileDirectory = vim.fn.expand("%:p:h")
  local command = {
    "fd",
    "--hidden",
    "--type",
    "file",
    "--exclude",
    ".git",
  }
  builtin.find_files({
    find_command = command,
    search_dirs = { currentFileDirectory },
  })
end

local function pickFile()
  local builtin = require("telescope.builtin")
  local command = {
    "fd",
    "--hidden",
    "--type",
    "file",
    "--exclude",
    ".git",
  }
  builtin.find_files({ find_command = command })
end

local function pickAnyFile()
  local builtin = require("telescope.builtin")
  builtin.find_files({
    hidden = true,
    no_ignore = true,
  })
end

local function setMappings()
  local telescope = require("telescope")
  local builtin = require("telescope.builtin")

  -- Maps
  u.nmap("<leader><M-m>", function()
    builtin.keymaps({ modes = { "", "n", "i", "x", "o", "c", "s", "t" } })
  end, "Show all mappings")
  u.nmap("<leader><C-M-m>", function()
    builtin.keymaps({
      modes = { "", "n", "i", "x", "o", "c", "s", "t" },
      only_buf = true,
    })
  end, "Show buffer only mappings")

  local modesToMap = { "n", "i", "x", "o", "c", "s" }
  for _, mode in ipairs(modesToMap) do
    local telescopeShowMaps = function()
      builtin.keymaps({
        modes = { mode },
        show_plug = false,
      })
    end

    local telescopeShowAllMaps = function()
      builtin.keymaps({
        modes = { mode },
        show_plug = true,
      })
    end

    -- Fix: https://github.com/nvim-telescope/telescope.nvim/issues/2404
    if mode == "o" then
      telescopeShowMaps = u.wrap(vim.schedule, telescopeShowMaps)
      telescopeShowAllMaps = u.wrap(vim.schedule, telescopeShowAllMaps)
    end

    local mapsDescription = "Show mappings for mode " .. mode
    local allMapsDescription = "Show all mappings for mode " .. mode
    u[mode .. "map"]("<M-m>", telescopeShowMaps, mapsDescription)
    u[mode .. "map"]("<C-M-m>", telescopeShowAllMaps, allMapsDescription)
  end

  -- Files
  u.nmap("<leader>t", pickFile, "Open file in project")
  u.nmap("<leader><M-t>", pickLocalFile, "Open file in current directory")
  u.nmap("<leader><C-t>", pickAnyFile, "Open any file in project")

  -- Tags
  u.nmap("<leader>n", u.wrap(builtin.tags, { fname_width = 60 }), "Go to tag")
  u.nmap("<leader><M-n>", builtin.current_buffer_tags, "Go to local tag ")

  -- TODO: add fuzzy grep.
  -- Grep
  u.nmap("<leader>h", builtin.live_grep, "Goto by grep")
  u.nmap(
    "<leader><M-h>",
    builtin.current_buffer_fuzzy_find,
    "Goto by file grep"
  )

  -- Commands
  u.nmap("<leader>c", builtin.commands, "Show commands")
  u.nmap("<leader><M-c>", builtin.command_history, "Show command history")

  -- TODO: check crispgm/telescope-heading.nvim
  -- Helps
  u.nmap("<leader>d", builtin.help_tags, "Goto by help tags")
  local man_pages = u.wrap(builtin.man_pages, { sections = { "ALL" } })
  u.nmap("<leader><C-d>", man_pages, "Open man page")

  -- Other
  u.nmap("<M-d>", builtin.buffers, "Show buffers")
  u.nmap("<leader>s", telescope.extensions.luasnip.luasnip, "Show snippets")
  u.nmap("<leader>b", builtin.builtin, "Show telescope builtin pickers")
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
  apply = apply,
}
