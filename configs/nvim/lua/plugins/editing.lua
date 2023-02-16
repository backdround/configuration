local u = require("utilities")

local function nerdcommenter(addPlugin)
  addPlugin("scrooloose/nerdcommenter")

  vim.g.NERDCreateDefaultMappings = 0
  vim.g.NERDRemoveExtraSpaces = 1
  vim.g.NERDTrimTrailingWhitespace = 1
  vim.g.NERDCompactSexyComs = 1

  -- TODO: check normal (not visual) mode
  u.map("bb", "<Plug>NERDCommenterComment")
  u.map("bm", "<Plug>NERDCommenterUncomment")
  u.map("bB", "<Plug>NERDCommenterYank")
end

local function autopairs(addPlugin)
  addPlugin("jiangmiao/auto-pairs")

  vim.g.AutoPairsFlyMode = 0
  vim.g.AutoPairsMultilineClose = 0
  vim.g.AutoPairsMapCh = 0

  vim.g.AutoPairsShortcutToggle = ""
  vim.g.AutoPairsShortcutFastWrap = "<M-i>"
  vim.g.AutoPairsShortcutBackInsert = "<M-y>"
  vim.g.AutoPairsShortcutJump = ""
  u.imap("<M-k>", "<Esc>:call AutoPairsJump()<CR>a")
end

local function targets(addPlugin)
  addPlugin("wellle/targets.vim")

  vim.g.targets_aiAI        = "gc  "
  vim.g.targets_mapped_aiAI = {
    "<Plug>(virtual-visual-a)",
    "<Plug>(virtual-visual-i)",
    "", ""
  }
  vim.g.targets_nl = {"t", "h"}

  u.map("<Plug>(virtual-visual-a)", "a")
  u.map("<Plug>(virtual-visual-i)", "i")
end

local function textobjIndent(addPlugin)
  addPlugin({
    "kana/vim-textobj-indent",
    dependencies = "kana/vim-textobj-user",
  })

  vim.g.textobj_indent_no_default_key_mappings = 1
  u.vmap("<Plug>(virtual-visual-a)u", "<Plug>(textobj-indent-a)")
  u.omap("<Plug>(virtual-visual-a)u", "<Plug>(textobj-indent-a)")
  u.vmap("<Plug>(virtual-visual-i)u", "<Plug>(textobj-indent-i)")
  u.omap("<Plug>(virtual-visual-i)u", "<Plug>(textobj-indent-i)")
end

local function sideways(addPlugin)
  addPlugin("AndrewRadev/sideways.vim")

  u.nmap("b,", "<Cmd>SidewaysLeft<Cr>")
  u.nmap("b.", "<Cmd>SidewaysRight<Cr>")
  u.nmap("x,", "<Cmd>SidewaysJumpLeft<Cr>")
  u.nmap("x.", "<Cmd>SidewaysJumpRight<Cr>")
end

local function surround(addPlugin)
  addPlugin("tpope/vim-surround")

  vim.g.surround_no_mappings = 1
  u.nmap("tn", "<Plug>Dsurround")
  u.nmap("hn", "<Plug>Csurround")
  u.nmap("hN", "<Plug>CSurround")
  u.xmap("n", "<Plug>VSurround")
  u.xmap("N", "<Plug>VgSurround")
end

local function exchange(addPlugin)
  addPlugin("tommcdo/vim-exchange")

  u.map("bc", "<Plug>(Exchange)")
  u.nmap("bC", "<Plug>(ExchangeClear)")
  u.nmap("br", "<Plug>(ExchangeLine)")
end

local function niceblock(addPlugin)
  addPlugin("kana/vim-niceblock")

  vim.g.niceblock_no_default_key_mappings = 1
  u.xmap("G", "<Plug>(niceblock-I)")
  u.xmap("C", "<Plug>(niceblock-A)")
end

local function move(addPlugin)
  addPlugin('matze/vim-move')

  vim.g.move_map_keys = 0
  u.nmap("<M-g>", "<Plug>MoveLineDown")
  u.nmap("<M-c>", "<Plug>MoveLineUp")
  u.nmap("<M-f>", "<Plug>MoveCharLeft")
  u.nmap("<M-r>", "<Plug>MoveCharRight")

  u.vmap("<M-g>", "<Plug>MoveBlockDown")
  u.vmap("<M-c>", "<Plug>MoveBlockUp")
  u.vmap("<M-f>", "<Plug>MoveBlockLeft")
  u.vmap("<M-r>", "<Plug>MoveBlockRight")
end

local function apply(addPlugin)
  nerdcommenter(addPlugin)
  autopairs(addPlugin)
  targets(addPlugin)
  textobjIndent(addPlugin)
  sideways(addPlugin)
  surround(addPlugin)
  exchange(addPlugin)
  niceblock(addPlugin)
  move(addPlugin)
end

return {
  apply = apply
}
