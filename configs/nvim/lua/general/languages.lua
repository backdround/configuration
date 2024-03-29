local u = require("utilities")

local function golang()
  u.autocmd("UserGolangIndentation", "FileType", {
    desc = "Use 4 width tabs in golang",
    pattern = "go",
    callback = function()
      vim.bo.expandtab = false
      vim.bo.tabstop = 4
    end,
  })
end

local function earthly(plugin_manager)
  plugin_manager.add("earthly/earthly.vim")

  local earthly_indent_after_target = function()
    -- Gets previous not empty line
    local previous_line_number = vim.fn.search("^.\\+$", "Wbnz")
    local previous_line = unpack(
      vim.api.nvim_buf_get_lines(
        0,
        previous_line_number - 1,
        previous_line_number,
        true
      )
    )
    previous_line = previous_line or ""

    -- Checks that previous line ends with a colon
    if vim.fn.match(previous_line, ":\\s*$") ~= -1 then
      -- Adds indentation
      local previous_indent = vim.fn.indent(previous_line_number)
      return previous_indent + vim.fn.shiftwidth()
    end
    -- Uses vim autoindent feature
    return -1
  end
  -- selene: allow(global_usage)
  _G.user_earthly_indent = earthly_indent_after_target

  u.autocmd("UserEarthlyIndentation", "FileType", {
    pattern = "Earthfile",
    callback = function()
      vim.bo.indentexpr = "v:lua.user_earthly_indent()"
      vim.bo.autoindent = true
    end,
  })
end

local function bats(plugin_manager)
  plugin_manager.add("aliou/bats.vim")
  u.autocmd("UserBatsIndentation", "FileType", {
    desc = "Sets shell indentation for bats filetype",
    pattern = "bats",
    command = "runtime! indent/sh.vim",
  })
end

---@param plugin_manager UserPluginManager
local function apply(plugin_manager)
  golang()
  earthly(plugin_manager)
  bats(plugin_manager)
end

return {
  apply = apply,
}
