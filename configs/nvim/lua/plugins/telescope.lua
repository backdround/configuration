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

local function pick_local_file()
  local builtin = require("telescope.builtin")

  local current_file_directory = vim.fn.expand("%:p:h")
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
    search_dirs = { current_file_directory },
  })
end

local function pick_file()
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

local function pick_any_file()
  local builtin = require("telescope.builtin")
  builtin.find_files({
    hidden = true,
    no_ignore = true,
  })
end

local function set_mappings()
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

  local modes_to_map = { "n", "i", "x", "o", "c", "s" }
  for _, mode in ipairs(modes_to_map) do
    local telescope_show_maps = function()
      builtin.keymaps({
        modes = { mode },
        show_plug = false,
      })
    end

    local telescope_show_all_maps = function()
      builtin.keymaps({
        modes = { mode },
        show_plug = true,
      })
    end

    -- Fix: https://github.com/nvim-telescope/telescope.nvim/issues/2404
    if mode == "o" then
      telescope_show_maps = u.wrap(vim.schedule, telescope_show_maps)
      telescope_show_all_maps = u.wrap(vim.schedule, telescope_show_all_maps)
    end

    local maps_description = "Show mappings for mode " .. mode
    local all_maps_description = "Show all mappings for mode " .. mode
    u[mode .. "map"]("<M-m>", telescope_show_maps, maps_description)
    u[mode .. "map"]("<C-M-m>", telescope_show_all_maps, all_maps_description)
  end

  -- Files
  u.nmap("<leader>t", pick_file, "Open file in project")
  u.nmap("<leader><M-t>", pick_local_file, "Open file in current directory")
  u.nmap("<leader><C-t>", pick_any_file, "Open any file in project")

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

local function apply(add_plugin)
  add_plugin({
    "nvim-telescope/telescope.nvim",
    dependencies = dependencies,
    config = function()
      setup()
      set_mappings()
    end,
  })
end

return {
  apply = apply,
}
