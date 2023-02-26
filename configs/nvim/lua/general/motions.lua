local u = require("utilities")
local hacks = require("general.hacks")

local function wordMotion(addPlugin)
  -- Base mode
  u.map("w", "b")
  u.map("j", "w")
  u.map("q", "ge")
  u.map("p", "e")

  u.map("W", "B")
  u.map("J", "W")
  u.map("Q", "gE")
  u.map("P", "E")

  -- Insert mode
  u.imap("<C-w>", "<C-o>b")
  u.imap("<C-q>", "<Esc>gea")
  u.imap("<C-j>", "<C-o>w")
  u.imap("<C-p>", "<Esc>ea")

  u.imap("<C-a>", "<C-o>B")
  u.imap("<C-o>", "<Esc>gEa")
  u.imap("<C-e>", "<C-o>W")
  u.imap("<C-u>", "<Esc>Ea")

  -- Wordmotion plugin
  vim.g.wordmotion_spaces = "()[]<>{},./%@^!?;:$~`\"\\#_|-+=&*' "
  vim.g.wordmotion_nomap = 1
  addPlugin("chaoren/vim-wordmotion")

  u.map("<M-w>", "<Plug>WordMotion_b")
  u.map("<M-q>", "<Plug>WordMotion_ge")
  u.map("<M-j>", "<Plug>WordMotion_w")
  u.map("<M-p>", "<Plug>WordMotion_e")

  u.imap("<M-w>", "<C-o><Plug>WordMotion_b")
  u.imap("<M-q>", "<Left><C-o><Plug>WordMotion_ge<Right>")
  u.imap("<M-j>", "<C-o><Plug>WordMotion_w")
  u.imap("<M-p>", "<C-o><Plug>WordMotion_e<Right>")
end

local function scroll(addPlugin)
  addPlugin({
    "karb94/neoscroll.nvim",
    config = function()
      -- Save real updatetime restoration.
      local realUpdateTime = vim.go.updatetime

      local neoscroll = require("neoscroll")
      neoscroll.setup({
        mappings = {},
        cursor_scrolls_alone = true,
        easing_function = "quadratic",
        -- Temporary disables CursorHold events
        pre_hook = u.wrap(hacks.delayUpdateTime, 200, realUpdateTime)
      })

      u.map("e", u.wrap(neoscroll.scroll, 0.31, false, 130))
      u.map("u", u.wrap(neoscroll.scroll, -0.31, false, 130))
      u.map("E", u.wrap(neoscroll.scroll, 0.55, false, 150))
      u.map("U", u.wrap(neoscroll.scroll, -0.55, false, 150))
    end
  })
end

local function findCharacter(addPlugin)
  addPlugin("dahu/vim-fanfingtastic")

  -- Saves direction to make a stable next / previous search
  local directionForward = true

  local find = function()
    directionForward = true
    u.feedkeys("<Plug>fanfingtastic_f")
  end

  local findPre = function()
    directionForward = true
    u.feedkeys("<Plug>fanfingtastic_t")
  end

  local findBackward = function()
    directionForward = false
    u.feedkeys("<Plug>fanfingtastic_F")
  end

  local findBackwardPre = function()
    directionForward = false
    u.feedkeys("<Plug>fanfingtastic_T")
  end

  local next = function()
    if directionForward then
      u.feedkeys("<Plug>fanfingtastic_;")
    else
      u.feedkeys("<Plug>fanfingtastic_,")
    end
  end

  local previous = function()
    if directionForward then
      u.feedkeys("<Plug>fanfingtastic_,")
    else
      u.feedkeys("<Plug>fanfingtastic_;")
    end
  end

  -- Forward char
  u.map("k", find)
  u.map("<M-k>", findPre)

  -- Backward char
  u.map("z", findBackward)
  u.map("<M-z>", findBackwardPre)

  -- Between chars
  u.map(")", next)
  u.map("(", previous)

  -- Jump through quotes
  u.map("+", u.wrap(hacks.jumpThrough, "[\"'`]", true))
  u.map("-", u.wrap(hacks.jumpThrough, "[\"'`]", false))

  -- Jump through brackets
  u.map("^", u.wrap(hacks.jumpThrough, "[()]", true))
  u.map("@", u.wrap(hacks.jumpThrough, "[()]", false))
end

local function marks()
  u.map("y", "m")
  u.map("Y", "<C-o>")
  u.map("<C-y>", "<C-t>")
  u.map("i", "`")
  u.map("I", "<C-i>")
end

local function pageMovements()
  u.map("o", "<nop>")

  u.map("oh", "G")
  u.map("ot", "gg")
  u.map("og", "zH")
  u.map("oc", "zL")

  u.map("of", "-ze")
  u.map("od", "^ze")
  u.map("ob", "+ze")

  u.map("or", "-$")
  u.map("on", "$")
  u.map("o.", "+$")
end

local function jumpMotions(addPlugin)
  -- TODO: Use original plugin when fixes and camelCase will be merged.
  addPlugin({
    "backdround/hop.nvim",
    config = function()
      local hop = require("hop")
      local hint = require("hop.hint")

      hop.setup({
        teasing = false
      })

      local hopUpBegin = u.wrap(hop.hint_camel_case, {
        direction = hint.HintDirection.BEFORE_CURSOR,
        hint_position = hint.HintPosition.BEGIN,
      })

      local hopUpEnd = u.wrap(hop.hint_camel_case, {
        direction = hint.HintDirection.BEFORE_CURSOR,
        hint_position = hint.HintPosition.END,
      })

      local hopDownBegin = u.wrap(hop.hint_camel_case, {
        direction = hint.HintDirection.AFTER_CURSOR,
        hint_position = hint.HintPosition.BEGIN,
      })

      local hopDownEnd = u.wrap(hop.hint_camel_case, {
        direction = hint.HintDirection.AFTER_CURSOR,
        hint_position = hint.HintPosition.END,
      })

      local hopChar1Down = u.wrap(hop.hint_char1, {
        direction = hint.HintDirection.AFTER_CURSOR,
      })

      local hopChar1Up = u.wrap(hop.hint_char1, {
        direction = hint.HintDirection.BEFORE_CURSOR,
      })

      u.map("a", u.wrap(hop.hint_camel_case, { current_line_only = true }))

      u.map("ow", hopUpBegin)
      u.map("oq", hopUpEnd)
      u.map("oj", hopDownBegin)
      u.map("op", hopDownEnd)

      u.map("ok", hopChar1Down)
      u.map("oz", hopChar1Up)
    end,
  })
end

local function misc()
  u.nmap("xh", "<C-]>")
  u.nmap("xm", "<Cmd>tab Man<CR>")
end

local function apply(addPlugin)
  wordMotion(addPlugin)
  scroll(addPlugin)
  jumpMotions(addPlugin)
  findCharacter(addPlugin)
  marks()
  pageMovements()
  misc()
end

return {
  apply = apply,
}
