local assert_types = require("utilities.assert-types")
local mappings_keeper = require("utilities.mappings-keeper")
local M = {}

---More convinient wrapper for vim.keymap.set
---@param modes string|table
---@param lhs string
---@param rhs string|function
---@param options_or_description table|string
M.adapted_map = function(modes, lhs, rhs, options_or_description)
  assert_types({
    mode = { modes, "string", "table" },
    lhs = { lhs, "string" },
    rhs = { rhs, "string", "function" },
    options_or_description = { options_or_description, "string", "table" },
  })

  local mode = {}
  if type(modes) == "string" then
    for i = 1, #modes do
      local m = modes:sub(i, i)
      table.insert(mode, m)
    end
  else
    mode = modes
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

M.map = function(lhs, rhs, options)
  M.adapted_map({ "n", "x", "o" }, lhs, rhs, options)
end

local modes = { "n", "i", "v", "c", "t", "o", "x", "s", "l" }
for _, mode in ipairs(modes) do
  M[mode .. "map"] = function(lhs, rhs, options_or_description)
    M.adapted_map(mode, lhs, rhs, options_or_description)
  end
end

return M
