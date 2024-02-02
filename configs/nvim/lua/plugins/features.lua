local u = require("utilities")
local smart_paste = require("general.hacks.smart-paste")

local function rooter(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/airblade/vim-rooter",
    enabled = not LightWeight,
  })

  vim.g.rooter_patterns = { ".git/" }
  vim.g.rooter_silent_chdir = 1
  vim.g.rooter_resolve_links = 1
end

local function markdown(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/toppair/peek.nvim",
    build = "deno task --quiet build:fast",
    ft = "markdown",
    config = function()
      local peek = require("peek")
      peek.setup({
        auto_load = false,
        app = "browser",
      })

      u.nmap("dm", peek.open, "Open preview")
    end,
  })
end

local function session(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/rmagatti/auto-session",
    enabled = not LightWeight,
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "/", "~/downloads/" },
      })
    end
  })
end

local function search_in_browser(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/tyru/open-browser.vim",
    keys = { "<leader>/", { "<leader>/", mode = "x" } },
    config = function()
      local description = "Search in browser"
      u.nmap("<leader>/", "<Plug>(openbrowser-smart-search)", description)
      u.xmap("<leader>/", "<Plug>(openbrowser-smart-search)", description)
    end
  })
end

local function gutentags(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/ludovicchabant/vim-gutentags",
    enabled = not LightWeight,
  })
  vim.g.gutentags_add_default_project_roots = 0
  vim.g.gutentags_project_root = { ".git" }
  vim.g.gutentags_cache_dir = vim.fn.stdpath("data") .. "/tags"
  vim.g.gutentags_file_list_command = "fd --type file --hidden --exclude .git"
end

local function annotations(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/danymat/neogen",
    enabled = not LightWeight,
    keys = { "bk", "bj" },
    config = function()
      local neogen = require("neogen")
      neogen.setup({
        snippet_engine = "luasnip",
        placeholders_text = {
          ["description"] = "[description]",
          ["tparam"] = "[tparam]",
          ["parameter"] = "[parameter]",
          ["return"] = "[return]",
          ["class"] = "[class]",
          ["throw"] = "[throw]",
          ["varargs"] = "[varargs]",
          ["type"] = "[type]",
          ["attribute"] = "[attribute]",
          ["args"] = "[args]",
          ["kwargs"] = "[kwargs]",
        },
        languages = {
          lua = {
            template = {
              annotation_convention = "emmylua"
            }
          }
        }
      })
      local description = "Generate annotation comment"
      u.nmap("bk", u.wrap(neogen.generate, { type = "any" }), description)
      description = "Generate annotation comment for file"
      u.nmap("bj", u.wrap(neogen.generate, { type = "file" }), description)
    end,
  })
end

local function registers(plugin_manager)
  -- TODO: rewrite the plugin which:
  -- - shows non-interactive window that displays registers with:
  --   - open function
  --   - close function
  -- - opens an "editor" window for registers editing and clearing.
  plugin_manager.add({
    url = "https://github.com/tversteeg/registers.nvim",
    cmd = { "Registers" },
    keys = { { "<C-d>", mode = { "n", "x", "i", "s" } } },

    config = function()
      local r = require("registers")
      r.setup({
        show = '"0-12345abcdefghijklmnopqrstuvwxyz%#.:/*+',
        show_empty = false,
        system_clipboard = false,
        show_register_types = false,
        hide_only_whitespace = true,
        bind_keys = false,

        events = {
          on_register_highlighted = false,
        },

        window = {
          border = "single",
          transparency = 0,
        },

        sign_highlights = {
          selection = "ErrorMsg",
          default = "ErrorMsg",
          unnamed = "ErrorMsg",
          read_only = "Type",
          expression = "Exception",
          black_hole = "ErrorMsg",
          alternate_buffer = "Type",
          last_search = "Type",
          delete = "Special",
          yank = "Keyword",
          history = "Number",
          named = "Keyword",
        },
      })

      -- Global mappings
      local show_window_motion = r.show_window({ mode = "motion" })
      local show_window_insert = r.show_window({ mode = "insert" })

      local description = "Show registers for selection"
      u.nmap("<C-d>", show_window_motion, { desc = description, expr = true })
      u.xmap("<C-d>", show_window_motion, { desc = description, expr = true })
      u.smap("<C-d>", show_window_motion, { desc = description, expr = true })
      u.imap("<C-d>", show_window_insert, { desc = description, expr = true })

      -- Filetype settings
      u.autocmd("UserMapRegistersMappings", "FileType", {
        desc = "Sets settings for registers.nvim window",
        pattern = "registers",
        callback = function()
          vim.schedule(function()
            vim.opt.cursorline = false
          end)

          local local_map = function(lhs, rhs, desc, expr)
            u.adapted_map("nxi", lhs, rhs, {
              desc = desc,
              buffer = true,
              nowait = true,
              expr = expr,
              replace_keycodes = false,
            })
          end

          local clear_current_register = function()
            r.clear_highlighted_register()()
            vim.cmd.wshada({ bang = true })
          end

          local close_window_plug = "<Plug>(user-close-registers-window)"
          u.adapted_map(
            "nxi",
            close_window_plug,
            r._close_window,
            "Close registers.nvim window"
          )

          ---@param register? string
          local use_register = function(register)
            register = r._register_symbol(register)

            local close_window_key = u.replace_termcodes(close_window_plug)

            if not register then
              return close_window_key
            end

            if r._mode == "insert" then
              return close_window_key ..  smart_paste(register)
            end

            local restore_state = ""
            if r._previous_mode_is_visual() then
              restore_state = "gv"
            end

            return close_window_key .. restore_state .. '"' .. register
          end

          local_map("<M-s>", r.close_window(), "Close the window")
          local_map("<C-s>", r.move_cursor_down(), "Move the cursor down")
          local_map("<C-p>", r.move_cursor_up(), "Move the cursor up")
          local_map("<Bs>", clear_current_register, "Clear the register")
          local_map("<Del>", clear_current_register, "Clear the register")

          local_map("<M-o>", use_register, "Accept the current register", true)
          for _, register in ipairs(r._all_registers) do
            local use_selected_register = u.wrap(use_register, register)
            local_map(register, use_selected_register, "Use register", true)
          end
        end,
      })
    end,
  })
end

local function quickfix(plugin_manager)
  local quickfix_inited = false
  u.autocmd("UserEnableQuickfixFilter", "BufWinEnter", {
    pattern = "quickfix",
    desc = "Enable quickfix filter when quickfix window is open",
    callback = function()
      if quickfix_inited then
        return
      end
      quickfix_inited = true
      vim.cmd.packadd({ args = { "cfilter" } })

      -- TODO: fix :chistory or find better way to edit entries by hands
      local remove_current_entry = function()
        local saved_view = vim.fn.winsaveview()

        local current_line = vim.api.nvim_win_get_cursor(0)[1]
        local quickfix_list = vim.fn.getqflist()
        local count = vim.v.count + 1
        for _ = 1, count do
          table.remove(quickfix_list, current_line)
        end
        vim.fn.setqflist(quickfix_list, "r")

        vim.fn.winrestview(saved_view)
      end

      u.nmap("<Del>", remove_current_entry, {
        desc = "Remove current quickfix entry",
        buffer = true,
      })
    end,
  })

  plugin_manager.add({
    url = "https://github.com/ashfinal/qfview.nvim",
    enabled = not LightWeight,
    event = "UIEnter",
    opts = {},
  })

  plugin_manager.add({
    url = "https://github.com/ten3roberts/qf.nvim",
    enabled = not LightWeight,
    event = "UIEnter",
    config = function()
      local qf = require("qf")
      local windows_behaviour = {
        auto_close = false,
        auto_resize = true,
        max_height = 16,
        min_height = 13,
        wide = true,
        number = true,
        relativenumber = true,
      }
      qf.setup({
        l = windows_behaviour,
        c = windows_behaviour,
        close_other = false,
        pretty = false,
        silent = false,
      })

      u.nmap("xx", u.wrap(qf.toggle, "c", false), "Toggle quickfix window")
      u.nmap("xk", u.wrap(qf.below, "c"), "Go to next quickfix entry")
      u.nmap("xj", u.wrap(qf.above, "c"), "Go to previous quickfix entry")
    end,
  })

  -- TODO: rewrite the plugin with only preview concept.
  plugin_manager.add({
    url = "https://github.com/kevinhwang91/nvim-bqf",
    enabled = not LightWeight,
    ft = "qf",
    config = function()
      local height = vim.o.lines / 4
      local qf = require("bqf")
      qf.setup({
        magic_window = false,
        preview = {
          border = "single",
          winblend = 0,
          winheight = height,
        },
        func_map = {
          open = "<M-o>",
          openc = "",
          drop = "",
          split = "<M-e>",
          vsplit = "<M-u>",
          tab = "<M-i>",
          tabb = "<C-i>",
          tabc = "",
          tabdrop = "",
          ptogglemode = "ox",
          ptoggleitem = "",
          ptoggleauto = "",
          pscrollup = "<F16>",
          pscrolldown = "<F15>",
          pscrollorig = "<F14>",
          prevfile = "",
          nextfile = "",
          prevhist = "<",
          nexthist = ">",
          lastleave = "",
          stoggleup = "",
          stoggledown = "",
          stogglevm = "",
          stogglebuf = "",
          sclear = "",
          filter = "",
          filterr = "",
          fzffilter = ""
        },
      })
    end,
  })
end

local icon_picker = function(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/ziontee113/icon-picker.nvim",
    enabled = not LightWeight,
    keys = { { "<M-d>i", mode = { "n", "i" } } },
    config = function()
      local get_icons_from = function(source, spaces)
        local icons = require(source)

        local list = {}
        for description, icon in pairs(icons) do
          table.insert(list, {
            choice = icon .. (" "):rep(spaces) .. description,
            icon = icon,
          })
        end

        return list
      end

      local icon_lists = {
        {
          icons = get_icons_from("icon-picker.icons.alt-fonts", 1),
          desc = "Pick an Alt Font Character",
          choice = "Alt font character",
        },
        {
          icons = get_icons_from("icon-picker.icons.emoji-list", 1),
          desc = "Pick an emoji",
          choice = "Emoji",
        },
        {
          icons = get_icons_from("icon-picker.icons.nf-icon-list", 2),
          desc = "Pick a Nerd Font character",
          choice = "Nerd font character",
        },
        {
          icons = get_icons_from("icon-picker.icons.nf-v3-icon-list", 2),
          desc = "Pick a Nerd Font V3 character",
          choice = "Nerd Font V3 character",
        },
        {
          icons = get_icons_from("icon-picker.icons.symbol-list", 2),
          desc = "Pick a Symbol",
          choice = "Symbol",
        },
        {
          icons = get_icons_from("icon-picker.icons.html-colors", 2),
          desc = "Pick an hexa HTML Color",
          choice = "hexa HTML Color",
        },
      }

      local get_state = function()
        local state = {
          _cursor = vim.api.nvim_win_get_cursor(0),
          _mode = u.mode(),
        }

        state.restore = function()
          if u.mode() == "normal" and state._mode == "insert" then
            vim.cmd.startinsert()
          end
          vim.api.nvim_win_set_cursor(0, state._cursor)
        end

        return state
      end

      local select_icon = function(state, list)
        if not list then
          return
        end

        vim.ui.select(list.icons, {
          prompt = list.desc,
          format_item = function(item)
            return item.choice
          end,
        }, function(item)
          state.restore()

          if not item then
            return
          end

          vim.api.nvim_put({ item.icon }, "c", true, true)
        end)
      end

      local select_list = function()
        vim.ui.select(icon_lists, {
          prompt = "Select icon type",
          format_item = function(item)
            return item.choice
          end,
        }, u.wrap(select_icon, get_state()))
      end

      u.adapted_map("ni", "<M-d>i", select_list, "Pick icon")
    end,
  })
end

local function apply(plugin_manager)
  rooter(plugin_manager)
  markdown(plugin_manager)
  session(plugin_manager)
  search_in_browser(plugin_manager)
  gutentags(plugin_manager)
  annotations(plugin_manager)
  registers(plugin_manager)
  quickfix(plugin_manager)
  icon_picker(plugin_manager)
end

return {
  apply = apply,
}
