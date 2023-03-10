local u = require("utilities")

local function tabby(addPlugin)
  addPlugin({
    "nanozuki/tabby.nvim",
    config = function()
      require("tabby").setup({})

      local c = require("melting.colors")

      local getColor = function(active, changed, visible)
        local color = {}

        -- Gets foreground
        if changed then
          color.fg = c.match
        elseif active then
          color.fg = c.black
        else
          color.fg = c.foreground
        end

        -- Gets boldness
        if changed or active then
          color.style = "bold"
        end

        -- Gets background
        if active then
          color.bg = c.gray3
        elseif visible then
          color.bg = c.gray2
        else
          color.bg = c.black
        end

        return color
      end

      local getLabel = function(active, changed, visible)
        local label = active and { " " } or { " " }

        label.hl = getColor(active, changed, visible)
        if active and not changed then
          label.hl.fg = c.foreground
        end
        return label
      end

      local backgroundColor = "TabLineFill"
      local enclosureColor = "TabLine"

      require("tabby.tabline").set(function(line)
        local leftEnclosure = {
          { " ", hl = enclosureColor },
          line.sep("", enclosureColor, backgroundColor),
        }

        local buffers = require("general.hacks").buffers.get()
        local bufferNodes = {}
        for _, buffer in ipairs(buffers) do
          local hl = getColor(buffer.isCurrent(), false, buffer.isVisible())
          local bufferNode = {
            line.sep("", hl, backgroundColor),
            getLabel(
              buffer.isCurrent(),
              buffer.isModified(),
              buffer.isVisible()
            ),
            buffer.name(),
            line.sep("", hl, backgroundColor),
            hl = hl,
            margin = " ",
          }
          table.insert(bufferNodes, bufferNode)
        end

        local tabs = line.tabs().foreach(function(tab)
          local hl = getColor(tab.is_current(), false, true)
          return {
            line.sep("", hl, backgroundColor),
            getLabel(tab.is_current(), false, true),
            tab.name():gsub("%[%d+.*$", ""),
            line.sep("", hl, backgroundColor),
            hl = hl,
            margin = " ",
          }
        end)

        local rightEnclosure = {
          line.sep("", enclosureColor, backgroundColor),
          { " ", hl = enclosureColor },
        }

        return {
          leftEnclosure,
          bufferNodes,
          line.spacer(),
          tabs,
          rightEnclosure,
          hl = backgroundColor,
        }
      end)
    end,
  })
  -- Always show tabline
  vim.o.showtabline = 2
end

-- TODO: use gitsigns to show diff
local function lualine(addPlugin)
  local function location()
    local line = vim.fn.line(".")
    local countOfLines = vim.fn.line("$")
    return line .. ":" .. countOfLines
  end

  addPlugin({
    "nvim-lualine/lualine.nvim",
    config = function()
      local line = require("lualine")
      line.setup({
        options = {
          theme = "melting",
          component_separators = { left = "╱", right = "╱" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = { { "filename", newfile_status = true } },
          lualine_x = { "diagnostics", "filetype" },
          lualine_y = { "encoding" },
          lualine_z = { location },
        },
        inactive_sections = {
          lualine_b = { { "filename", newfile_status = true } },
          lualine_c = {},
          lualine_x = { location },
        },
      })

      u.autocmd("UserUpdateLualineAfterBufWrite", "BufWritePost", {
        desc = "Refresh lualine after buffer was written (more responsive presentation)",
        callback = line.refresh,
      })
    end,
  })
end

local function apply(addPlugin)
  tabby(addPlugin)
  lualine(addPlugin)
end

return {
  apply = apply,
}
