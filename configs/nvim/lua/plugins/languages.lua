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

local function earthly(add_plugin)
  add_plugin("earthly/earthly.vim")

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
  u.set_global_once("user_earthly_indent", earthly_indent_after_target)

  u.autocmd("UserEarthlyIndentation", "FileType", {
    pattern = "Earthfile",
    callback = function()
      vim.bo.indentexpr = "v:lua.user_earthly_indent()"
      vim.bo.autoindent = true
    end,
  })
end

local function lsp_configure()
  local function set_buffer_mappings(client, _)
    -- Makes mappings
    local function map(lhs, rhs, desc)
      u.nmap(lhs, rhs, { buffer = 0, desc = desc })
    end

    -- Actions
    map("<leader>r", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>u", vim.lsp.buf.hover, "Show hover")
    map("<leader>v", vim.lsp.buf.code_action, "Code action")

    local format = hacks.create_format_functions(client.id)
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
    on_attach = set_buffer_mappings,
    capabilities = capabilities,
  })
end

local function null_configure()
  local function make_buffer_mappings(client, _)
    local format = hacks.create_format_functions(client.id)
    local desc = "Format code by null lsp server"
    u.nmap("<leader>o", format.operator, { buffer = 0, desc = desc })
    desc = "Format selected code by null lsp server"
    u.xmap("<leader>o", format.visual, { buffer = 0, desc = desc })
    desc = "Format code in file by null lsp server"
    u.nmap("<leader><M-o>", format.file, { buffer = 0, desc = desc })
  end

  local null = require("null-ls")
  null.setup({
    on_attach = make_buffer_mappings,
    border = "single",

    sources = {
      -- lua
      null.builtins.formatting.stylua,
      null.builtins.diagnostics.selene,
      -- TODO: check ThePrimeagen/refactoring.nvim
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

-- TODO: add symbol highlighting under cursor
-- TODO: check ray-x/lsp_signature
local function apply(add_plugin)
  add_plugin({
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "nvim-telescope/telescope.nvim",
    },
    config = lsp_configure,
  })

  add_plugin({
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = null_configure,
  })

  golang(add_plugin)
  earthly(add_plugin)
  setup_hover_appearance()
end

return {
  apply = apply,
}
