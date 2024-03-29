local function base_configure()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      -- Base
      "c",
      "cpp",
      "cmake",
      "lua",
      "python",
      "markdown",
      "comment",

      -- Golang
      "go",
      "gosum",
      "gomod",
      "gowork",

      -- Formats
      "yaml",
      "toml",
      "json",
      "ini",

      -- Git
      "gitattributes",
      "gitcommit",
      "gitignore",

      -- Automate
      "bash",
      "make",
      "dockerfile",

      -- Misc
      "query",
      "vimdoc",
    },
    syn_install = true,

    highlight = {
      enable = true,
    },

    indent = {
      enable = true,
    },
  })
end

local function textobjects_configure()
  require("nvim-treesitter.configs").setup({
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["<Plug>(virtual-text-a)f"] = "@function.outer",
          ["<Plug>(virtual-text-i)f"] = "@function.inner",
        },
      },
      swap = {
        enable = true,
        swap_previous = { ["b,"] = "@parameter.inner" },
        swap_next = { ["b."] = "@parameter.inner" },
      },
      -- TODO: add abilite to jump next / previous
      move = {
        enable = true,
        set_jumps = false,
        goto_previous_start = {
          ["x,"] = "@parameter.inner",
          ["xf"] = "@function.outer",
          ["xF"] = "@function.inner",
        },
        goto_next_start = {
          ["x."] = "@parameter.inner",
          ["xd"] = "@function.outer",
          ["xD"] = "@function.inner",
        },
      },
    },
  })
end

local function apply(plugin_manager)
  -- Base
  plugin_manager.add({
    url = "https://github.com/nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    enabled = not LightWeight,
    config = base_configure,
  })

  -- Textobjects
  plugin_manager.add({
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    enabled = not LightWeight,
    config = textobjects_configure,
  })
end

return {
  apply = apply,
}
