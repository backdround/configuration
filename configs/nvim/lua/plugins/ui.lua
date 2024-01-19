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
      u.tmap("<F1>", fterm.toggle, "Close terminal")
      local desc = "Browse termial"
      u.tmap("<F2>", "<C-\\><C-n>", desc)
      u.nmap("<F2>", "<Cmd>lua require('FTerm').toggle()<Cr><C-\\><C-n>", desc)
      u.tmap("<F3>", fterm.exit, "Exit terminal")
    end,
  })
end

local function messages(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/AckslD/messages.nvim",
    cmd = { "Messages", "Lua", "Echo" },
    event = {
      { event = "ModeChanged", pattern = "*:*c*" },
    },
    config = function()
      local m = require("messages")
      m.setup({
        command_name = "Messages",

        buffer_opts = function(_)
          local height = vim.api.nvim_list_uis()[1].height
          local width = vim.api.nvim_list_uis()[1].width
          return {
            relative = "editor",
            border = "single",
            width = math.floor(0.7 * width),
            height = math.floor(0.85 * height),
            row = math.floor(0.05 * height),
            col = math.floor(0.15 * width),
          }
        end,

        post_open_float = function()
          vim.opt.colorcolumn = ""
          u.adapted_map("nxo", "<M-s>", "<cmd>q!<cr>", {
            buffer = 0,
            silent = true,
            desc = "Close message window",
          })
        end,
      })

      local function lua_print(opts)
        local api = require("messages.api")

        ---@type any
        local result, error_message = loadstring("return " .. opts.args)
        if not result then
          error_message = (error_message or ""):gsub("^.*:%d+: ", "", 1)
          result = "Unable to get data:\n" .. error_message
        end

        while type(result) == "function" do
          result = result()
        end

        if type(result) == "table" then
          result = vim.inspect(result)
        end

        api.open_float(tostring(result))
      end

      vim.api.nvim_create_user_command("Lua", lua_print, {
        nargs = 1,
        complete = "lua",
      })

      vim.api.nvim_create_user_command("Echo", function(opts)
        local api = require("messages.api")
        api.open_float(opts.args)
      end, { nargs = 1 })
    end,
  })
end

local function viminput(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/stevearc/dressing.nvim",
    enabled = not LightWeight,
    opts = {
      input = {
        enabled = true,
        insert_only = false,
        start_in_insert = false,
        border = "single",
        win_options = { winblend = 0 },
        mappings = {
          n = {
            ["<M-s>"] = "Close",
            ["<M-o>"] = "Confirm",
          },
          i = {
            ["<M-s>"] = "Close",
            ["<M-o>"] = "Confirm",
          },
        },
      },
      select = { enabled = false },
    },
  })
end

local function illuminate(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/RRethy/vim-illuminate",
    enabled = not LightWeight,
    config = function()
      require("illuminate").configure({
        delay = 150,
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

local function colorizer(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/NvChad/nvim-colorizer.lua",
    enabled = not LightWeight,
    opts = {
      filetypes = {
        "lua",
      },
      user_default_options = {
        names = false,
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
  colorizer(plugin_manager)
end

return {
  apply = apply,
}
