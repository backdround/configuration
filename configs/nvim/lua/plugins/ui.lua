local u = require("utilities")

local function focus(add_plugin)
  add_plugin({
    "folke/twilight.nvim",
    opts = {
      dimming = {
        alpha = 0.25,
      },
      context = 30,
      treesitter = false,
    },
  })

  add_plugin({
    "folke/zen-mode.nvim",
    dependencies = "folke/twilight.nvim",
    config = function()
      local zen_mode = require("zen-mode")
      zen_mode.setup({
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
      })

      u.nmap("<M-n>", zen_mode.toggle, "Toggle zen mode")
    end,
  })
end

local function floaterm(add_plugin)
  add_plugin({
    "numToStr/FTerm.nvim",
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

local function startify(add_plugin)
  -- TODO: Switch thist to something simplier.
  add_plugin("mhinz/vim-startify")
  vim.g.startify_change_to_dir = 0
  vim.g.startify_change_to_vcs_root = 0
  vim.g.startify_update_oldfiles = 1
  vim.g.startify_fortune_use_unicode = 1
  vim.g.startify_padding_left = 8
  vim.g.startify_files_number = 5

  vim.g.startify_bookmarks = {
    { ci = "~/.config/i3/config" },
    { cv = "~/configuration/configs/nvim/init.vim" },
    { cz = "~/configuration/configs/terminal/zshrc" },
  }

  vim.g.startify_lists = {
    { type = "sessions", header = { "Sessions" } },
    { type = "bookmarks", header = { "Bookmarks" } },
    { type = "files", header = { "MRU" }, indices = { "U", "E", "O", "A" } },
  }

  vim.g.startify_session_dir = "~/.local/share/nvim/sessions/"
  vim.g.startify_session_persistence = 1
  vim.g.startify_session_sort = 1
  vim.g.startify_session_number = 9
end

local function messages(add_plugin)
  add_plugin({
    "AckslD/messages.nvim",
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
          u.nmap("<esc>", ":q!<cr>", {
            buffer = 0,
            silent = true,
            desc = "Close message window",
          })
        end,
      })

      local function lua_print(opts)
        local api = require("messages.api")

        local result, error_message = loadstring("return " .. opts.args)
        if not result then
          if not error_message then
            return
          end
          error_message = error_message:gsub("^.*:%d+: ", "", 1)
          api.open_float("unable to get data:\n" .. error_message)
          return
        end

        while type(result) == "function" do
          result = result()
        end

        if type(result) == "table" then
          api.open_float(vim.inspect(result))
          return
        end

        api.open_float(tostring(result))
      end

      vim.api.nvim_create_user_command("Print", lua_print, {
        nargs = 1,
        complete = "lua",
      })
    end,
  })
end

local function viminput(add_plugin)
  add_plugin({
    "stevearc/dressing.nvim",
    opts = {
      input = {
        enabled = true,
        insert_only = false,
        start_in_insert = false,
        border = "single",
        win_options = { winblend = 0 },
        mappings = {
          n = {
            ["<M-x>"] = "Confirm",
          },
          i = {
            ["<M-x>"] = "Confirm",
          },
        },
      },
      select = { enabled = false },
    },
  })
end

local function colors(add_plugin)
  add_plugin({
    "backdround/melting",
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

local function colorizer(add_plugin)
  add_plugin({
    "NvChad/nvim-colorizer.lua",
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

local function apply(add_plugin)
  focus(add_plugin)
  floaterm(add_plugin)
  startify(add_plugin)
  messages(add_plugin)
  viminput(add_plugin)
  colors(add_plugin)
  colorizer(add_plugin)
end

return {
  apply = apply,
}
