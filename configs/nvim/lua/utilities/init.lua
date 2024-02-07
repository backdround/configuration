local assert_types = {
  assert_types = require("utilities.assert_types"),
}

local logger = {
  new_logger = require("utilities.logger").new,
}

local profiler = {
  profile = require("utilities.profiler")
}

local mappings = require("utilities.mappings")
local general = require("utilities.general")

local parts = { assert_types, logger, profiler, mappings, general }

return vim.tbl_extend("error", {}, unpack(parts))
