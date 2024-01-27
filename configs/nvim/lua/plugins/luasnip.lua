local u = require("utilities")

-- TODO: track the annoying bug:
-- https://github.com/hrsh7th/nvim-cmp/issues/1743
local function configure()
  local ls = require("luasnip")
  ls.setup({
    history = false,
    region_check_events = { "CursorHold" },
    delete_check_events = { "CursorHold" },
    update_events = { "TextChanged", "TextChangedI" },
    enable_autosnippets = true,
    snip_env = {
      array_extend = u.array_extend,
      notify = u.notify,
    },
  })

  local lua_snip_loader = require("luasnip.loaders.from_lua")
  lua_snip_loader.load({ paths = { "./snippets" } })

  u.adapted_map("is", "<M-t>", function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end, "Expand snippet or jump to next snippet node")

  u.adapted_map("is", "<M-h>", function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end, "Jump to previous snippet node")

  u.adapted_map("is", "<M-n>", function()
    if ls.choice_active() then
      ls.change_choice()
    end
  end, "Change node choice")

  u.smap("<BS>", " <BS>", "Remove selection and enter insert mode")
  u.smap("<C-t>", "<Esc>cc", "Remove all text on the current line")

  vim.api.nvim_create_user_command(
    "LuaSnipEdit",
    require("luasnip.loaders").edit_snippet_files,
    {}
  )
end

local function apply(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/L3MON4D3/LuaSnip",
    enabled = not LightWeight,
    event = "InsertEnter",
    build = "make install_jsregexp",
    config = configure,
  })
end

return {
  apply = apply,
}
