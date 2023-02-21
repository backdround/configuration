local u = require("utilities")
local hacks = require("general.hacks")

local function wordMotion(addPlugin)
  -- Base mode
  u.map("w", "b")
  u.map("j", "w")
  u.map("q", "ge")
  u.map("p", "e")

  u.map("W", "B")
  u.map("J", "W")
  u.map("Q", "gE")
  u.map("P", "E")

  -- Insert mode
  u.imap("<C-w>", "<C-o>b")
  u.imap("<C-q>", "<Esc>gea")
  u.imap("<C-j>", "<C-o>w")
  u.imap("<C-p>", "<Esc>ea")

  u.imap("<C-a>", "<C-o>B")
  u.imap("<C-o>", "<Esc>gEa")
  u.imap("<C-e>", "<C-o>W")
  u.imap("<C-u>", "<Esc>Ea")

  -- Wordmotion plugin
  vim.g.wordmotion_spaces = "()[]<>{},./%@^!?;:$~`\"\\#_|-+=&*' "
  vim.g.wordmotion_nomap = 1
  addPlugin("chaoren/vim-wordmotion")

  u.map("<M-w>", "<Plug>WordMotion_b")
  u.map("<M-q>", "<Plug>WordMotion_ge")
  u.map("<M-j>", "<Plug>WordMotion_w")
  u.map("<M-p>", "<Plug>WordMotion_e")

  u.imap("<M-w>", "<C-o><Plug>WordMotion_b")
  u.imap("<M-q>", "<Left><C-o><Plug>WordMotion_ge<Right>")
  u.imap("<M-j>", "<C-o><Plug>WordMotion_w")
  u.imap("<M-p>", "<C-o><Plug>WordMotion_e<Right>")
end


local function scroll(addPlugin)
  addPlugin("yuttie/comfortable-motion.vim")

  vim.g.comfortable_motion_no_default_key_mappings = 1
  vim.g.comfortable_motion_interval = 7

  vim.g.comfortable_motion_friction = 320.0
  vim.g.comfortable_motion_air_drag = 13

  -- Save real updatetime for lambdas.
  local realUpdateTime = vim.go.updatetime

  local function scroll(direction)
    return function()
      -- Temporary disables CursorHold events
      hacks.delayUpdateTime(300, realUpdateTime)

      -- Scroll
      local height = vim.api.nvim_win_get_height(0)
      vim.fn["comfortable_motion#flick"](height * direction)
    end
  end

  u.map("e", scroll(5))
  u.map("u", scroll(-5))
  u.map("E", scroll(8.4))
  u.map("U", scroll(-8.4))
end

-- TODO: stable '(' / ')'
local function findCharacter(addPlugin)
  addPlugin("dahu/vim-fanfingtastic")

  -- Forward char
  u.map("k", "<Plug>fanfingtastic_f")
  u.map("<M-k>", "<Plug>fanfingtastic_t")

  -- Backward char
  u.map("<M-z>", "<Plug>fanfingtastic_T")
  u.map("z", "<Plug>fanfingtastic_F")

  -- Between chars
  u.map(")", "<Plug>fanfingtastic_;")
  u.map("(", "<Plug>fanfingtastic_,")

  -- Jump through quotes
  u.map("+", function() hacks.jumpThrough("[\"'`]", true) end)
  u.map("-", function() hacks.jumpThrough("[\"'`]", false) end)

  -- Jump through brackets
  u.map("^", function() hacks.jumpThrough("[()]", true) end)
  u.map("@", function() hacks.jumpThrough("[()]", false) end)
end


local function marks()
  u.map("y", "m")
  u.map("Y", "<C-o>")
  u.map("i", "`")
  u.map("I", "<C-i>")
end


local function pageMovements()
  u.map("o", "<nop>")

  u.map("oh", "G")
  u.map("ot", "gg")
  u.map("og", "zH")
  u.map("oc", "zL")

  u.map("of", "-ze")
  u.map("od", "^ze")
  u.map("ob", "+ze")

  u.map("or", "-$")
  u.map("on", "$")
  u.map("o.", "+$")
end


-- TODO: switch to hop (that doesn't write to buffer)
-- in order to fix linter chaos.
local function easymotion(addPlugin)
  addPlugin('easymotion/vim-easymotion')

  vim.g.EasyMotion_do_mapping = 0
  vim.g.EasyMotion_keys = 'vrscjonetidpguhkxfmbwlay'
  vim.g.EasyMotion_grouping = 2
  vim.g.EasyMotion_smartcase = 1
  vim.g.EasyMotion_grouping = 1

  u.map("a", "<Plug>(easymotion-lineanywhere)")

  u.map("ow", "<Plug>(easymotion-b)")
  u.map("oq", "<Plug>(easymotion-ge)")
  u.map("oj", "<Plug>(easymotion-w)")
  u.map("op", "<Plug>(easymotion-e)")

  u.map("ok", "<Plug>(easymotion-f)")
  u.map("oz", "<Plug>(easymotion-F)")

  u.map("oa", "<Plug>(easymotion-B)")
  u.map("oo", "<Plug>(easymotion-gE)")
  u.map("oe", "<Plug>(easymotion-W)")
  u.map("ou", "<Plug>(easymotion-E)")
end

local function misc()
  u.nmap("xh", "<C-]>")
  u.nmap("xt", "<Cmd>tab Man<CR>")
  u.nmap("xn", "gd")
end


local function apply(addPlugin)
  wordMotion(addPlugin)
  scroll(addPlugin)
  easymotion(addPlugin)
  findCharacter(addPlugin)
  marks()
  pageMovements()
  misc()
end

return {
   apply = apply
}
