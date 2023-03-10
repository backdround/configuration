local u = require("utilities")
local hacks = require("general.hacks")

local function wordMotion(addPlugin)
  -- Base mode
  u.map("w", "b", "To the start of the previous word")
  u.map("j", "w", "To the start of the next word")
  u.map("q", "ge", "To the end of the previous word")
  u.map("p", "e", "To the end of the next word")

  u.map("W", "B", "To the start of the previous full word")
  u.map("J", "W", "To the start of the next full word")
  u.map("Q", "gE", "To the end of the previous full word")
  u.map("P", "E", "To the end of the next full word")

  -- Insert mode
  u.imap("<C-w>", "<C-o>b", "To the start of the previous word")
  u.imap("<C-q>", "<Esc>gea", "To the start of the next word")
  u.imap("<C-j>", "<C-o>w", "To the end of the previous word")
  u.imap("<C-p>", "<Esc>ea", "To the end of the next word")

  u.imap("<C-a>", "<C-o>B", "To the start of the previous full word")
  u.imap("<C-e>", "<C-o>W", "To the start of the next full word")
  u.imap("<C-o>", "<Esc>gEa", "To the end of the previous full word")
  u.imap("<C-u>", "<Esc>Ea", "To the end of the next full word")

  -- Wordmotion plugin
  vim.g.wordmotion_spaces = "()[]<>{},./%@^!?;:$~`\"\\#_|-+=&*' "
  vim.g.wordmotion_nomap = 1
  addPlugin("chaoren/vim-wordmotion")

  u.map("<M-w>", "<Plug>WordMotion_b", "To the start of the previous real word")
  u.map("<M-q>", "<Plug>WordMotion_ge", "To the end of the previous real word")
  u.map("<M-j>", "<Plug>WordMotion_w", "To the start of the next real word")
  u.map("<M-p>", "<Plug>WordMotion_e", "To the end of the next real word")

  local description = "To the start of the previous real word"
  u.imap("<M-w>", "<C-o><Plug>WordMotion_b", description)
  description = "To the start of the next real word"
  u.imap("<M-j>", "<C-o><Plug>WordMotion_w", description)
  description = "To the end of the previous real word"
  u.imap("<M-q>", "<Left><C-o><Plug>WordMotion_ge<Right>", description)
  description = "To the end of the next real word"
  u.imap("<M-p>", "<C-o><Plug>WordMotion_e<Right>", description)
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
        pre_hook = u.wrap(hacks.delayUpdateTime, 200, realUpdateTime),
      })

      u.map("e", u.wrap(neoscroll.scroll, 0.31, false, 130), "Scroll down")
      u.map("u", u.wrap(neoscroll.scroll, -0.31, false, 130), "Scroll up")
      u.map("E", u.wrap(neoscroll.scroll, 0.55, false, 150), "Fast scroll down")
      u.map("U", u.wrap(neoscroll.scroll, -0.55, false, 150), "Fast scroll up")
    end,
  })
end

local function findCharacter(addPlugin)
  addPlugin("dahu/vim-fanfingtastic")

  -- Disables fanfingtastic default mappings
  for _, key in ipairs({ "f", "F", "t", "T", ";", "," }) do
    u.mapStab({ "n", "x", "o" }, { "<Plug>fanfingtastic_" .. key })
  end

  -- Saves direction to make a stable next / previous search
  local directionForward = true

  local find = function()
    directionForward = true
    return "<Plug>fanfingtastic_f"
  end

  local findPre = function()
    directionForward = true
    return "<Plug>fanfingtastic_t"
  end

  local findBackward = function()
    directionForward = false
    return "<Plug>fanfingtastic_F"
  end

  local findBackwardPre = function()
    directionForward = false
    return "<Plug>fanfingtastic_T"
  end

  local next = function()
    if directionForward then
      return "<Plug>fanfingtastic_;"
    else
      return "<Plug>fanfingtastic_,"
    end
  end

  local previous = function()
    if directionForward then
      return "<Plug>fanfingtastic_,"
    else
      return "<Plug>fanfingtastic_;"
    end
  end

  -- Forward char
  local desc = "Search next character operator"
  u.map("k", find, { expr = true, desc = desc })
  desc = "Search pre next character operator"
  u.map("<M-k>", findPre, { expr = true, desc = desc })

  -- Backward char
  desc = "Search previous character operator"
  u.map("z", findBackward, { expr = true, desc = desc })
  desc = "Search pre previous character operator"
  u.map("<M-z>", findBackwardPre, { expr = true, desc = desc })

  -- Between chars
  desc = "Search forward of the last searched character"
  u.map(")", next, { expr = true, desc = desc })
  desc = "Search backward of the last searched character"
  u.map("(", previous, { expr = true, desc = desc })

  -- Gives jump through map for operator-pending mode.
  -- If you use just jumpThrough function, then dot-repeat doesn't work.
  local function getOperatorValidJumpThroughMap(pattern, forward)
    pattern = pattern:gsub('"', '\\"')
    forward = tostring(forward)
    return vim.fn.printf(
      ':lua require("general.hacks").jumpThrough("%s", %s)<CR>',
      pattern,
      forward
    )
  end

  -- Jump through quotes
  desc = "Jump forward through quotes"
  u.nmap("+", u.wrap(hacks.jumpThrough, "[\"'`]", true), desc)
  u.xmap("+", u.wrap(hacks.jumpThrough, "[\"'`]", true), desc)
  u.omap("+", getOperatorValidJumpThroughMap("[\"'`]", true), desc)

  desc = "Jump backward through quotes"
  u.nmap("-", u.wrap(hacks.jumpThrough, "[\"'`]", false), desc)
  u.xmap("-", u.wrap(hacks.jumpThrough, "[\"'`]", false), desc)
  u.omap("-", getOperatorValidJumpThroughMap("[\"'`]", false), desc)

  -- Jump through brackets
  desc = "Jump forward through brackets"
  u.nmap("&", u.wrap(hacks.jumpThrough, "[()]", true), desc)
  u.xmap("&", u.wrap(hacks.jumpThrough, "[()]", true), desc)
  u.omap("&", getOperatorValidJumpThroughMap("[()]", true), desc)

  desc = "Jump backward through brackets"
  u.nmap("=", u.wrap(hacks.jumpThrough, "[()]", false), desc)
  u.xmap("=", u.wrap(hacks.jumpThrough, "[()]", false), desc)
  u.omap("=", getOperatorValidJumpThroughMap("[()]", false), desc)
end

local function marks()
  u.map("y", "m", "Set a mark")
  u.map("i", "`", "Jump to a mark")
  u.map("Y", "<C-o>", "Jump backward in jump list")
  u.map("I", "<C-i>", "Jump forward in jump list")
  u.map("<C-y>", "<C-t>", "Jump backward in tag list")
end

local function pageMovements()
  u.map("o", "<nop>", "Movement key")

  u.map("oh", "G", "Go to the end of the buffer")
  u.map("ot", "gg", "Go to the start of the buffer")
  u.map("og", "zH", "Move viewport left")
  u.map("oc", "zL", "Move viewport right")

  u.map("of", "-ze", "Jump to the start of the previous line")
  u.map("od", "^ze", "Jump to the start of the current line")
  u.map("ob", "+ze", "Jump to the start of the next line")

  u.map("or", "-$", "Jump to the end of the previous line")
  u.map("on", "$", "Jump to the end of the current line")
  u.map("o.", "+$", "Jump to the end of the next line")
end

local function jumpMotions(addPlugin)
  -- TODO: Use original plugin when all things will be exist:
  -- - You can jump from empty line (without error, lol).
  -- - camelCase will be available.
  -- - multiply position will be available (begin and end at the same time).
  addPlugin({
    "backdround/hop.nvim",
    config = function()
      local hop = require("hop")
      local hint = require("hop.hint")

      hop.setup({
        teasing = false,
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

      local hopLine = u.wrap(hop.hint_camel_case, {
        current_line_only = true,
        hint_position = {
          hint.HintPosition.BEGIN,
          hint.HintPosition.END,
        },
      })

      local description = "Hop jump in current line"
      u.map("a", hopLine, description)

      description = "Hop jump to the start of words before the cursor"
      u.map("ow", hopUpBegin, description)
      description = "Hop jump to the end of words before the cursor"
      u.map("oq", hopUpEnd, description)
      description = "Hop jump to the start of words after the cursor"
      u.map("oj", hopDownBegin, description)
      description = "Hop jump to the end of words after the cursor"
      u.map("op", hopDownEnd, description)

      description = "Hop jump to the character after the cursor"
      u.map("ok", hopChar1Down, description)
      description = "Hop jump to the character before the cursor"
      u.map("oz", hopChar1Up, description)
    end,
  })
end

local function misc()
  u.nmap("xh", "<C-]>", "Goto definition (non lsp)")
  u.nmap("xm", "<Cmd>tab Man<CR>", "Search man page with name under the cursor")
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
