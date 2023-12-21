local u = require("utilities")
local hacks = require("general.hacks")

local function word_motion(plugin_manager)
  u.map("Z", "B", "To the start of the previous full word")
  u.map("J", "W", "To the start of the next full word")
  u.map("Q", "gE", "To the end of the previous full word")
  u.map("K", "E", "To the end of the next full word")

  u.imap("<C-z>", "<C-o>B", "To the start of the previous full word")
  u.imap("<C-j>", "<C-o>W", "To the start of the next full word")
  u.imap("<C-q>", "<Esc>gEa", "To the end of the previous full word")
  u.imap("<C-k>", "<Esc>Ea", "To the end of the next full word")

  plugin_manager.add({
    url = "git@github.com:backdround/neowords.nvim.git",
    config = function()

      local nw = require("neowords")
      local pp = nw.pattern_presets

      -- Big words
      local bigword_hops = nw.get_word_hops(pp.any_word, pp.number, pp.hex_color)

      local description = "Hop to the start of the previous big word"
      u.map("z", bigword_hops.backward_start, description)
      u.imap("<M-z>", bigword_hops.backward_start, description)
      description = "Hop to the end of the previous big word"
      u.map("q", bigword_hops.backward_end, description)
      u.imap("<M-q>", bigword_hops.backward_end, description)
      description = "Hop to the start of the next big word"
      u.map("j", bigword_hops.forward_start, description)
      u.imap("<M-j>", bigword_hops.forward_start, description)
      description = "Hop to the end of the next big word"
      u.map("k", bigword_hops.forward_end, description)
      u.imap("<M-k>", bigword_hops.forward_end, description)

      -- Sub words
      local subword_hops = nw.get_word_hops(
        pp.sneak_case,
        pp.camel_case,
        pp.upper_case,
        pp.number,
        pp.hex_color
      )

      description = "To the start of the previous real word"
      u.map("<F21>", subword_hops.backward_start, description)
      u.imap("<F21>", subword_hops.backward_start, description)
      description = "To the end of the previous real word"
      u.map("<F22>", subword_hops.backward_end, description)
      u.imap("<F22>", subword_hops.backward_end, description)
      description = "To the start of the next real word"
      u.map("<F23>", subword_hops.forward_start, description)
      u.imap("<F23>", subword_hops.forward_start, description)
      description = "To the end of the next real word"
      u.map("<F24>", subword_hops.forward_end, description)
      u.imap("<F24>", subword_hops.forward_end, description)

      -- Number words
      local number_hops = nw.get_word_hops(pp.number, pp.hex_color)

      description = "Hop to the start of the previous number"
      u.map("<F17>", number_hops.backward_start, description)
      u.imap("<F17>", number_hops.backward_start, description)
      description = "Hop to the start of the next number"
      u.map("<F18>", number_hops.forward_start, description)
      u.imap("<F18>", number_hops.forward_start, description)

      -- Non word symbols
      local nonword_hops = nw.get_word_hops("\\v[^[:alnum:][:blank:]_]")

      description = "To the start of a previous non word symbol"
      u.map("<F19>", nonword_hops.backward_start, description)
      u.imap("<F19>", nonword_hops.backward_start, description)
      description = "To the start of the next non word symbol"
      u.map("<F20>", nonword_hops.forward_start, description)
      u.imap("<F20>", nonword_hops.forward_start, description)
    end
  })
end

local function scroll(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/karb94/neoscroll.nvim",
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

local function jump_between_characters(plugin_manager)
  plugin_manager.add({
    url = "git@github.com:backdround/improved-ft.nvim.git",
    config = function()
      local ft = require("improved-ft")

      u.map("p", ft.hop_forward_to_char, "Hop forward to a char")
      u.map("<M-p>", ft.hop_forward_to_pre_char, "Hop forward to a pre char")
      u.map("<S-p>", ft.hop_forward_to_post_char, "Hop forward to a post char")

      u.map("w", ft.hop_backward_to_char, "Hop backward to a char")
      u.map("<M-w>", ft.hop_backward_to_pre_char, "Hop backward to a pre char")
      u.map("<S-w>", ft.hop_backward_to_post_char, "Hop backward to a post char")

      u.map(")", ft.repeat_forward, "Repeat hop forward to a character")
      u.map("(", ft.repeat_backward, "Repeat hop backward to a character")

      -- Insert mode
      u.imap("<M-p>", ft.hop_forward_to_char, "Hop forward to a char")
      u.imap("<M-w>", ft.hop_backward_to_char, "Hop backward to a char")

      u.imap("<M-u>", ft.repeat_forward, "Repeat hop forward to a character")
      u.imap("<M-e>", ft.repeat_backward, "Repeat hop backward to a character")
    end,
  })

  plugin_manager.add({
    url = "git@github.com:backdround/rabbit-hop.nvim.git",
    config = function()
      local rh = require("rabbit-hop")

      local hop_forward_through = function(pattern)
        return function()
          rh.hop({
            direction = "forward",
            offset = "post",
            insert_mode_target_side = "left",
            pattern = pattern
          })
        end
      end

      local hop_backward_through = function(pattern)
        return function()
          rh.hop({
            direction = "backward",
            offset = "post",
            insert_mode_target_side = "right",
            pattern = pattern
          })
        end
      end

      -- Jump through quotes
      local p = "\\v[\"'`]"
      u.map("<F13>", hop_backward_through(p), "Jump backward post quotes")
      u.imap("<F13>", hop_backward_through(p), "Jump backward post quotes")
      u.map("<F14>", hop_forward_through(p), "Jump forward post quotes")
      u.imap("<F14>", hop_forward_through(p), "Jump forward post quotes")

      -- Jump through brackets
      p = "\\v[\\][()]"
      u.map("<F15>", hop_backward_through(p), "Jump backward post brackets")
      u.imap("<F15>", hop_backward_through(p), "Jump backward post brackets")
      p = "\\v([\\][(]|\\)$@!)"
      u.map("<F16>", hop_forward_through(p), "Jump forward post brackets")
      u.imap("<F16>", hop_forward_through(p), "Jump forward post brackets")
    end,
  })
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

local function jump_motions(plugin_manager)
  -- TODO: Use original plugin when all things will be exist:
  -- - You can jump from empty line (without error, lol).
  -- - camelCase will be available.
  -- - multiply position will be available (begin and end at the same time).
  plugin_manager.add({
    url = "https://github.com/backdround/hop.nvim",
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

  plugin_manager.add({
    url = "https://github.com/woosaaahh/sj.nvim",
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

---@param plugin_manager UserPluginManager
local function apply(plugin_manager)
  word_motion(plugin_manager)
  scroll(plugin_manager)
  jump_motions(plugin_manager)
  jump_between_characters(plugin_manager)
  marks()
  page_movements()
  misc()
end

return {
  apply = apply,
}
