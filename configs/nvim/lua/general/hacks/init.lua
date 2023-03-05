local jumpThrough = require("general.hacks.jump-through")
local removeLeftFullWord = require("general.hacks.remove-left-full-word")
local search = require("general.hacks.search")
local delayUpdateTime = require("general.hacks.delay-updatetime")
local visual = require("general.hacks.visual-mode")
local createFormatFunctions = require("general.hacks.create-format-functions")
local buffers = require("general.hacks.buffers")

return {
  jumpThrough = jumpThrough,
  removeLeftFullWord = removeLeftFullWord,
  search = search,
  delayUpdateTime = delayUpdateTime,
  visual = visual,
  createFormatFunctions = createFormatFunctions,
  buffers = buffers,
}
