local u = require("utilities")
local hacks = require("general.hacks")

local border = { "┌", "─", "┐", "│", "┘", "─", "└", "│" }

local function golang(_)
  u.autocmd("UserGolangIndentation", "FileType", {
    desc = "Use 4 width tabs in golang",
    pattern = "go",
    callback = function()
      vim.bo.expandtab = false
      vim.bo.tabstop = 4
    end,
  })
end

local function lspConfigure()
  local function setBufferMappings(client, _)
    -- Makes mappings
    local function map(lhs, rhs)
      u.nmap(lhs, rhs, { buffer = 0 })
    end

    -- Actions
    map("<leader>r", vim.lsp.buf.rename)
    map("<leader>u", vim.lsp.buf.hover)
    map("<leader>v", vim.lsp.buf.code_action)

    local format = hacks.createFormatFunctions(client.id)
    u.nmap("<leader>q", format.operator, { buffer = 0 })
    u.xmap("<leader>q", format.visual, { buffer = 0 })
    u.nmap("<leader><M-q>", format.file, { buffer = 0 })

    local telescope = require("telescope.builtin")

    -- Goto symbols
    map("xh", telescope.lsp_definitions)
    map("xt", telescope.lsp_type_definitions)
    map("xn", telescope.lsp_implementations)
    map("xr", telescope.lsp_references)
    map("<leader><M-n>", telescope.lsp_document_symbols)

    -- Diagnostics
    map("<leader>s", vim.diagnostic.open_float)
    map("<leader>e", telescope.diagnostics)
    map("xc", vim.diagnostic.goto_next)
    map("xg", vim.diagnostic.goto_prev)
  end

  -- Adds LspInfo border
  require("lspconfig.ui.windows").default_options.border = border

  -- Adds diagnostic border
  vim.diagnostic.config({
    float = {
      border = border,
      source = "always",
    },
  })

  -- Sets up lsep servers
  local lspconfig = require("lspconfig")
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  lspconfig.lua_ls.setup({
    on_attach = setBufferMappings,
    capabilities = capabilities,
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
          keywordSnippet = "Disable",
        },
        workspace = {
          checkThirdParty = false,
          library = vim.api.nvim_get_runtime_file("", true),
          ignoreDir = { "./snippets" },
        },
        telemetry = {
          enable = false,
        },
      },
    },
  })

  lspconfig.gopls.setup({
    on_attach = setBufferMappings,
    capabilities = capabilities,
  })
end

local function nullConfigure()
  local function makeBufferMappings(client, _)
    local format = hacks.createFormatFunctions(client.id)
    u.nmap("<leader>o", format.operator, { buffer = 0 })
    u.xmap("<leader>o", format.visual, { buffer = 0 })
    u.nmap("<leader><M-o>", format.file, { buffer = 0 })
  end

  local null = require("null-ls")
  null.setup({
    on_attach = makeBufferMappings,
    border = border,

    sources = {
      -- lua
      null.builtins.formatting.stylua,
      null.builtins.diagnostics.selene,
      -- TODO: check ThePrimeagen/refactoring.nvim
    },
  })
end

-- TODO: add symbol highlighting under cursor
-- TODO: check ray-x/lsp_signature
local function apply(addPlugin)
  addPlugin({
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "nvim-telescope/telescope.nvim",
    },
    config = lspConfigure,
  })

  addPlugin({
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = nullConfigure,
  })

  golang(addPlugin)
end

return {
  apply = apply,
}
