local u = require("utilities")
local hacks = require("general.hacks")

local function editing()
  u.map("h", "c")
  u.map("H", "C")

  u.map("t", "d")
  u.map("T", "D")

  u.map(",", "r")
  u.map("'", "x")

  u.map("\"", "J")
end

local function insert()
  -- Enter mode
  u.nmap("g", "i")
  u.nmap("G", "I")
  u.nmap("c", "a")
  u.nmap("C", "A")

  u.nmap("o<M-b>", "+zei")
  u.nmap("o<M-f>", "-zei")
  u.nmap("o<M-.>", "+$a")
  u.nmap("o<M-r>", "-$a")

  u.nmap("r", "o")
  u.nmap("R", "O")

  -- Editing
  u.imap("<C-t>", "<Esc>cc")
  u.imap("<C-h>", "<C-w>")
  u.imap("<M-h>", hacks.removeLeftFullWord)
end

local function visual()
  -- Enter mode
  u.nmap("n", hacks.visual.enter)
  u.nmap("N", "V")
  u.nmap("<C-n>", "<C-v>")

  -- Multiline editing
  u.vmap("G", "I")
  u.vmap("C", "A")

  -- Case switching
  u.vmap("m", "gu")
  u.vmap("M", "gU")

  -- Swap strat/end
  u.vmap("r", "o")
end

local function copyPaste()
  -- Normal copy/paste
  u.map("f", '"yy')
  u.nmap("ff", '"yyy')
  u.nmap("F", '"yy$')

  u.map("<M-l>", '"yp')
  u.map("<M-L>", '"yP')

  -- Clipboard copy/paste
  u.map("<leader>f", '"+y')
  u.nmap("<leader>ff", '"+yy')
  u.nmap("<leader>fF", '"+y$')

  u.map("<leader>l", '"+p')
  u.map("<leader>L", '"+P')

  -- Save copy/paste
  u.map("bf", '"sy')
  u.map("bl", '"sp')

  -- Primary copy
  u.map("<leader>F", '"*y')
  u.nmap("<leader>Ff", '"*yy')
  u.nmap("<leader>FF", '"*y$')

  -- Unnamed paste
  u.map("l", "p")
  u.map("L", "P")

  -- Insert paste
  u.imap("<C-l>", '<C-r>"')
  u.imap("<M-l>", '<C-r>y')

  -- Highlight yanked area
  u.autocmd("UserHightlightYankedText", "TextYankPost", {
    callback = function()
      vim.highlight.on_yank({
        higroup = "HighlightedyankRegion",
        timeout = 140,
      })
    end
  })
end

local function search()
  u.nmap("!", hacks.search.currentWordWithoutMoving)
  u.nmap("*", "g*")
  u.nmap("#", "g#")
  u.nmap("]", hacks.search.stableNext)
  u.nmap("[", hacks.search.stablePrevious)

  u.vmap("!", hacks.search.selectedText)
  u.vmap("*", hacks.search.selectedTextNext)
  u.vmap("#", hacks.search.selectedTextPrevious)
end

local function substitute()
  u.map("b", "<nop>")

  local function getFeedkeys(keys)
    keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
    return function()
      vim.api.nvim_feedkeys(keys, "c", false)
    end
  end

  u.nmap("bu", getFeedkeys(":%s///g<Left><Left><Left>"))
  u.vmap("bu", getFeedkeys(":s///g<Left><Left><Left>"))
  u.nmap("bU", getFeedkeys(":%s///gc<Left><Left><Left><Left>"))
  u.vmap("bU", getFeedkeys(":s///gc<Left><Left><Left><Left>"))

  u.nmap("be", getFeedkeys(":%s/<C-r><C-w>//g<Left><Left>"))
  u.vmap("be", getFeedkeys(":s/<C-r><C-w>//g<Left><Left>"))
  u.nmap("bE", getFeedkeys(":%s/<C-r><C-w>//gc<Left><Left><Left>"))
  u.vmap("bE", getFeedkeys(":s/<C-r><C-w>//gc<Left><Left><Left>"))

  u.nmap("bo", getFeedkeys(":%s/<C-r>y//g<Left><Left>"))
  u.vmap("bo", getFeedkeys(":s/<C-r>y//g<Left><Left>"))
  u.nmap("bO", getFeedkeys(":%s/<C-r>y//gc<Left><Left><Left>"))
  u.vmap("bO", getFeedkeys(":s/<C-r>y//gc<Left><Left><Left>"))
end

local function foldings()
  -- TODO: make foldings
  u.map("x", function() print("make foldings")end)
end

local function improvedRepeat(addPlugin)
  addPlugin('backdround/vim-repeat')

  vim.g.repeat_no_default_key_mappings = 1
  u.nmap(".", "<Plug>(RepeatDot)")
  u.nmap("m", "<Plug>(RepeatUndo)")
  u.nmap("M", "<Plug>(RepeatRedo)")
end

local function misc()
  -- Leader key
  u.map("d", "<nop>")
  vim.g.mapleader = "d"

  -- Macro
  u.nmap(";", "q")
  u.nmap("$", "@")

  -- Language key
  u.imap("<M-c>", "<C-^>")
  u.cmap("<M-c>", "<C-^>")

  -- FilePath command, that prints current file path
  local printCurrentFilePath = function()
    print(vim.fn.expand("%:p"))
  end
  vim.api.nvim_create_user_command("FilePath", printCurrentFilePath, {})

  -- Misc
  vim.opt.pastetoggle = "<F8>"
  u.nmap("_", "<Cmd>write<CR>")
  -- TODO:
  --u.nmap("<leader>r", "<Cmd>source ~/.config/nvim/init.lua<CR>")
end

local function apply(addPlugin)
  misc()
  editing()
  insert()
  visual()
  copyPaste()
  search()
  substitute()
  foldings()
  improvedRepeat(addPlugin)
end

return {
  apply = apply
}
