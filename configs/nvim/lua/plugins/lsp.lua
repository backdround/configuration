local u = require("utilities")
local hacks = require("general.hacks")

local function lsp_configure()
  local set_buffer_mappings = function(client, _)

    local map = function(modes, lhs, rhs, desc)
      u.adapted_map(modes, lhs, rhs, { buffer = 0, desc = desc })
    end

    -- Actions
    map("n", "<leader>r", vim.lsp.buf.rename, "Rename symbol")
    map("n", "<leader>u", vim.lsp.buf.hover, "Show hover")
    map("n", "<leader>v", vim.lsp.buf.code_action, "Code action")
    map("nis", "<M-,>", vim.lsp.buf.signature_help, "Toggle signature window")

    -- Diagnostics
    map("n", "<leader>g", vim.diagnostic.open_float, "Open diagnostic float")
    map("n", "xc", vim.diagnostic.goto_next, "Go to next diagnostic")
    map("n", "xg", vim.diagnostic.goto_prev, "Go to previous diagnostic")

    -- Format
    local format = hacks.create_format_functions(client.id)
    map("nx", "<leader>q", format.operator, "Format code by lsp server")
    map("n", "<leader><M-q>", format.file, "Format the file by lsp server")

    -- Go to symbols
    local status, telescope = pcall(require, "telescope.builtin")
    if status then
      local local_symbols = telescope.lsp_document_symbols
      map("n", "xh", telescope.lsp_definitions, "Go to definition")
      map("n", "xt", telescope.lsp_type_definitions, "Go to type definition")
      map("n", "xn", telescope.lsp_implementations, "Go to implementation")
      map("n", "xr", telescope.lsp_references, "Go to reference")
      map("n", "<leader><M-n>", local_symbols, "Go to buffer symbol")
      map("n", "<leader>e", telescope.diagnostics, "Go to diagnostic")
    end
  end

  -- Adds LspInfo border
  require("lspconfig.ui.windows").default_options.border = "single"

  -- Adds diagnostic border
  vim.diagnostic.config({
    float = {
      border = "single",
      source = "always",
    },
  })

  -- Sets up lsp servers
  local lspconfig = require("lspconfig")
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  lspconfig.lua_ls.setup({
    on_attach = set_buffer_mappings,
    capabilities = capabilities,
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
          keywordSnippet = "Disable",
        },
        diagnostics = {
          disable = {
            "duplicate-set-field",
            "duplicate-set-index",
          },
        },
        workspace = {
          checkThirdParty = false,
          library = vim.api.nvim_get_runtime_file("lua", true),
          ignoreDir = { "./snippets" },
        },
        telemetry = {
          enable = false,
        },
      },
    },
  })

  lspconfig.gopls.setup({
    on_attach = set_buffer_mappings,
    capabilities = capabilities,
  })
end

local function null_configure()
  local function make_buffer_mappings(client, _)
    local map = function(modes, lhs, rhs, desc)
      u.adapted_map(modes, lhs, rhs, { buffer = 0, desc = desc })
    end

    local format = hacks.create_format_functions(client.id)
    map("nx", "<leader>o", format.operator, "Format code by null lsp server")
    map("n", "<leader><M-o>", format.file, "Format the file by null lsp server")
  end

  local null = require("null-ls")
  null.setup({
    on_attach = make_buffer_mappings,
    border = "single",

    sources = {
      -- lua
      null.builtins.formatting.stylua,
      null.builtins.diagnostics.selene,
    },
  })
end

local function setup_hover_appearance()
  local original_open_floating_preview = vim.lsp.util.open_floating_preview
  vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or "single"
    return original_open_floating_preview(contents, syntax, opts, ...)
  end
end

local base = function(plugin_manager)
  plugin_manager.add({
    url = "https://github.com/neovim/nvim-lspconfig",
    enabled = not LightWeight,
    dependencies = {
      "https://github.com/hrsh7th/cmp-nvim-lsp",
      "https://github.com/nvim-telescope/telescope.nvim",
      {
        url = "https://github.com/folke/neodev.nvim",
        opts = {},
        dependencies = {
          url = "https://github.com/folke/neoconf.nvim",
          opts = {},
        },
      },
    },
    config = lsp_configure,
  })

  plugin_manager.add({
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim",
    enabled = not LightWeight,
    dependencies = "nvim-lua/plenary.nvim",
    config = null_configure,
  })
end

local function apply(plugin_manager)
  base(plugin_manager)

  if not LightWeight then
    setup_hover_appearance()
  end
end

return {
  apply = apply
}
