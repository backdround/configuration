utilities = require("utilities")

local function golang(addPlugin)
  utilities.autocmd("UserGolangIndentation", "FileType", {
    desc = "Use 4 width tabs in golang",
    pattern = "go",
    callback = function()
      vim.bo.expandtab = false
      vim.bo.tabstop = 4
    end,
  })
end

local function apply(addPlugin)
  golang(addPlugin)
end

return {
  apply = apply,
}
