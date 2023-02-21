local function configure()
  local cmp = require("cmp")
  local lspkind = require("lspkind")
  local border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }

  local confirm = cmp.mapping.confirm({ select = true })
  local abort = cmp.mapping.abort()

  local selectNext = function()
    if cmp.visible() then
      cmp.select_prev_item({ behavior = cmp.SelectBehavior })
    else
      cmp.complete()
    end
  end

  local selectPrevious = function()
    if cmp.visible() then
      cmp.select_next_item({ behavior = cmp.SelectBehavior })
    else
      cmp.complete()
    end
  end

  cmp.setup({
    mapping = {
      ["<M-u>"] = { i = selectNext },
      ["<M-e>"] = { i = selectPrevious },
      ["<M-o>"] = { i = confirm },
      ["<M-s>"] = { i = abort },
    },

    sources = cmp.config.sources({
      { name = "luasnip" },
      { name = "nvim_lsp" },
      { name = "nvim_lua" },
    }, {
      { name = "path" },
      { name = "buffer", keyword_length = 4 },
    }),

    window = {
      completion = cmp.config.window.bordered({ border = border }),
      documentation = cmp.config.window.bordered({ border = border }),
    },

    snippet = {
      expand = function(args)
        local luasnip = require("luasnip")
        luasnip.lsp_expand(args.body)
      end
    },

    -- Disable autoselection
    preselect = cmp.PreselectMode.None,

    experimental = {
      ghost_text = true,
    },

    formatting = {
      expandable_indicator = false,
      format = function(entry, vim_item)

        local kind = lspkind.cmp_format({
          mode = "symbol_text",
          preset = "default",
          symbol_map = {
            Module = "",
            Class = "",
            Function = "λ",
            Method = "⮠",
          },
          menu = {
            luasnip = "SNIP",
            nvim_lsp = "LSP",
            nvim_lua = "VIM",

            path = "PATH",
            buffer = "BUF",
          }
        })(entry, vim_item)

        -- Adds additional space between symbol and text
        local strings = vim.split(kind.kind, "%s", { trimempty = true })
        kind.kind = strings[1] .. "  " .. strings[2]

        -- Separates sources
        kind.menu = "┆ " .. kind.menu

        return kind
      end,
    }
  })
end

local function apply(addPlugin)
  addPlugin({
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "onsails/lspkind.nvim",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = configure,
  })
end

return {
  apply = apply
}
