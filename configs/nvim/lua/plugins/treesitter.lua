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
      "help",
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
          ["xF"] = "@function.inner",
        },
        goto_next_start = {
          ["x."] = "@parameter.inner",
          ["xf"] = "@function.inner",
        },
      },
    },
  })
end

local function apply(add_plugin)
  -- Base
  add_plugin({
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = base_configure,
  })

  -- Textobjects
  add_plugin({
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = textobjects_configure,
  })

  -- Playground
  add_plugin({
    "nvim-treesitter/playground",
    dependencies = "nvim-treesitter/nvim-treesitter",
  })
end

return {
  apply = apply,
}
