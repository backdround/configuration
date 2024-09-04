local u = require("utilities")
local hacks = require("general.hacks")

local function word_motion(plugin_manager)
  local word_hop_kinds = {
    ["big word"] = {
      patterns = { "\\v[^[:blank:]]+" },
      normal_keys = { "Z", "Q", "J", "K" },
      insert_keys = { "<C-Z>", "<C-Q>", "<C-J>", "<C-K>" },
    },

    ["full word"] = {
      preset_patterns = { "any_word" },
      normal_keys = { "z", "q", "j", "k" },
      insert_keys = { "<M-z>", "<M-q>", "<M-j>", "<M-k>" },
    },

    ["sub word"] = {
      preset_patterns = {
        "snake_case",
        "camel_case",
        "upper_case",
      },
      normal_keys = { "<F21>", "<F22>", "<F23>", "<F24>" },
      insert_keys = { "<F21>", "<F22>", "<F23>", "<F24>" },
    },

    ["number / hex color"] = {
      preset_patterns = { "number", "hex_color" },
      normal_keys = { "<F17>", "<F18>", "<F19>", "<F20>" },
      insert_keys = { "<F17>", "<F18>", "<F19>", "<F20>" },
    },
  }

  local loading_normal_keys = {}
  local loading_insert_keys = {}

  for _, kind in pairs(word_hop_kinds) do
    loading_normal_keys = u.array_extend(loading_normal_keys, kind.normal_keys)
    loading_insert_keys = u.array_extend(loading_insert_keys, kind.insert_keys)
  end

  plugin_manager.add({
    url = "git@github.com:backdround/neowords.nvim.git",
    keys = u.array_extend(
      hacks.lazy.generate_keys("nxo", loading_normal_keys),
      hacks.lazy.generate_keys("i", loading_insert_keys)
    ),
    config = function()
      local neowords = require("neowords")

      -- Convert preset_patterns into patterns
      for _, kind in pairs(word_hop_kinds) do
        if kind.preset_patterns ~= nil then
          kind.patterns = kind.patterns or {}

          for _, name in ipairs(kind.preset_patterns) do
            local pattern = neowords.pattern_presets[name]
            table.insert(kind.patterns, pattern)
          end

          kind.preset_patterns = nil
        end
      end

      local map_word_hop_kind = function(name, kind)
        local hops = neowords.get_word_hops(unpack(kind.patterns))

        local description = "Hop to the start of the previous " .. name
        u.map(kind.normal_keys[1], hops.backward_start, description)
        u.imap(kind.insert_keys[1], hops.backward_start, description)

        description = "Hop to the end of the previous " .. name
        u.map(kind.normal_keys[2], hops.backward_end, description)
        u.imap(kind.insert_keys[2], hops.backward_end, description)

        description = "Hop to the start of the next " .. name
        u.map(kind.normal_keys[3], hops.forward_start, description)
        u.imap(kind.insert_keys[3], hops.forward_start, description)

        description = "Hop to the end of the next " .. name
        u.map(kind.normal_keys[4], hops.forward_end, description)
        u.imap(kind.insert_keys[4], hops.forward_end, description)
      end

      for name, kind in pairs(word_hop_kinds) do
        map_word_hop_kind(name, kind)
      end
    end,
  })
end

local function scroll(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/karb94/neoscroll.nvim",
    keys = hacks.lazy.generate_keys("nxo", { "e", "u", "E", "U" }),
    config = function()

      local illuminate_do = function(action)
        local status, module  = pcall(require, "illuminate")
        if status then
          module[action]()
        end
      end

      local illuminate_pauser = u.new_debouncer(
        u.wrap(illuminate_do, "pause_buf"),
        u.wrap(illuminate_do, "resume_buf"),
        350
      )

      local neoscroll = require("neoscroll")
      neoscroll.setup({
        mappings = {},
        cursor_scrolls_alone = true,
        easing_function = "quadratic",
        pre_hook = illuminate_pauser.run,
      })

      u.map("e", u.wrap(neoscroll.scroll, 0.31, false, 105), "Scroll down")
      u.map("u", u.wrap(neoscroll.scroll, -0.31, false, 105), "Scroll up")
      u.map("E", u.wrap(neoscroll.scroll, 0.55, false, 140), "Fast scroll down")
      u.map("U", u.wrap(neoscroll.scroll, -0.55, false, 140), "Fast scroll up")
    end,
  })
end

local function improved_ft(plugin_manager)
  local loading_normal_keys =
    { "p", "<M-p>", "<S-p>", "w", "<M-w>", "<S-w>", "(", ")" }
  local loading_insert_keys = { "<M-p>", "<M-w>", "<M-u>", "<M-e>" }

  plugin_manager.add({
    url = "git@github.com:backdround/improved-ft.nvim.git",
    keys = u.array_extend(
      hacks.lazy.generate_keys("nxo", loading_normal_keys),
      hacks.lazy.generate_keys("i", loading_insert_keys)
    ),
    config = function()
      local ft = require("improved-ft")

      local map = function(key, fn, description)
        u.map(key, fn, { desc = description, expr = true })
      end

      local imap = function(key, fn, description)
        u.imap(key, fn, { desc = description, expr = true })
      end

      map("p", ft.hop_forward_to_char, "Hop forward to a char")
      map("<M-p>", ft.hop_forward_to_pre_char, "Hop forward to a pre char")
      map("<S-p>", ft.hop_forward_to_post_char, "Hop forward to a post char")

      map("w", ft.hop_backward_to_char, "Hop backward to a char")
      map("<M-w>", ft.hop_backward_to_pre_char, "Hop backward to a pre char")
      map("<S-w>", ft.hop_backward_to_post_char, "Hop backward to a post char")

      map(")", ft.repeat_forward, "Repeat hop forward to a character")
      map("(", ft.repeat_backward, "Repeat hop backward to a character")

      -- Insert mode
      imap("<M-p>", ft.hop_forward_to_char, "Hop forward to a char")
      imap("<M-w>", ft.hop_backward_to_char, "Hop backward to a char")

      imap("<M-u>", ft.repeat_forward, "Repeat hop forward to a character")
      imap("<M-e>", ft.repeat_backward, "Repeat hop backward to a character")
    end,
  })
end

local function rabbit_hop(plugin_manager)
  plugin_manager.add({
    url = "git@github.com:backdround/rabbit-hop.nvim.git",
    config = function()
      local rh = require("rabbit-hop")

      local map_hop = function(key, direction, offset, pattern, pattern_class)
        -- Get key
        local key_pattern = "<C-S-M-%s>"
        if key:sub(1, 1) == "F" then
          key_pattern = "<%s>"
        end
        key = key_pattern:format(key)

        -- Get description
        local description = "Hop " .. direction .. "to "
        if offset == -1 then
          description = description .. "the left of"
        elseif offset == 1 then
          description = description .. "the right of"
        end
        description = description .. pattern_class

        -- Insert map
        local target_side = direction == "forward" and "left" or "right"
        if offset ~= 0 then
          target_side = offset >= 1 and "right" or "left"
        end

        local hop = u.wrap(rh.hop, {
          pattern = pattern,
          direction = direction,
          offset = 0,
          insert_mode_target_side = target_side
        })

        u.imap(key, hop, description)

        -- Ordinary map
        if offset == 1 then
          -- Ignore patterns that are the last symbols on a line.
          pattern = pattern .. "\\v$@!"
        elseif offset == -1 then
          -- Ignore patterns that are the first symbols on a line.
          pattern = "\\v^@!" .. pattern
        end

        hop = u.wrap(rh.hop, {
          pattern = pattern,
          direction = direction,
          offset = offset,
        })

        u.map(key, hop, description)
      end

      -- Jump between equals
      local p = "\\M="
      map_hop("F25", "backward", 0, p, "equals")
      map_hop("F26", "forward", 0, p, "equals")

      map_hop("w", "backward", -1, p, "equals")
      map_hop("v", "forward", -1, p, "equals")

      map_hop("f", "backward", 1, p, "equals")
      map_hop("g", "forward", 1, p, "equals")

      -- Jump between quotes
      p = "\\v[\"'`]"
      map_hop("F27", "backward", 0, p, "quotes")
      map_hop("F28", "forward", 0, p, "quotes")

      map_hop("s", "backward", -1, p, "quotes")
      map_hop("p", "forward", -1, p, "quotes")

      map_hop("c", "backward", 1, p, "quotes")
      map_hop("r", "forward", 1, p, "quotes")

      -- Jump between commas
      p = "\\M,"
      map_hop("F29", "backward", 0, p, "commas")
      map_hop("F30", "forward", 0, p, "commas")

      map_hop("a", "backward", -1, p, "commas")
      map_hop("o", "forward", -1, p, "commas")

      map_hop("d", "backward", 1, p, "commas")
      map_hop("h", "forward", 1, p, "commas")

      -- Jump between () / [] brackets
      p = "\\v[\\][()]"
      map_hop("F31", "backward", 0, p, "() / [] brackets")
      map_hop("F32", "forward", 0, p, "() / [] brackets")

      map_hop("e", "backward", -1, p, "() / [] brackets")
      map_hop("u", "forward", -1, p, "() / [] brackets")

      map_hop("t", "backward", 1, p, "() / [] brackets")
      map_hop("n", "forward", 1, p, "() / [] brackets")

      -- Jump between dots
      p = "\\M."
      map_hop("F33", "backward", 0, p, "dots")
      map_hop("F34", "forward", 0, p, "dots")

      map_hop("x", "backward", -1, p, "dots")
      map_hop("q", "forward", -1, p, "dots")

      map_hop("l", "backward", 1, p, "dots")
      map_hop("b", "forward", 1, p, "dots")

      -- Jump between {} curly brackets
      p = "\\v[{}]"
      map_hop("F35", "backward", 0, p, "{} curly brackets")
      map_hop("F36", "forward", 0, p, "{} curly brackets")

      map_hop("j", "backward", -1, p, "{} curly brackets")
      map_hop("k", "forward", -1, p, "{} curly brackets")

      map_hop("y", "backward", 1, p, "{} curly brackets")
      map_hop("m", "forward", 1, p, "{} curly brackets")

      -- Jumps between lines
      local to_line = hacks.jump_to_line(rh.hop)
      u.map("of", to_line.upward_left, "Jump to the start of an upward line")
      u.map("or", to_line.upward_right, "Jump to the end of an upward line")
      u.map("od", to_line.left, "Jump to the start of the current line")
      u.map("on", to_line.right, "Jump to the end of the current line")
      u.map("ob", to_line.downward_left, "Jump to the start of a downward line")
      u.map("o.", to_line.downward_right, "Jump to the end of a downward line")
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
end

local function jump_motions(plugin_manager)
  -- TODO: Use original plugin when all things will exist:
  -- - You can jump from empty line (without error, lol).
  -- - camelCase will be available.
  -- - multiply position will be available (begin and end at the same time).
  plugin_manager.add({
    url = "https://github.com/backdround/hop.nvim",
    keys = hacks.lazy.generate_keys("nxo", { "a" }),
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
    keys = hacks.lazy.generate_keys("nxo", { "<space>" }),
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
      u.map("<space>", sj.run, "Jump interactively to anywhere")
    end,
  })
end

local function misc()
  u.nmap("xh", "<C-]>", "Goto definition (non lsp)")
  u.nmap("xm", "<Cmd>tab Man<CR>", "Search man page with name under the cursor")
  -- TODO: create motions between foldings
end

---@param plugin_manager UserPluginManager
local function apply(plugin_manager)
  word_motion(plugin_manager)
  scroll(plugin_manager)
  jump_motions(plugin_manager)
  improved_ft(plugin_manager)
  rabbit_hop(plugin_manager)
  marks()
  page_movements()
  misc()
end

return {
  apply = apply,
}
