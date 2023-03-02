local u = require("utilities")

local function concatenateLists(...)
  local unitedList = {}
  for _, list in ipairs({ ... }) do
    unitedList = vim.list_extend(unitedList, list)
  end
  return unitedList
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
      concatenateLists = concatenateLists,
      inspect = inspect,
    },
  })

  local luaSnipLoader = require("luasnip.loaders.from_lua")
  luaSnipLoader.load({ paths = "./snippets" })

  local setMap = function(lhs, rhs, desc)
    vim.keymap.set({ "i", "s" }, lhs, rhs, { silent = true, desc = desc })
  end

  setMap("<C-t>", function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end, "Expand snippet or jump to next snippet node")

  setMap("<C-h>", function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end, "Jump to previous snippet node")

  setMap("<C-n>", function()
    if ls.choice_active() then
      ls.change_choice()
    end
  end, "Change node choice")

  -- Remove all and switch to insert mode on backspace
  vim.keymap.set("s", "<BS>", u.wrap(u.feedkeys, " <BS>"), {
    silent = true,
    desc = "Fixed <BS>",
  })

  vim.api.nvim_create_user_command(
    "LuaSnipEdit",
    require("luasnip.loaders").edit_snippet_files,
    {}
  )
end

local function apply(addPlugin)
  addPlugin({
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    config = configure,
  })
end

return {
  apply = apply,
}