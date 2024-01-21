local u = require("utilities")

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
  plugin_manager.add({
    url = "https://github.com/tversteeg/registers.nvim",
    cmd = { "Registers" },
    keys = { { "<C-d>", mode = { "n", "x", "i" } } },

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

      local use_register_insert = function()
        if vim.fn.reg_executing() ~= "" or vim.fn.reg_recording() ~= "" then
          return "<C-r><C-p>"
        end
        return show_window_insert()
      end

      local use_register_motion = function()
        if vim.fn.reg_executing() ~= "" or vim.fn.reg_recording() ~= "" then
          return '"'
        end
        return show_window_motion()
      end

      local description = "Show registers for selection"
      u.nmap("<C-d>", use_register_motion, { desc = description, expr = true })
      u.xmap("<C-d>", use_register_motion, { desc = description, expr = true })
      u.imap("<C-d>", use_register_insert, { desc = description, expr = true })

      -- Filetype settings
      u.autocmd("UserMapRegistersMappings", "FileType", {
        desc = "Sets settings for registers.nvim window",
        pattern = "registers",
        callback = function()
          vim.schedule(function()
            vim.opt.cursorline = false
          end)

          local local_map = function(lhs, rhs, desc)
            u.adapted_map("nxi", lhs, rhs, {
              desc = desc,
              buffer = true,
              nowait = true,
            })
          end

          local clear = function()
            r.clear_highlighted_register()()
            vim.cmd.wshada({ bang = true })
          end

          local_map("<M-s>", r.close_window(), "Close the window")
          local_map("<M-o>", r.apply_register(), "Accept the current register")
          local_map("<C-s>", r.move_cursor_down(), "Move the cursor down")
          local_map("<C-p>", r.move_cursor_up(), "Move the cursor up")
          local_map("<Bs>", clear, "Clear the register")
          local_map("<Del>", clear, "Clear the register")

          local apply_register = r.apply_register()
          for _, register_name in ipairs(r._all_registers) do
            local apply_current_register = function()
              apply_register(register_name, r._mode)
            end
            local_map(register_name, apply_current_register, "Apply register")
          end
        end
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
