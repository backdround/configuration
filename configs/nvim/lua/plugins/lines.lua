local u = require("utilities")

local function tabby(add_plugin)
  add_plugin({
    "nanozuki/tabby.nvim",
    config = function()
      require("tabby").setup({})

      local c = require("melting.colors")

      local get_color = function(active, changed, visible)
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

      local get_label = function(active, changed, visible)
        local label = active and { " " } or { " " }

        label.hl = get_color(active, changed, visible)
        if active and not changed then
          label.hl.fg = c.foreground
        end
        return label
      end

      local background_color = "TabLineFill"
      local enclosure_color = "TabLine"

      require("tabby.tabline").set(function(line)
        local left_enclosure = {
          { " ", hl = enclosure_color },
          line.sep("", enclosure_color, background_color),
        }

        local buffers = require("general.hacks").buffers.get()
        local buffer_nodes = {}
        for _, buffer in ipairs(buffers) do
          local hl = get_color(buffer.is_current(), false, buffer.is_visible())
          local buffer_node = {
            line.sep("", hl, background_color),
            get_label(
              buffer.is_current(),
              buffer.is_modified(),
              buffer.is_visible()
            ),
            buffer.name(),
            line.sep("", hl, background_color),
            hl = hl,
            margin = " ",
          }
          table.insert(buffer_nodes, buffer_node)
        end

        local tabs = line.tabs().foreach(function(tab)
          local hl = get_color(tab.is_current(), false, true)
          return {
            line.sep("", hl, background_color),
            get_label(tab.is_current(), false, true),
            tab.name():gsub("%[%d+.*$", ""),
            line.sep("", hl, background_color),
            hl = hl,
            margin = " ",
          }
        end)

        local right_enclosure = {
          line.sep("", enclosure_color, background_color),
          { " ", hl = enclosure_color },
        }

        return {
          left_enclosure,
          buffer_nodes,
          line.spacer(),
          tabs,
          right_enclosure,
          hl = background_color,
        }
      end)

      u.autocmd("UserUpdateTabby", { "BufAdd", "BufDelete" }, {
        desc = "Update tabby line when buffer delisted",
        callback = require("tabby").update,
      })
    end,
  })
  -- Always show tabline
  vim.o.showtabline = 2
end

-- TODO: use gitsigns to show diff
local function lualine(add_plugin)
  local function location()
    local line = vim.fn.line(".")
    local count_of_lines = vim.fn.line("$")
    return line .. ":" .. count_of_lines
  end

  add_plugin({
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

local function apply(add_plugin)
  tabby(add_plugin)
  lualine(add_plugin)
end

return {
  apply = apply,
}
