local u = require("utilities")

-- TODO: use gitsigns to show diff
local function lualine(addPlugin)

  local function location()
    local line = vim.fn.line(".")
    local countOfLines = vim.fn.line("$")
    return line .. ":" .. countOfLines
  end

  addPlugin({
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        theme = "melting",
        component_separators = { left = "╱", right = "╱" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { { "filename", newfile_status = true } },
        lualine_x = { "diagnostics", "filetype" },
        lualine_y = { "encoding" },
        lualine_z = { location }
      },
      inactive_sections = {
        lualine_b = { { "filename", newfile_status = true } },
        lualine_c = {},
        lualine_x = { location },
      },
    }
  })
end

local function floaterm(addPlugin)
  addPlugin({
    "numToStr/FTerm.nvim",
    config = function()
      local fterm = require("FTerm")
      fterm.setup({
        dimensions = {
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

local function messages(addPlugin)
  addPlugin({
    "AckslD/messages.nvim",
    config = function()
      local m = require("messages")
      m.setup({
        command_name = "Messages",

        buffer_opts = function(_)
          local height = vim.api.nvim_list_uis()[1].height
          local width = vim.api.nvim_list_uis()[1].width
          local border =
            { "┌", "─", "┐", "│", "┘", "─", "└", "│" }
          return {
            relative = "editor",
            border = border,
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

      local function luaPrint(opts)
        local api = require("messages.api")

        local result, errorMessage = loadstring("return " .. opts.args)
        if not result then
          if not errorMessage then
            return
          end
          errorMessage = errorMessage:gsub("^.*:%d+: ", "", 1)
          api.open_float("unable to get data:\n" .. errorMessage)
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

      vim.api.nvim_create_user_command("Print", luaPrint, {
        nargs = 1,
        complete = "lua",
      })
    end,
  })
end

local function colors(addPlugin)
  addPlugin({
    "backdround/melting",
    config = function()
      vim.cmd.colorscheme("melting")
    end,
  })
  vim.opt.termguicolors = true
end

local function colorizer(addPlugin)
  addPlugin({
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({})
      u.autocmd("UserHighlightColorsByPatterns", "FileType", {
        desc = "Highlight colors in theme files by color patterns",
        pattern = { "lua", "vim" },
        callback = function()
          local filepath = vim.fn.expand("%:h")
          if not filepath:match("colors") then
            return
          end
          vim.cmd("ColorizerAttachToBuffer")
        end,
      })
    end
  })
end

local function apply(addPlugin)
  lualine(addPlugin)
  floaterm(addPlugin)
  startify(addPlugin)
  messages(addPlugin)
  colors(addPlugin)
  colorizer(addPlugin)
end

return {
  apply = apply,
}
