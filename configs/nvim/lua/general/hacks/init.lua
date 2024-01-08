local delete_word = require("general.hacks.delete-word")
local delay_update_time = require("general.hacks.delay-updatetime")
local visual = require("general.hacks.visual-mode")
local create_format_functions = require("general.hacks.create-format-functions")
local buffers = require("general.hacks.buffers")
local jump_to_line = require("general.hacks.jump-to-line")
local lazy = require("general.hacks.lazy")

return {
  delete_word = delete_word,
  delay_update_time = delay_update_time,
  visual = visual,
  create_format_functions = create_format_functions,
  buffers = buffers,
  jump_to_line = jump_to_line,
  lazy = lazy
}
