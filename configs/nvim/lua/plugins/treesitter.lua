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
          ["<Plug>(virtual-visual-a)f"] = "@function.outer",
          ["<Plug>(virtual-visual-i)f"] = "@function.inner",
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
    config = base_configure,
  })

  -- Textobjects
  plugin_manager.add({
    url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = textobjects_configure,
  })

  -- Playground
  plugin_manager.add({
    url = "https://github.com/nvim-treesitter/playground",
    dependencies = "nvim-treesitter/nvim-treesitter",
  })
end

return {
  apply = apply,
}
