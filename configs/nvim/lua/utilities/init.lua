local assert_types = {
  assert_types = require("utilities.assert-types"),
}

local logger = {
  new_logger = require("utilities.logger").new,
}

local profiler = {
  profile = require("utilities.profiler")
}

local mappings = require("utilities.mappings")
local mappings_keeper = require("utilities.mappings-keeper")
local general = require("utilities.general")

local parts = {
  assert_types,
  logger,
  profiler,
  mappings,
  mappings_keeper,
  general,
}

return vim.tbl_extend("error", {}, unpack(parts))
