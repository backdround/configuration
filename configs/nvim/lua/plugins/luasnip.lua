local u = require("utilities")

local function concatenateLists(...)
  local unitedList = {}
  for _, list in ipairs({...}) do
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

  local setMap = function(lhs, rhs)
    vim.keymap.set({ "i", "s" }, lhs, rhs, { silent = true })
  end

  setMap("<C-t>", function()
    if ls.expand_or_jumpable() then
      ls.expand_or_jump()
    end
  end)

  setMap("<C-h>", function()
    if ls.jumpable(-1) then
      ls.jump(-1)
    end
  end)

  setMap("<C-n>", function()
    if ls.choice_active() then
      ls.change_choice()
    end
  end)

  -- Remove all and switch to insert mode on backspace
  vim.keymap.set("s", "<BS>", u.wrap(u.feedkeys, " <BS>"), { silent = true })
end

local function apply(addPlugin)
  addPlugin({
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    config = configure,
  })
end

return {
  apply = apply
}
