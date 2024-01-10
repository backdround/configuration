local mappings = require("utilities.mappings")
local general = require("utilities.general")

return vim.tbl_extend("error", {}, mappings, general)
