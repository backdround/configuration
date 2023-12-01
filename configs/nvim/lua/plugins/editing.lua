local u = require("utilities")

local function commenting(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/numToStr/Comment.nvim",
    enabled = not LightWeight,
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

      local api = require("Comment.api")

      -- Comment operations
      local function visual_comment()
        u.reset_current_mode()
        api.locked("comment.linewise")(vim.fn.visualmode())
      end
      local current_line_comment = api.call("comment.linewise.current", "g@$")
      local operator_comment = api.call("comment.linewise", "g@")

      -- Uncomment operations
      local function visual_uncomment()
        u.reset_current_mode()
        api.locked("uncomment.linewise")(vim.fn.visualmode())
      end
      local current_line_uncomment =
        api.call("uncomment.linewise.current", "g@$")
      local operator_uncomment = api.call("uncomment.linewise", "g@")

      -- Comment mappings
      local description = "Comment current line"
      u.nmap("bb", current_line_comment, { expr = true, desc = description })
      u.xmap("bb", visual_comment, "Comment selected area")
      description = "Comment with motion"
      u.nmap("bd", operator_comment, { expr = true, desc = description })

      -- Uncomment mappings
      description = "Uncomment current line"
      u.nmap("bm", current_line_uncomment, { expr = true, desc = description })
      u.xmap("bm", visual_uncomment, "Uncomment selected area")
      description = "Uncomment with motion"
      u.nmap("bh", operator_uncomment, { expr = true, desc = description })
    end,
  })
end

local function autopairs(plugin_manager)
  -- TODO: to make a request for floating buffer insteard of virsual line
  plugin_manager.add({
    url = "https://github.com/windwp/nvim-autopairs",
    config = function()
      local nvim_autopairs = require("nvim-autopairs")
      nvim_autopairs.setup({
        map_cr = false,
        map_bs = false,
        fast_wrap = {
          map = "<Plug>(user-fastwrap)",
          pattern = [=[[ %'%"%>%]%)%}%,]]=],
          keys = "htngcrmaoeu",
          end_key = "i",
          manual_position = false,
        },
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

      -- Map keys
      local map_autopair = function(autopair_function)
        return function()
          vim.api.nvim_feedkeys(autopair_function(), "n", false)
        end
      end
      local cr = map_autopair(nvim_autopairs.autopairs_cr)
      local bs = map_autopair(nvim_autopairs.autopairs_bs)
      u.imap("<CR>", cr, "Autopairs new line")
      u.imap("<BS>", bs, "Autopairs backspace")
      u.imap("<M-i>", "<Plug>(user-fastwrap)", "Autopairs fastwrap")
    end,
  })
end

local function targets(plugin_manager)
  plugin_manager.add("wellle/targets.vim")

  vim.g.targets_aiAI = {
    "<Plug>(user-an-object)",
    "<Plug>(user-in-object)",
    "",
    "",
  }

  u.omap("g", "<Plug>(user-an-object)", "Use an object")
  u.xmap("g", "<Plug>(user-an-object)", "Select an object")

  u.omap("c", "<Plug>(user-in-object)", "Use in object")
  u.xmap("c", "<Plug>(user-in-object)", "Select in object")

  vim.g.targets_mapped_aiAI = {
    "<Plug>(virtual-visual-a)",
    "<Plug>(virtual-visual-i)",
    "",
    "",
  }
  vim.g.targets_nl = { "t", "h" }

  u.map("<Plug>(virtual-visual-a)", "a", "An object mapping for 'targets'")
  u.map("<Plug>(virtual-visual-i)", "i", "In object mapping for 'targets'")
end

local function textobj_indent(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/kana/vim-textobj-indent",
    dependencies = "kana/vim-textobj-user",
  })

  vim.g.textobj_indent_no_default_key_mappings = 1
  u.xmap(
    "<Plug>(virtual-visual-a)u",
    "<Plug>(textobj-indent-a)",
    "Select current indent"
  )
  u.omap(
    "<Plug>(virtual-visual-a)u",
    "<Plug>(textobj-indent-a)",
    "Use current indent"
  )
  u.xmap(
    "<Plug>(virtual-visual-i)u",
    "<Plug>(textobj-indent-i)",
    "Select current paragraph indent"
  )
  u.omap(
    "<Plug>(virtual-visual-i)u",
    "<Plug>(textobj-indent-i)",
    "Use current paragraph indent"
  )
end

local function surround(plugin_manager)
  plugin_manager.add("tpope/vim-surround")

  vim.g.surround_no_mappings = 1
  u.nmap("tn", "<Plug>Dsurround", "Remove brackets")
  u.nmap("hn", "<Plug>Csurround", "Change brackets inline")
  u.nmap("hN", "<Plug>CSurround", "Change brackets multilne")
  u.xmap("n", "<Plug>VSurround", "Surround brackets inline")
  u.xmap("N", "<Plug>VgSurround", "Surround brackets multiline")
end

local function exchange(plugin_manager)
  plugin_manager.add("tommcdo/vim-exchange")

  u.map("bc", "<Plug>(Exchange)", "Use exchange")
  u.nmap("bC", "<Plug>(ExchangeClear)", "Clear exchange")
  u.nmap("br", "<Plug>(ExchangeLine)", "Line exchange")
end

local function niceblock(plugin_manager)
  plugin_manager.add("kana/vim-niceblock")

  vim.g.niceblock_no_default_key_mappings = 1
  u.xmap("G", "<Plug>(niceblock-I)", "Insert at the start of every line")
  u.xmap("C", "<Plug>(niceblock-A)", "Insert at the end of every line")
end

local function move(plugin_manager)
  plugin_manager.add("matze/vim-move")

  vim.g.move_map_keys = 0
  u.nmap("<M-g>", "<Plug>MoveLineDown", "Move line down")
  u.nmap("<M-c>", "<Plug>MoveLineUp", "Move line up")
  u.nmap("<M-f>", "<Plug>MoveCharLeft", "Move current character left")
  u.nmap("<M-r>", "<Plug>MoveCharRight", "Move current character right")

  u.xmap("<M-g>", "<Plug>MoveBlockDown", "Move selected lines down")
  u.xmap("<M-c>", "<Plug>MoveBlockUp", "Move selected lines up")
  u.xmap("<M-f>", "<Plug>MoveBlockLeft", "Move selected text left")
  u.xmap("<M-r>", "<Plug>MoveBlockRight", "Move selected text right")
end

local function align(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/Vonr/align.nvim",
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
