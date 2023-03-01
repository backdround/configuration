local u = require("utilities")

local function commenting(addPlugin)
  addPlugin({
    "numToStr/Comment.nvim",
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
          local textToCopy = table.concat(lines, "\n") .. "\n"
          vim.fn.setreg("", textToCopy)
        end,
      })

      local api = require("Comment.api")

      -- Comment operations
      local function visualComment()
        u.resetCurrentMode()
        api.locked("comment.linewise")(vim.fn.visualmode())
      end
      local currentLineComment = api.call("comment.linewise.current", "g@$")
      local operatorComment = api.call("comment.linewise", "g@")

      -- Uncomment operations
      local function visualUncomment()
        u.resetCurrentMode()
        api.locked("uncomment.linewise")(vim.fn.visualmode())
      end
      local currentLineUncomment = api.call("uncomment.linewise.current", "g@$")
      local operatorUncomment = api.call("uncomment.linewise", "g@")

      -- Comment mappings
      local description = "Comment current line"
      u.nmap("bb", currentLineComment, { expr = true, desc = description })
      u.xmap("bb", visualComment, "Comment selected area")
      description = "Comment with motion"
      u.nmap("bd", operatorComment, { expr = true, desc = description })

      -- Uncomment mappings
      description = "Uncomment current line"
      u.nmap("bm", currentLineUncomment, { expr = true, desc = description })
      u.xmap("bm", visualUncomment, "Uncomment selected area")
      description = "Uncomment with motion"
      u.nmap("bh", operatorUncomment, { expr = true, desc = description })
    end,
  })
end

local function autopairs(addPlugin)
  addPlugin({
    "windwp/nvim-autopairs",
    config = function()
      local nvimAutopairs = require("nvim-autopairs")
      nvimAutopairs.setup({
        map_cr = false,
        map_bs = false,
        fast_wrap = {
          map = "<Plug>(user-fastwrap)",
          keys = "htnueogcrpsvmkjq",
          end_key = "i",
        }
      })

      -- Add space inside curly braces.
      local rule = require'nvim-autopairs.rule'
      nvimAutopairs.add_rules({
        rule(' ', ' ')
          :with_pair(function (opts)
            local pair = opts.line:sub(opts.col - 1, opts.col)
            return pair == "{}"
          end)
          :with_del(function (opts)
            local pair = opts.line:sub(opts.col - 1, opts.col + 2)
            return pair == "{  }"
          end)
      })

      -- Map keys
      local mapAutopair = function(autopairFunction)
        return function()
          vim.api.nvim_feedkeys(autopairFunction(), "n", false)
        end
      end
      local cr = mapAutopair(nvimAutopairs.autopairs_cr)
      local bs = mapAutopair(nvimAutopairs.autopairs_bs)
      u.imap("<CR>", cr, "Autopairs new line")
      u.imap("<BS>", bs, "Autopairs backspace")
      u.imap("<M-i>", "<Plug>(user-fastwrap)", "Autopairs fastwrap")
    end,
  })
end

local function targets(addPlugin)
  addPlugin("wellle/targets.vim")

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

local function textobjIndent(addPlugin)
  addPlugin({
    "kana/vim-textobj-indent",
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

local function surround(addPlugin)
  addPlugin("tpope/vim-surround")

  vim.g.surround_no_mappings = 1
  u.nmap("tn", "<Plug>Dsurround", "Remove brackets")
  u.nmap("hn", "<Plug>Csurround", "Change brackets inline")
  u.nmap("hN", "<Plug>CSurround", "Change brackets multilne")
  u.xmap("n", "<Plug>VSurround", "Surround brackets inline")
  u.xmap("N", "<Plug>VgSurround", "Surround brackets multiline")
end

local function exchange(addPlugin)
  addPlugin("tommcdo/vim-exchange")

  u.map("bc", "<Plug>(Exchange)", "Use exchange")
  u.nmap("bC", "<Plug>(ExchangeClear)", "Clear exchange")
  u.nmap("br", "<Plug>(ExchangeLine)", "Line exchange")
end

local function niceblock(addPlugin)
  addPlugin("kana/vim-niceblock")

  vim.g.niceblock_no_default_key_mappings = 1
  u.xmap("G", "<Plug>(niceblock-I)", "Insert at the start of every line")
  u.xmap("C", "<Plug>(niceblock-A)", "Insert at the end of every line")
end

local function move(addPlugin)
  addPlugin("matze/vim-move")

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

local function apply(addPlugin)
  commenting(addPlugin)
  autopairs(addPlugin)
  targets(addPlugin)
  textobjIndent(addPlugin)
  surround(addPlugin)
  exchange(addPlugin)
  niceblock(addPlugin)
  move(addPlugin)
end

return {
  apply = apply,
}
