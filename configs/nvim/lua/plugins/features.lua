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
  _ = plugin_manager
  -- TODO: check nvim-bqf
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
end

return {
  apply = apply,
}
