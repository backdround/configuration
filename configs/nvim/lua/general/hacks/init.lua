local delete_word = require("general.hacks.delete-word")
local debouncer = require("general.hacks.debouncer")
local visual = require("general.hacks.visual-mode")
local create_format_functions = require("general.hacks.create-format-functions")
local buffers = require("general.hacks.buffers")
local jump_to_line = require("general.hacks.jump-to-line")
local lazy = require("general.hacks.lazy")
local smart_paste = require("general.hacks.smart-paste")

return {
  delete_word = delete_word,
  debouncer = debouncer,
  visual = visual,
  create_format_functions = create_format_functions,
  buffers = buffers,
  jump_to_line = jump_to_line,
  lazy = lazy,
  smart_paste = smart_paste,
}
