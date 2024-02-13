local u = require("utilities")
local hacks = require("general.hacks")

local function focus(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/folke/twilight.nvim",
    opts = {
      dimming = {
        alpha = 0.25,
      },
      context = 30,
      treesitter = false,
    },
    lazy = true,
  })

  plugin_manager.add({
    url = "https://github.com/folke/zen-mode.nvim",
    dependencies = "folke/twilight.nvim",
    keys = { { "<M-.>", "<cmd>ZenMode<cr>", desc = "Toggle zen mode" } },
    opts = {
      zindex = 100,
      window = {
        width = 0.70,
        height = 0.92,
        options = {
          signcolumn = "no",
          number = false,
          relativenumber = false,
        },
      },

      -- Disables colorcolumn.
      on_open = function()
        vim.wo.colorcolumn = "0"
      end,
    },
  })
end

local function floaterm(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/numToStr/FTerm.nvim",
    keys = hacks.lazy.generate_keys("nt", { "<F1>", "<F2>", "<F3>" }),
    config = function()
      local fterm = require("FTerm")
      fterm.setup({
        dimensions = {
          border = "single",
          width = 0.91,
          height = 0.91,
          y = 0.4,
        },
      })
      u.nmap("<F1>", fterm.toggle, "Toggle terminal")
      u.adapted_map("t", "<F1>", fterm.toggle, "Close terminal")
      local desc = "Browse termial"
      u.adapted_map("t", "<F2>", "<C-\\><C-n>", desc)
      u.nmap("<F2>", "<Cmd>lua require('FTerm').toggle()<Cr><C-\\><C-n>", desc)
      u.adapted_map("t", "<F3>", fterm.exit, "Exit terminal")
    end,
  })
end

local float_viewer = function()
  local show_float_view = function(text, title)
    local window_height = vim.api.nvim_list_uis()[1].height
    local window_width = vim.api.nvim_list_uis()[1].width
    local window_config = {
      relative = "editor",
      title = title or "Viewer",
      border = "single",
      title_pos = "center",
      width = math.floor(0.7 * window_width),
      height = math.floor(0.85 * window_height),
      row = math.floor(0.05 * window_height),
      col = math.floor(0.15 * window_width),
    }

    hacks.show_in_float_window(text, window_config)

    u.adapted_map("nxo", "<M-s>", "<cmd>q!<cr>", {
      buffer = 0,
      silent = true,
      desc = "Close message window",
    })
  end

  local messages = function(opts)
    local command = opts.args ~= "" and opts.args or "messages"
    local result = vim.fn.execute(command)
    show_float_view(result, command)
  end

  vim.api.nvim_create_user_command("Messages", messages, {
    nargs = "*",
    desc = "Show messages or a command in a floating window",
    complete = "command",
  })

  local lua_print = function(opts)
    ---@type any
    local result, error_message = loadstring("return " .. opts.args)
    if not result then
      result = "Unable to get data:\n" .. error_message
    end

    while type(result) == "function" do
      local pcall_results = { pcall(result) }

      if not pcall_results[1] then
        result = pcall_results[2]
        break
      end

      if #pcall_results > 2 then
        table.remove(pcall_results, 1)
        result = pcall_results
        break
      end

      result = pcall_results[2]
    end

    if type(result) ~= "string" then
      result = vim.inspect(result)
    end
    show_float_view(result, "Lua")
  end

  vim.api.nvim_create_user_command("Lua", lua_print, {
    nargs = 1,
    desc = "Show evaluation of lua in a floating window",
    complete = "lua",
  })

  -- selene: allow(global_usage)
  ---@param message any to show.
  _G.ui_inspect = function(message)
    if type(message) ~= "string" then
      message = vim.inspect(message)
    end

    if message:len() > 0 and message:sub(-1) == "\n" then
      message = message:sub(1, -2)
    end

    show_float_view(message, "Inspect")
  end
end

local function viminput(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/stevearc/dressing.nvim",
    enabled = not LightWeight,
    event = "VeryLazy",
    opts = {
      input = {
        enabled = true,
        insert_only = false,
        start_in_insert = false,
        border = "single",
        win_options = { winblend = 0 },
      },
      select = { enabled = false },
    },
    config = function(_, opts)
      local dressing = require("dressing")
      dressing.setup(opts)

      -- hack: disable all mappings
      local config = require("dressing.config")
      config.input.mappings = {}

      local input = require("dressing.input")

      local completion_visible = function()
        local has_cmp, cmp = pcall(require, "cmp")
        if has_cmp then
          return cmp.visible()
        end
        return vim.fn.pumvisible() == 1
      end

      local confirm = function()
        if completion_visible() then
          local selected = vim.fn.complete_info({ "selected" }).selected ~= -1
          if selected then
            u.feedkeys("<C-y>", "ni")
          else
            u.feedkeys("<C-n><C-y>", "ni")
          end
        else
          input.confirm()
        end
      end

      local close = function()
        if completion_visible() then
          u.feedkeys("<C-e>", "ni")
        else
          input.close()
        end
      end

      local select_next = function()
        if completion_visible() then
          u.feedkeys("<C-n>", "ni")
        else
          u.feedkeys("<C-x><C-u>", "ni")
        end
      end

      local select_previous = function()
        if completion_visible() then
          u.feedkeys("<C-p>", "ni")
        else
          u.feedkeys("<C-x><C-u>", "ni")
        end
      end

      local map = function(lhs, rhs, description)
        u.adapted_map("ni", lhs, rhs, {
          desc = description,
          buffer = true,
        })
      end

      u.autocmd("UserDressingMappings", "FileType", {
        pattern = "DressingInput",
        callback = function()
          map("<M-o>", confirm, "Confirm vim.ui.input")
          map("<M-s>", close, "Close vim.ui.input")
          map("<C-s>", select_next, "Select next")
          map("<C-p>", select_previous, "Select previous")
        end
      })
    end
  })
end

local function illuminate(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/RRethy/vim-illuminate",
    enabled = not LightWeight,
    config = function()
      require("illuminate").configure({
        delay = 150,
        filetypes_denylist = {
          'registers',
          'qf',
        }
      })
    end,
  })
end

local function theme(plugin_manager)
  plugin_manager.add({
    url = "git@github.com:backdround/melting",
    config = function()
      local c = require("melting.colors")
      require("melting").setup({
        highlights = {
          HighlightedyankRegion = { bg = c.gray2 },
        },
      })
    end,
  })
  vim.opt.termguicolors = true
end

local function colors(plugin_manager)
  -- TODO: wait for fix https://github.com/Bekaboo/deadcolumn.nvim/issues/18
  -- and finish setup
  plugin_manager.add({
    url = "https://github.com/uga-rosa/ccc.nvim",
    enabled = not LightWeight,
    opts = {
      disable_default_mappings = true,
      highlight_mode = "bg",
      highlighter = {
        auto_enable = true,
        lsp = true,
      },
    },
  })
end

local deadcolumn = function(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/Bekaboo/deadcolumn.nvim",
    enabled = not LightWeight,
    opts = {
      scope = "visible",
      modes = function()
        local ignore_filetypes = { "help", "markdown" }
        local current_filetype = vim.opt.ft:get()
        return not vim.tbl_contains(ignore_filetypes, current_filetype)
      end,
      blending = {
        threshold = 0.93,
        hlgroup = { "Normal", "bg" },
      },
      warning = {
        alpha = 0.09,
        offset = 11,
        hlgroup = { "PreProc", "fg" },
      },
    },
  })
end

local function apply(plugin_manager)
  focus(plugin_manager)
  floaterm(plugin_manager)
  messages(plugin_manager)
  viminput(plugin_manager)
  illuminate(plugin_manager)
  theme(plugin_manager)
  colors(plugin_manager)
  deadcolumn(plugin_manager)
end

return {
  apply = apply,
}
