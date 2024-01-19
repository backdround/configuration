local assert_types = {
  assert_types = require("utilities.assert_types")
}

local mappings = require("utilities.mappings")
local general = require("utilities.general")

return vim.tbl_extend("error", {}, assert_types, mappings, general)
