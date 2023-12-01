local u = require("utilities")
local hacks = require("general.hacks")

local function word_motion(plugin_manager)
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
  plugin_manager.add("chaoren/vim-wordmotion")

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

      local jump = function(direction, offset, pattern)
        return function()
          ft.jump({
            direction = direction,
            offset = offset,
            pattern = pattern,
          })
        end
      end

      u.map("p", jump("forward", "none"), "Jump forward to a char")
      u.map("<M-p>", jump("forward", "pre"), "Jump forward to a pre char")
      u.map("<S-p>", jump("forward", "post"), "Jump forward to a post char")

      u.map("w", jump("backward", "none"), "Jump backward to a char")
      u.map("<M-w>", jump("backward", "pre"), "Jump backward to a pre char")
      u.map("<S-w>", jump("backward", "post"), "Jump backward to a post char")

      u.map(")", ft.repeat_forward, "Repeat jump forward to a character")
      u.map("(", ft.repeat_backward, "Repeat jump backward to a character")

      -- Jump through quotes
      local p = "\\v[\"'`]"
      u.map("+", jump("forward", "post", p), "Jump forward post quotes")
      u.map("-", jump("backward", "post", p), "Jump backward post quotes")

      -- Jump through brackets
      p = "\\v([\\][(]|\\)$@!)"
      u.map("&", jump("forward", "post", p), "Jump forward post brackets")
      p = "\\v[\\][()]"
      u.map("=", jump("backward", "post", p), "Jump backward post brackets")

      -- Jump through dot
      p = "\\v\\."
      u.map("<PageUp>", jump("forward", "post", p), "Jump forward post dots")
      u.map("<PageDown>", jump("backward", "post", p), "Jump backward post dots")
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
