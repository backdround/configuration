local u = require("utilities")

local function concatenate_lists(...)
  local united_list = {}
  for _, list in ipairs({ ... }) do
    united_list = vim.list_extend(united_list, list)
  end
  return united_list
end

local function inspect(args)
  u.notify(vim.inspect(args))
end

local function configure()
  local ls = require("luasnip")
  ls.setup({
    history = false,
    region_check_events = { "CursorHold" },
    delete_check_events = { "CursorHold" },
    update_events = { "TextChanged", "TextChangedI" },
    snip_env = {
      concatenate_lists = concatenate_lists,
      inspect = inspect,
    },
  })

  local lua_snip_loader = require("luasnip.loaders.from_lua")
  lua_snip_loader.load({ paths = "./snippets" })

  local set_map = function(lhs, rhs, desc)
    vim.keymap.set({ "i", "s" }, lhs, rhs, { silent = true, desc = desc })
  end

  set_map("<M-t>", function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end, "Expand snippet or jump to next snippet node")

  set_map("<M-h>", function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end, "Jump to previous snippet node")

  set_map("<M-n>", function()
    if ls.choice_active() then
      ls.change_choice()
    end
  end, "Change node choice")

  -- Remove all and switch to insert mode on backspace
  vim.keymap.set("s", "<BS>", u.wrap(u.feedkeys, " <BS>"), {
    silent = true,
    desc = "Fixed <BS>",
  })

  -- Add map to clear current line
  vim.keymap.set("s", "<C-b>", "<Esc>cc", {
    silent = true,
    desc = "Remove all text on the current line",
  })

  vim.api.nvim_create_user_command(
    "LuaSnipEdit",
    require("luasnip.loaders").edit_snippet_files,
    {}
  )
end

local function apply(add_plugin)
  add_plugin({
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    config = configure,
  })
end

return {
  apply = apply,
}
