local u = require("utilities")

local dependencies = {
  "nvim-lua/plenary.nvim",
  "benfowler/telescope-luasnip.nvim",
  {
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  "nvim-telescope/telescope-ui-select.nvim",
  "nvim-telescope/telescope-file-browser.nvim",
}

local function setup()
  local actions = require("telescope.actions")
  local telescope = require("telescope")

  local open_buffer_with_previous_buffer_deletion = function(prompt_buffer)
    actions.select_default(prompt_buffer)
    local alternative_buffer = vim.fn.bufnr("#")

    -- Remove buffer if it isn't visible in the current tab.
    if vim.fn.bufwinid(alternative_buffer) == -1 then
      require("tabscope").remove_tab_buffer(alternative_buffer)
    end
  end

  local open_vertical_left = function(prompt_buffer)
    local saved_splitright = vim.opt.splitright:get()
    vim.opt.splitright = false
    actions.select_vertical(prompt_buffer)
    vim.opt.splitright = saved_splitright
  end

  local open_vertical_right = function(prompt_buffer)
    local saved_splitright = vim.opt.splitright:get()
    vim.opt.splitright = true
    actions.select_vertical(prompt_buffer)
    vim.opt.splitright = saved_splitright
  end

  local select_and_move_down = function(prompt_buffer)
    actions.toggle_selection(prompt_buffer)
    actions.move_selection_next(prompt_buffer)
  end

  local telescope_mappings = {
    ["<M-s>"] = actions.close,
    ["<M-v>"] = select_and_move_down,
    ["<M-x>"] = actions.smart_send_to_qflist,

    ["<C-s>"] =  actions.move_selection_next,
    ["<C-p>"] = actions.move_selection_previous,

    ["<M-a>"] = open_buffer_with_previous_buffer_deletion,
    ["<M-o>"] = actions.select_default,
    ["<M-e>"] = actions.select_horizontal,
    ["<M-u>"] = open_vertical_right,
    ["<M-S-u>"] = open_vertical_left,
    ["<M-i>"] = actions.select_tab,

    ["<M-c>"] = actions.results_scrolling_right,
    ["<M-g>"] = actions.results_scrolling_left,
  }

  local file_actions = require("telescope._extensions.file_browser.actions")
  local telescope_file_browser_mappings = {
    ["<C-v>"] = file_actions.goto_parent_dir,
    ["<C-y>"] = actions.select_default,

    ["<M-d>c"] = file_actions.create,
    ["<M-d><M-c>"] = file_actions.create_from_prompt,
    ["<M-d>t"] = file_actions.remove,
    ["<M-d>r"] = file_actions.rename,
    ["<M-d>f"] = file_actions.copy,
    ["<M-d>m"] = file_actions.move,
    ["<M-d>."] = file_actions.toggle_hidden,
  }

  telescope.setup({
    defaults = {
      default_mappings = {},
      mappings = {
        i = telescope_mappings,
        n = telescope_mappings,
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
      file_browser = {
        hidden = true,
        grouped = true,
        layout_strategy = "horizontal",
        layout_config = {
          prompt_position = "top",
          height = 0.85,
          width = 0.8,
          mirror = false,
          preview_cutoff = 190,
          preview_width = 90,
        },
        mappings = {
          i = telescope_file_browser_mappings,
          n = telescope_file_browser_mappings,
        },
      },
    },
  })

  -- Hack: Remove all default file_browser mappings
  require("telescope._extensions.file_browser.config").values.mappings = {}

  telescope.load_extension("luasnip")
  telescope.load_extension("fzf")
  telescope.load_extension("ui-select")
  telescope.load_extension("file_browser")
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
  end, "Show mappings for all possible modes")

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

    local telescope_show_local_maps = function()
      builtin.keymaps({
        modes = { "", "n", "i", "x", "o", "c", "s", "t" },
        only_buf = true,
      })
    end

    -- Fix: https://github.com/nvim-telescope/telescope.nvim/issues/2404
    if mode == "o" then
      telescope_show_maps = u.wrap(vim.schedule, telescope_show_maps)
      telescope_show_all_maps = u.wrap(vim.schedule, telescope_show_all_maps)
      telescope_show_local_maps =
        u.wrap(vim.schedule, telescope_show_local_maps)
    end

    local description = "Show mappings for mode " .. mode
    u[mode .. "map"]("<M-m>", telescope_show_maps, description)
    description = "Show all mappings for mode " .. mode
    u[mode .. "map"]("<C-M-m>", telescope_show_all_maps, description)
    description = "Show buffer only mappings"
    -- Map to <C-/> (<C-_> is a workaround).
    u[mode .. "map"]("<C-_>", telescope_show_local_maps, description)
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
  u.nmap("<leader>w", builtin.commands, "Show commands")
  u.nmap("<leader><M-w>", builtin.command_history, "Show command history")

  -- TODO: check crispgm/telescope-heading.nvim
  -- Helps
  u.nmap("<leader>d", builtin.help_tags, "Goto by help tags")
  local man_pages = u.wrap(builtin.man_pages, { sections = { "ALL" } })
  u.nmap("<leader><C-d>", man_pages, "Open man page")

  -- File manager
  local open_manager = ":Telescope file_browser<CR>"
  u.nmap("<leader>c", open_manager, "Open file browser in the project root")

  local open_local_manager =
    ":Telescope file_browser path=%:p:h select_buffer=true<CR>"
  local description = "Open file browser near the current file"
  u.nmap("<leader><M-c>", open_local_manager, description)

  -- Other
  u.nmap("<leader>b", builtin.buffers, "Show buffers")
  u.nmap("<leader>s", telescope.extensions.luasnip.luasnip, "Show snippets")
  u.nmap("<leader>p", builtin.builtin, "Show telescope builtin pickers")
  u.nmap("<leader>x", builtin.quickfix, "Show telescope by quickfix entries")
end

local function apply(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/nvim-telescope/telescope.nvim",
    enabled = not LightWeight,
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
