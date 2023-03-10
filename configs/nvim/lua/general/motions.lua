local u = require("utilities")
local hacks = require("general.hacks")

local function word_motion(add_plugin)
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
  add_plugin("chaoren/vim-wordmotion")

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

local function scroll(add_plugin)
  add_plugin({
    "karb94/neoscroll.nvim",
    config = function()
      -- Save real updatetime restoration.
      local real_update_time = vim.go.updatetime

      local neoscroll = require("neoscroll")
      neoscroll.setup({
        mappings = {},
        cursor_scrolls_alone = true,
        easing_function = "quadratic",
        -- Temporary disables CursorHold events
        pre_hook = u.wrap(hacks.delay_update_time, 200, real_update_time),
      })

      u.map("e", u.wrap(neoscroll.scroll, 0.31, false, 130), "Scroll down")
      u.map("u", u.wrap(neoscroll.scroll, -0.31, false, 130), "Scroll up")
      u.map("E", u.wrap(neoscroll.scroll, 0.55, false, 150), "Fast scroll down")
      u.map("U", u.wrap(neoscroll.scroll, -0.55, false, 150), "Fast scroll up")
    end,
  })
end

local function find_character(add_plugin)
  add_plugin("dahu/vim-fanfingtastic")

  -- Disables fanfingtastic default mappings
  for _, key in ipairs({ "f", "F", "t", "T", ";", "," }) do
    u.map_stab({ "n", "x", "o" }, { "<Plug>fanfingtastic_" .. key })
  end

  -- Saves direction to make a stable next / previous search
  local direction_forward = true

  local find = function()
    direction_forward = true
    return "<Plug>fanfingtastic_f"
  end

  local find_pre = function()
    direction_forward = true
    return "<Plug>fanfingtastic_t"
  end

  local find_backward = function()
    direction_forward = false
    return "<Plug>fanfingtastic_F"
  end

  local find_backward_pre = function()
    direction_forward = false
    return "<Plug>fanfingtastic_T"
  end

  local next = function()
    if direction_forward then
      return "<Plug>fanfingtastic_;"
    else
      return "<Plug>fanfingtastic_,"
    end
  end

  local previous = function()
    if direction_forward then
      return "<Plug>fanfingtastic_,"
    else
      return "<Plug>fanfingtastic_;"
    end
  end

  -- Forward char
  local desc = "Search next character operator"
  u.map("k", find, { expr = true, desc = desc })
  desc = "Search pre next character operator"
  u.map("<M-k>", find_pre, { expr = true, desc = desc })

  -- Backward char
  desc = "Search previous character operator"
  u.map("z", find_backward, { expr = true, desc = desc })
  desc = "Search pre previous character operator"
  u.map("<M-z>", find_backward_pre, { expr = true, desc = desc })

  -- Between chars
  desc = "Search forward of the last searched character"
  u.map(")", next, { expr = true, desc = desc })
  desc = "Search backward of the last searched character"
  u.map("(", previous, { expr = true, desc = desc })

  -- Gives jump through map for operator-pending mode.
  -- If you use just jump_through function, then dot-repeat doesn't work.
  local function get_operator_valid_jump_through_map(pattern, forward)
    pattern = pattern:gsub('"', '\\"')
    forward = tostring(forward)
    return vim.fn.printf(
      ':lua require("general.hacks").jump_through("%s", %s)<CR>',
      pattern,
      forward
    )
  end

  -- Jump through quotes
  desc = "Jump forward through quotes"
  u.nmap("+", u.wrap(hacks.jump_through, "[\"'`]", true), desc)
  u.xmap("+", u.wrap(hacks.jump_through, "[\"'`]", true), desc)
  u.omap("+", get_operator_valid_jump_through_map("[\"'`]", true), desc)

  desc = "Jump backward through quotes"
  u.nmap("-", u.wrap(hacks.jump_through, "[\"'`]", false), desc)
  u.xmap("-", u.wrap(hacks.jump_through, "[\"'`]", false), desc)
  u.omap("-", get_operator_valid_jump_through_map("[\"'`]", false), desc)

  -- Jump through brackets
  desc = "Jump forward through brackets"
  u.nmap("&", u.wrap(hacks.jump_through, "[()]", true), desc)
  u.xmap("&", u.wrap(hacks.jump_through, "[()]", true), desc)
  u.omap("&", get_operator_valid_jump_through_map("[()]", true), desc)

  desc = "Jump backward through brackets"
  u.nmap("=", u.wrap(hacks.jump_through, "[()]", false), desc)
  u.xmap("=", u.wrap(hacks.jump_through, "[()]", false), desc)
  u.omap("=", get_operator_valid_jump_through_map("[()]", false), desc)
end

local function marks()
  u.map("y", "m", "Set a mark")
  u.map("i", "`", "Jump to a mark")
  u.map("Y", "<C-o>", "Jump backward in jump list")
  u.map("I", "<C-i>", "Jump forward in jump list")
  u.map("<C-y>", "<C-t>", "Jump backward in tag list")
end

local function page_movements()
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

local function jump_motions(add_plugin)
  -- TODO: Use original plugin when all things will be exist:
  -- - You can jump from empty line (without error, lol).
  -- - camelCase will be available.
  -- - multiply position will be available (begin and end at the same time).
  add_plugin({
    "backdround/hop.nvim",
    config = function()
      local hop = require("hop")
      local hint = require("hop.hint")

      hop.setup({
        teasing = false,
      })

      local hop_up_begin = u.wrap(hop.hint_camel_case, {
        direction = hint.HintDirection.BEFORE_CURSOR,
        hint_position = hint.HintPosition.BEGIN,
      })

      local hop_up_end = u.wrap(hop.hint_camel_case, {
        direction = hint.HintDirection.BEFORE_CURSOR,
        hint_position = hint.HintPosition.END,
      })

      local hop_down_begin = u.wrap(hop.hint_camel_case, {
        direction = hint.HintDirection.AFTER_CURSOR,
        hint_position = hint.HintPosition.BEGIN,
      })

      local hop_down_end = u.wrap(hop.hint_camel_case, {
        direction = hint.HintDirection.AFTER_CURSOR,
        hint_position = hint.HintPosition.END,
      })

      local hop_char1Down = u.wrap(hop.hint_char1, {
        direction = hint.HintDirection.AFTER_CURSOR,
      })

      local hop_char1Up = u.wrap(hop.hint_char1, {
        direction = hint.HintDirection.BEFORE_CURSOR,
      })

      local hop_line = u.wrap(hop.hint_camel_case, {
        current_line_only = true,
        hint_position = {
          hint.HintPosition.BEGIN,
          hint.HintPosition.END,
        },
      })

      local description = "Hop jump in current line"
      u.map("a", hop_line, description)

      description = "Hop jump to the start of words before the cursor"
      u.map("ow", hop_up_begin, description)
      description = "Hop jump to the end of words before the cursor"
      u.map("oq", hop_up_end, description)
      description = "Hop jump to the start of words after the cursor"
      u.map("oj", hop_down_begin, description)
      description = "Hop jump to the end of words after the cursor"
      u.map("op", hop_down_end, description)

      description = "Hop jump to the character after the cursor"
      u.map("ok", hop_char1Down, description)
      description = "Hop jump to the character before the cursor"
      u.map("oz", hop_char1Up, description)
    end,
  })
end

local function misc()
  u.nmap("xh", "<C-]>", "Goto definition (non lsp)")
  u.nmap("xm", "<Cmd>tab Man<CR>", "Search man page with name under the cursor")
end

local function apply(add_plugin)
  word_motion(add_plugin)
  scroll(add_plugin)
  jump_motions(add_plugin)
  find_character(add_plugin)
  marks()
  page_movements()
  misc()
end

return {
  apply = apply,
}
