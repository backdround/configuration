local u = require("utilities")
local hacks = require("general.hacks")

local function word_motion(add_plugin)
  -- Base mode
  u.map("z", "b", "To the start of the previous word")
  u.map("j", "w", "To the start of the next word")
  u.map("q", "ge", "To the end of the previous word")
  u.map("k", "e", "To the end of the next word")

  u.map("Z", "B", "To the start of the previous full word")
  u.map("J", "W", "To the start of the next full word")
  u.map("Q", "gE", "To the end of the previous full word")
  u.map("K", "E", "To the end of the next full word")

  -- Insert mode
  u.imap("<C-z>", "<C-o>b", "To the start of the previous word")
  u.imap("<C-q>", "<Esc>gea", "To the start of the next word")
  u.imap("<C-j>", "<C-o>w", "To the end of the previous word")
  u.imap("<C-k>", "<Esc>ea", "To the end of the next word")

  u.imap("<C-a>", "<C-o>B", "To the start of the previous full word")
  u.imap("<C-e>", "<C-o>W", "To the start of the next full word")
  u.imap("<C-o>", "<Esc>gEa", "To the end of the previous full word")
  u.imap("<C-u>", "<Esc>Ea", "To the end of the next full word")

  -- Wordmotion plugin
  vim.g.wordmotion_spaces = "()[]<>{},./%@^!?;:$~`\"\\#_|-+=&*' "
  vim.g.wordmotion_nomap = 1
  add_plugin("chaoren/vim-wordmotion")

  u.map("<M-z>", "<Plug>WordMotion_b", "To the start of the previous real word")
  u.map("<M-q>", "<Plug>WordMotion_ge", "To the end of the previous real word")
  u.map("<M-j>", "<Plug>WordMotion_w", "To the start of the next real word")
  u.map("<M-k>", "<Plug>WordMotion_e", "To the end of the next real word")

  local description = "To the start of the previous real word"
  u.imap("<M-z>", "<C-o><Plug>WordMotion_b", description)
  description = "To the start of the next real word"
  u.imap("<M-j>", "<C-o><Plug>WordMotion_w", description)
  description = "To the end of the previous real word"
  u.imap("<M-q>", "<Left><C-o><Plug>WordMotion_ge<Right>", description)
  description = "To the end of the next real word"
  u.imap("<M-k>", "<C-o><Plug>WordMotion_e<Right>", description)
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
  u.map("p", find, { expr = true, desc = desc })
  desc = "Search pre next character operator"
  u.map("<M-p>", find_pre, { expr = true, desc = desc })

  -- Backward char
  desc = "Search previous character operator"
  u.map("w", find_backward, { expr = true, desc = desc })
  desc = "Search pre previous character operator"
  u.map("<M-w>", find_backward_pre, { expr = true, desc = desc })

  -- Between chars
  desc = "Search forward of the last searched character"
  u.map(")", next, { expr = true, desc = desc })
  desc = "Search backward of the last searched character"
  u.map("(", previous, { expr = true, desc = desc })

  local jump_forward_through = hacks.jump_through.forward
  local jump_backward_through = hacks.jump_through.backward

  -- Jump through quotes
  u.map("+", jump_forward_through("[\"'`]"), "Jump forward through quotes")
  u.map("-", jump_backward_through("[\"'`]"), "Jump backward through quotes")

  -- Jump through brackets
  u.map("&", jump_forward_through("[()]"), "Jump forward through brackets")
  u.map("=", jump_backward_through("[()]"), "Jump backward through brackets")

  -- Jump through dot
  u.map("<End>", jump_forward_through("\\."), "Jump forward through dots")
  u.map("<PageUp>", jump_backward_through("\\."), "Jump backward through dots")
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

  local function map_line_jump(map, line_mode, column_mode, before_symbol)
    local symbol_description
    if column_mode == "first" and not before_symbol then
      symbol_description = "the first symbol"
    elseif column_mode == "first" and before_symbol then
      symbol_description = "the second symbol"
    elseif column_mode == "last" and not before_symbol then
      symbol_description = "the last symbol"
    elseif column_mode == "last" and before_symbol then
      symbol_description = "the second to last symbol"
    end

    local line_description
    if line_mode == "backward" then
      line_description = "a previous line"
    elseif line_mode == "current" then
      line_description = "the current line"
    elseif line_mode == "forward" then
      line_description = "a next line"
    end
    local description = "Jump to "
      .. symbol_description
      .. " of "
      .. line_description

    local line_jump = hacks.jump_to_line
    u.map(map, line_jump(line_mode, column_mode, before_symbol), description)
  end

  map_line_jump("of", "backward", "first", false)
  map_line_jump("o<M-f>", "backward", "first", true)
  map_line_jump("or", "backward", "last", false)
  map_line_jump("o<M-r>", "backward", "last", true)
  map_line_jump("od", "current", "first", false)
  map_line_jump("o<M-d>", "current", "first", true)
  map_line_jump("on", "current", "last", false)
  map_line_jump("o<M-n>", "current", "last", true)
  map_line_jump("ob", "forward", "first", false)
  map_line_jump("o<M-b>", "forward", "first", true)
  map_line_jump("o.", "forward", "last", false)
  map_line_jump("o<M-.>", "forward", "last", true)
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

      local hop_line = u.wrap(hop.hint_camel_case, {
        current_line_only = true,
        hint_position = {
          hint.HintPosition.BEGIN,
          hint.HintPosition.END,
        },
      })

      u.map("a", hop_line, "Hop jump in current line")
    end,
  })

  add_plugin({
    "woosaaahh/sj.nvim",
    config = function()
      local sj = require("sj")
      sj.setup({
        prompt_prefix = "/",
        pattern_type = "lua_plain",
        separator = "",
        stop_on_fail = false,
        keymaps = {
          cancel = "<M-s>",
          validate = "<M-o>",
        },
      })
      u.map("<space>", sj.run, "Jump to any string")
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
