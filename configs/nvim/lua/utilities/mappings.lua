local assert_types = require("utilities.assert-types")
local mappings_keeper = require("utilities.mappings-keeper")
local M = {}

---Wraper over vim.keymap.set
---@param modes string could be a single or several modes.
---@param lhs string
---@param rhs string|function
---@param options_or_description table|string
M.adapted_map = function(modes, lhs, rhs, options_or_description)
  assert_types({
    mode = { modes, "string" },
    lhs = { lhs, "string" },
    rhs = { rhs, "string", "function" },
    options_or_description = { options_or_description, "string", "table" },
  })

  local mode = {}
  for i = 1, #modes do
    local m = modes:sub(i, i)
    table.insert(mode, m)
  end

  local options = {}
  if type(options_or_description) == "table" then
    options = options_or_description
  elseif type(options_or_description) == "string" then
    options.desc = options_or_description
  end

  if not options.desc then
    print("There is no description for the mapping: " .. lhs)
    print("Please add it!")
  end

  local default = {
    silent = true,
    noremap = true,
  }
  options = vim.tbl_extend("force", default, options)

  mappings_keeper.perform_real_vim_keymap_set(mode, lhs, rhs, options)
end

---Maps in normal, visual and operator pending mode
---@param lhs string
---@param rhs string|function
---@param options_or_description table|string
M.map = function(lhs, rhs, options_or_description)
  M.adapted_map("nxo", lhs, rhs, options_or_description)
end

---@param lhs string
---@param rhs string|function
---@param options_or_description table|string
M.nmap = function(lhs, rhs, options_or_description)
  M.adapted_map("n", lhs, rhs, options_or_description)
end

---@param lhs string
---@param rhs string|function
---@param options_or_description table|string
M.imap = function(lhs, rhs, options_or_description)
  M.adapted_map("i", lhs, rhs, options_or_description)
end

---@param lhs string
---@param rhs string|function
---@param options_or_description table|string
M.omap = function(lhs, rhs, options_or_description)
  M.adapted_map("o", lhs, rhs, options_or_description)
end

---@param lhs string
---@param rhs string|function
---@param options_or_description table|string
M.xmap = function(lhs, rhs, options_or_description)
  M.adapted_map("x", lhs, rhs, options_or_description)
end

return M
