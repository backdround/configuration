local u = require("utilities")

local function configure()
  local cmp = require("cmp")
  local lspkind = require("lspkind")

  local confirm = cmp.mapping.confirm({ select = true })
  local abort = cmp.mapping.abort()

  local select_next = function()
    if cmp.visible() then
      cmp.select_prev_item({ behavior = cmp.SelectBehavior })
    else
      cmp.complete()
    end
  end

  local select_previous = function()
    if cmp.visible() then
      cmp.select_next_item({ behavior = cmp.SelectBehavior })
    else
      cmp.complete()
    end
  end

  u.imap("<C-s>", select_previous, "Select previous item or open completion")
  u.imap("<C-p>", select_next, "Select next item or open completion")
  u.imap("<M-o>", confirm, "Complete by selected item")
  u.imap("<M-s>", abort, "Abort completion")

  cmp.setup({
    sources = cmp.config.sources({
      { name = "luasnip" },
      { name = "nvim_lsp" },
    }, {
      { name = "path" },
      { name = "buffer", keyword_length = 4 },
    }),

    window = {
      completion = {
        border = "single",
        winhighlight = "Search:None,CursorLine:PmenuSel",
      },
      documentation = {
        border = "single",
        winhighlight = "Search:None",
      },
    },

    snippet = {
      expand = function(args)
        local luasnip = require("luasnip")
        luasnip.lsp_expand(args.body)
      end,
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
          },
        })(entry, vim_item)

        -- Adds additional space between symbol and text
        local strings = vim.split(kind.kind, "%s", { trimempty = true })
        kind.kind = strings[1] .. "  " .. strings[2]

        -- Separates sources
        kind.menu = "┆ " .. kind.menu

        return kind
      end,
    },
  })
end

local function apply(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/hrsh7th/nvim-cmp",
    enabled = not LightWeight,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "onsails/lspkind.nvim",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = configure,
  })
end

return {
  apply = apply,
}
