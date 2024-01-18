local u = require("utilities")
local hacks = require("general.hacks")

local function commenting(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/numToStr/Comment.nvim",
    enabled = not LightWeight,
    keys = hacks.lazy.generate_keys("nx", { "bb", "b<M-b>", "bm", "b<M-m>" }),
    config = function()
      require("Comment").setup({
        ignore = "^$",
        mappings = {
          basic = false,
          extra = false,
        },
        -- Copy commented lines
        pre_hook = function(ctx)
          local utils = require("Comment.utils")

          local cmotion = utils.cmotion
          if ctx.cmotion ~= cmotion.line and ctx.cmotion ~= cmotion.V then
            -- There aren't commenting in linewise motion
            return
          end

          -- Copies lines
          local lines = utils.get_lines(ctx.range)
          local text_to_copy = table.concat(lines, "\n") .. "\n"
          vim.fn.setreg("", text_to_copy)
        end,
      })

      local map = function(mode, lhs, rhs, description)
        u.adapted_map(mode, lhs, rhs, {
          desc = description,
          expr = true,
        })
      end

      local api = require("Comment.api")

      -- Comment operations
      local comment_current = api.call("comment.linewise.current", "g@$")
      local comment_count_repeat =
        api.call("comment.linewise.count_repeat", "g@$")
      local instant_comment = function()
        return vim.v.count == 0 and comment_current() or comment_count_repeat()
      end

      local uncomment_current = api.call("comment.linewise.current", "g@$")
      local uncomment_count_repeat =
        api.call("comment.linewise.count_repeat", "g@$")
      local instant_uncomment = function()
        return vim.v.count == 0 and uncomment_current()
          or uncomment_count_repeat()
      end

      local operator_comment = api.call("comment.linewise", "g@")
      local operator_uncomment = api.call("uncomment.linewise", "g@")

      -- Mappings
      map("n", "bb", instant_comment, "Comment current line (with v:count)")
      map("n", "bm", instant_uncomment, "Uncomment current line (with v:count)")

      map("x", "bb", operator_comment, "Comment selected area")
      map("x", "bm", operator_uncomment, "Uncomment selected area")

      map("n", "b<M-b>", operator_comment, "Comment with motion")
      map("n", "b<M-m>", operator_uncomment, "Uncomment with motion")
    end,
  })
end

-- TODO: Create a separate plugin for a fastwrap like in
-- https://github.com/altermo/ultimate-autopair.nvim (check demo)
local function autopairs(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local nvim_autopairs = require("nvim-autopairs")
      nvim_autopairs.setup({
        ignored_next_char = [=[[%%%[%.%`%$]]=],
        map_cr = false,
        map_bs = false,
      })

      -- Add space inside curly braces.
      local rule = require("nvim-autopairs.rule")
      nvim_autopairs.add_rules({
        rule(" ", " ")
          :with_pair(function(opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return pair == "{}" or pair == "[]"
          end)
          :with_del(function(opts)
            local pair = opts.line:sub(opts.col - 1, opts.col + 2)
            return pair == "{  }" or pair == "[  ]"
          end),
      })

      vim.keymap.set("i", "<BS>", nvim_autopairs.autopairs_bs, {
        desc = "Autopairs backspace",
        expr = true,
        replace_keycodes = false,
      })

      vim.keymap.set("i", "<CR>", nvim_autopairs.autopairs_cr, {
        desc = "Autopairs new line",
        expr = true,
        replace_keycodes = false,
      })
    end,
  })
end

local function targets(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/wellle/targets.vim",
    event = {
      { event = "ModeChanged", pattern = "*:[vV\\x16]*" },
      { event = "ModeChanged", pattern = "*:*o*" },
    },
  })

  vim.g.targets_aiAI = {
    "<Plug>(user-an-object)",
    "<Plug>(user-in-object)",
    "",
    "",
  }

  u.adapted_map("ox", "g", "<Plug>(user-an-object)", "An object")
  u.adapted_map("ox", "c", "<Plug>(user-in-object)", "In object")

  vim.g.targets_mapped_aiAI = {
    "<Plug>(virtual-text-a)",
    "<Plug>(virtual-text-i)",
    "",
    "",
  }
  vim.g.targets_nl = { "t", "h" }

  u.adapted_map("ox", "<Plug>(virtual-text-a)", "a", "An object mapping")
  u.adapted_map("ox", "<Plug>(virtual-text-i)", "i", "In object mapping")
end

local function textobj_indent(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/kana/vim-textobj-indent",
    dependencies = "kana/vim-textobj-user",
    event = {
      { event = "ModeChanged", pattern = "*:[vV\\x16]*" },
      { event = "ModeChanged", pattern = "*:*o*" },
    },
  })

  vim.g.textobj_indent_no_default_key_mappings = 1
  u.adapted_map(
    "xo",
    "<Plug>(virtual-text-a)u",
    "<Plug>(textobj-indent-a)",
    "Current indent"
  )
  u.adapted_map(
    "xo",
    "<Plug>(virtual-text-i)u",
    "<Plug>(textobj-indent-i)",
    "Current paragraph indent"
  )
end

local function surround(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/kylechui/nvim-surround",
    keys = {
      "tn",
      "hn",
      "hN",
      { "n", mode = "x" },
      { "N", mode = "x" },
      "<M-n>",
      "<C-M-n>",
    },
    config = function()
      require("nvim-surround").setup({
        keymaps = {},
        move_cursor = false,
      })

      local plug = function(name)
        return "<Plug>(nvim-surround-" .. name .. ")"
      end

      u.nmap("tn", plug("delete"), "Delete a surrounding pair")
      u.nmap("hn", plug("change"), "Change a surrounding pair inline")
      u.nmap("hN", plug("change-line"), "Change a surrounding pair multiline")
      u.xmap("n", plug("visual"), "Add a surrounding pair inline")
      u.xmap("N", plug("visual-line"), "Add a surrounding pair multiline")
      u.nmap("<M-n>", plug("normal"), "Add a surrounding pair inline")
      u.nmap("<C-M-n>", plug("normal-line"), "Add a surrounding pair multiline")
    end,
  })
end

local function exchange(plugin_manager)
  vim.g.exchange_no_mappings = true
  plugin_manager.add({
    url = "https://github.com/tommcdo/vim-exchange",
    keys = { "bC", "br", { "bc", mode = { "n", "x", "o" } } },
    config = function()
      u.map("bc", "<Plug>(Exchange)", "Use exchange")
      u.nmap("bC", "<Plug>(ExchangeClear)", "Clear exchange")
      u.nmap("br", "<Plug>(ExchangeLine)", "Line exchange")
    end,
  })
end

local function niceblock(plugin_manager)
  vim.g.niceblock_no_default_key_mappings = 1
  plugin_manager.add({
    url = "https://github.com/kana/vim-niceblock",
    keys = { { "G", mode = "x" }, { "C", mode = "x" } },
    config = function()
      u.xmap("G", "<Plug>(niceblock-I)", "Insert at the start of every line")
      u.xmap("C", "<Plug>(niceblock-A)", "Insert at the end of every line")
    end,
  })
end

local function move(plugin_manager)
  vim.g.move_map_keys = 0
  local keys = { "<M-g>", "<M-c>", "<M-f>", "<M-r>" }
  plugin_manager.add({
    url = "https://github.com/matze/vim-move",
    keys = hacks.lazy.generate_keys("nx", keys),
    config = function()
      u.nmap("<M-g>", "<Plug>MoveLineDown", "Move line down")
      u.nmap("<M-c>", "<Plug>MoveLineUp", "Move line up")
      u.nmap("<M-f>", "<Plug>MoveCharLeft", "Move current character left")
      u.nmap("<M-r>", "<Plug>MoveCharRight", "Move current character right")

      u.xmap("<M-g>", "<Plug>MoveBlockDown", "Move selected lines down")
      u.xmap("<M-c>", "<Plug>MoveBlockUp", "Move selected lines up")
      u.xmap("<M-f>", "<Plug>MoveBlockLeft", "Move selected text left")
      u.xmap("<M-r>", "<Plug>MoveBlockRight", "Move selected text right")
    end
  })
end

local function align(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/Vonr/align.nvim",
    keys = hacks.lazy.generate_keys("nxo", { "ba", "b<M-a>" }),
    config = function()
      local a = require("align")
      local align_to_char = u.wrap(a.operator, a.align_to_char)
      local align_to_string = u.wrap(a.operator, a.align_to_string)
      u.map("ba", align_to_char, "Align to a character")
      u.map("b<M-a>", align_to_string, "Align to a string")
    end,
  })
end

---@param plugin_manager UserPluginManager
local function apply(plugin_manager)
  commenting(plugin_manager)
  autopairs(plugin_manager)
  targets(plugin_manager)
  textobj_indent(plugin_manager)
  surround(plugin_manager)
  exchange(plugin_manager)
  niceblock(plugin_manager)
  move(plugin_manager)
  align(plugin_manager)
end

return {
  apply = apply,
}
