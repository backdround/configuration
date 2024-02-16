local u = require("utilities")
local smart_paste = require("general.hacks.smart-paste")

local buffer_reloader = function()
  local checker = u.new_debouncer(nil, vim.cmd.checktime, 10)
  u.autocmd("UserLoadChangedBuffers", { "FocusGained", "BufEnter" }, {
    callback = checker.run,
  })

  u.autocmd("UserNotifyAfterBuffersLoading", "FileChangedShellPost", {
    command = 'echo "Some buffers changed!"',
  })
end

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
    keys = { "x/", { "x/", mode = "x" } },
    config = function()
      local description = "Search in a browser"
      u.nmap("x/", "<Plug>(openbrowser-smart-search)", description)
      u.xmap("x/", "<Plug>(openbrowser-smart-search)", description)
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
      u.adapted_map("s", "<C-d>", show_window_motion, {
        desc = description,
        expr = true
      })
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

  local qf_toggle = function()
    local quickfix_window_id = vim.fn.getqflist({ winid = 0 }).winid
    local action = quickfix_window_id > 0 and 'cclose' or 'copen'
    vim.cmd("botright 12" .. action)
  end

  u.nmap("xx", qf_toggle, "Toggle quickfix window")
  u.nmap("<M-j>", "<Cmd>cnext<Cr>", "Go to next quickfix entry")
  u.nmap("<M-k>", "<Cmd>cprev<Cr>", "Go to previous quickfix entry")

  plugin_manager.add({
    url = "https://github.com/ashfinal/qfview.nvim",
    enabled = not LightWeight,
    event = "UIEnter",
    opts = {},
  })

  -- TODO: rewrite the plugin with only preview concept.
  plugin_manager.add({
    url = "https://github.com/kevinhwang91/nvim-bqf",
    enabled = not LightWeight,
    ft = "qf",
    config = function()
      local qf = require("bqf")
      qf.setup({
        magic_window = false,
        preview = {
          border = "single",
          winblend = 0,
          win_height = 30,
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

local playground = function()
  local ensure_file_exists = function(filepath)
    local stat = vim.loop.fs_stat(filepath)
    if stat and stat.type == "file" then
      return
    end

    if stat and stat.type ~= "file" then
      local template = "Path %s already exists and it's not a file!"
      error(template:format(filepath))
    end

    local file, err = io.open(filepath, "w")
    if not file then
      error(err)
    end

    file:close()
  end

  ---@type string
  ---@diagnostic disable-next-line: assign-type-mismatch
  local config_directory = vim.fn.stdpath("config")
  local filepath = vim.fs.joinpath(config_directory, "playground.lua")

  u.autocmd("UserSourcePlayground", "BufWritePost", {
    desc = "Source playground on save",
    pattern = filepath,
    callback = u.wrap(dofile, filepath),
  })

  local open_playground = function()
    ensure_file_exists(filepath)
    vim.cmd.edit({ args = { filepath } })
  end

  u.nmap("<leader>y", open_playground, "Open playground")
end

local global_note = function(plugin_manager)
  plugin_manager.add({
    url = "git@github.com:backdround/global-note.nvim.git",
    config = function()
      local get_project_name = function()
        local work_directory, err = vim.loop.cwd()
        if work_directory == nil then
          error(err)
        end

        local project_name = vim.fs.basename(work_directory)
        if project_name == nil then
          error("Unable to get the project name!")
        end

        return project_name
      end

      local upper_first_character = function(s)
        return s:sub(1, 1):upper() .. s:sub(2, -1)
      end

      local gn = require("global-note")
      gn.setup({
        post_open = function()
          u.adapted_map("nxo", "<M-s>", "<cmd>quit<cr>", {
            buffer = true,
            silent = true,
            desc = "Close the note window",
          })
        end,
        additional_presets = {
          project_local = {
            command_name = "ProjectNote",
            filename = function()
              return get_project_name() .. ".md"
            end,
            title = function()
              return upper_first_character(get_project_name())
            end,
          },
        },
      })

      local toggle_project_note = u.wrap(gn.toggle_note, "project_local")
      u.nmap("<leader><M-i>", toggle_project_note, "Toggle project local note")
      u.nmap("<leader>i", gn.toggle_note, "Toggle global note")
    end
  })
end

local function apply(plugin_manager)
  buffer_reloader()
  rooter(plugin_manager)
  markdown(plugin_manager)
  session(plugin_manager)
  search_in_browser(plugin_manager)
  gutentags(plugin_manager)
  annotations(plugin_manager)
  registers(plugin_manager)
  quickfix(plugin_manager)
  icon_picker(plugin_manager)
  playground()
  global_note(plugin_manager)
end

return {
  apply = apply,
}
