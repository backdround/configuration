local jump_through = require("general.hacks.jump-through")
local remove_left_full_word = require("general.hacks.remove-left-full-word")
local search = require("general.hacks.search")
local delay_update_time = require("general.hacks.delay-updatetime")
local visual = require("general.hacks.visual-mode")
local create_format_functions = require("general.hacks.create-format-functions")
local buffers = require("general.hacks.buffers")
local jump_to_line = require("general.hacks.jump-to-line")

return {
  jump_through = jump_through,
  remove_left_full_word = remove_left_full_word,
  search = search,
  delay_update_time = delay_update_time,
  visual = visual,
  create_format_functions = create_format_functions,
  buffers = buffers,
  jump_to_line = jump_to_line,
}
