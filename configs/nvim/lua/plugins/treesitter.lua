local function baseConfigure()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      -- Base
      "c",
      "cpp",
      "cmake",
      "lua",
      "python",

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
      "markdown",
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

local function textobjectsConfigure()
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

local function apply(addPlugin)
  -- Base
  addPlugin({
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = baseConfigure,
  })

  -- Textobjects
  addPlugin({
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = textobjectsConfigure,
  })
end

return {
  apply = apply,
}
