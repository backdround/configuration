local u = require("utilities")
local hacks = require("general.hacks")

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
    local function map(lhs, rhs, desc)
      u.nmap(lhs, rhs, { buffer = 0, desc = desc })
    end

    -- Actions
    map("<leader>r", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>u", vim.lsp.buf.hover, "Show hover")
    map("<leader>v", vim.lsp.buf.code_action, "Code action")

    local format = hacks.createFormatFunctions(client.id)
    local desc = "Format code by lsp server"
    u.nmap("<leader>q", format.operator, { buffer = 0, desc = desc })
    desc = "Format selected code by lsp server"
    u.xmap("<leader>q", format.visual, { buffer = 0, desc = desc })
    desc = "Format code in file by lsp server"
    u.nmap("<leader><M-q>", format.file, { buffer = 0, desc = desc })

    local telescope = require("telescope.builtin")

    -- Goto symbols
    map("xh", telescope.lsp_definitions, "Go to definition")
    map("xt", telescope.lsp_type_definitions, "Go to type definition")
    map("xn", telescope.lsp_implementations, "Go to implementation")
    map("xr", telescope.lsp_references, "Go to reference")
    map("<leader><M-n>", telescope.lsp_document_symbols, "Go to buffer symbol")

    -- Diagnostics
    map("<leader>g", vim.diagnostic.open_float, "Open diagnostic float")
    map("<leader>e", telescope.diagnostics, "Go to diagnostic")
    map("xc", vim.diagnostic.goto_next, "Go to next diagnostic")
    map("xg", vim.diagnostic.goto_prev, "Go to previous diagnostic")
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
				diagnostics = {
					disable = {
						"duplicate-set-field",
						"duplicate-set-index",
					},
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
    local desc = "Format code by null lsp server"
    u.nmap("<leader>o", format.operator, { buffer = 0, desc = desc })
    desc = "Format selected code by null lsp server"
    u.xmap("<leader>o", format.visual, { buffer = 0, desc = desc })
    desc = "Format code in file by null lsp server"
    u.nmap("<leader><M-o>", format.file, { buffer = 0, desc = desc })
  end

  local null = require("null-ls")
  null.setup({
    on_attach = makeBufferMappings,
    border = "single",

    sources = {
      -- lua
      null.builtins.formatting.stylua,
      null.builtins.diagnostics.selene,
      -- TODO: check ThePrimeagen/refactoring.nvim
    },
  })
end

local function setupHoverAppearance()
	local originalOpenFloatingPreview = vim.lsp.util.open_floating_preview
	vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "single"
		return originalOpenFloatingPreview(contents, syntax, opts, ...)
	end
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
  addPlugin("earthly/earthly.vim")
	setupHoverAppearance()
end

return {
  apply = apply,
}
