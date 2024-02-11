local delete_word = require("general.hacks.delete-word")
local visual = require("general.hacks.visual-mode")
local create_format_functions = require("general.hacks.create-format-functions")
local buffers = require("general.hacks.buffers")
local jump_to_line = require("general.hacks.jump-to-line")
local lazy = require("general.hacks.lazy")
local smart_paste = require("general.hacks.smart-paste")
local join_lines = require("general.hacks.join-lines")
local focus_floating_window = require("general.hacks.focus-floating-window")
local show_in_float_window = require("general.hacks.show-in-float-window")

return {
  delete_word = delete_word,
  visual = visual,
  create_format_functions = create_format_functions,
  buffers = buffers,
  jump_to_line = jump_to_line,
  lazy = lazy,
  smart_paste = smart_paste,
  join_lines = join_lines,
  focus_floating_window = focus_floating_window,
  show_in_float_window = show_in_float_window,
}
