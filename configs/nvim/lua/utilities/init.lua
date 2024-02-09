local mappings = require("utilities.mappings")
local mappings_keeper = require("utilities.mappings-keeper")
local general = require("utilities.general")

return {
  assert_types = require("utilities.assert-types"),
  new_logger = require("utilities.logger").new,
  profile = require("utilities.profiler").profile,
  new_debouncer = require("utilities.debouncer").new,

  allow_mappings_from = mappings_keeper.allow_mappings_from,
  prohibit_external_mappings = mappings_keeper.prohibit_external_mappings,
  perform_real_vim_keymap_set = mappings_keeper.perform_real_vim_keymap_set,

  adapted_map = mappings.adapted_map,
  map = mappings.map,
  nmap = mappings.nmap,
  imap = mappings.imap,
  omap = mappings.omap,
  xmap = mappings.xmap,

  replace_termcodes = general.replace_termcodes,
  autocmd = general.autocmd,
  notify = general.notify,
  wrap = general.wrap,
  feedkeys = general.feedkeys,
  array_extend = general.array_extend,
  load = general.load,
  mode = general.mode,
}
