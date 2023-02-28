local asserts = require("utilities.asserts")
local mappings = require("utilities.mappings")
local general = require("utilities.general")

return vim.tbl_extend("error", {}, asserts, mappings, general)
