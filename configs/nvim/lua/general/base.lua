local u = require("utilities")
local hacks = require("general.hacks")

local function editing()
  u.map("h", "c", "Change")
  u.map("H", "C", "Change to end of the line")

  u.map("t", "d", "Delete")
  u.map("T", "D", "Delete to end of the line")

  u.map(",", "r", "Replace current character")
  u.map("'", "x", "Delete current character")

  u.map('"', "J", "Join the next line")
end

local function insert()
  -- Enter mode
  u.nmap("g", "i", "Enter insert mode before the cursor")
  u.nmap("G", "I", "Enter insert mode at the start of the line")
  u.nmap("c", "a", "Enter insert mode after the cursor")
  u.nmap("C", "A", "Enter insert mode at the end of the line")

  u.nmap("o<M-b>", "+zei", "Enter insert mode at the start of the line below")
  u.nmap("o<M-f>", "-zei", "Enter insert mode at the start of the line above")
  u.nmap("o<M-.>", "+$a", "Enter insert mode at the end of the line below")
  u.nmap("o<M-r>", "-$a", "Enter insert mode at the end of the line above")

  u.nmap("r", "o", "Enter insert mode in new line below")
  u.nmap("R", "O", "Enter insert mode in new line above")

  -- Editing
  u.imap("<C-t>", "<Esc>cc", "Remove all text on the current line")
  u.imap("<C-d>", "<C-w>", "Remove a word before cursor")
  u.imap("<M-d>", hacks.removeLeftFullWord, "Remove a full word before cursor")
end

local function visual()
  -- Enter mode
  u.nmap("n", hacks.visual.enter, "Enter to visual mode")
  u.nmap("N", "V", "Enter to linewise visual mode")
  u.nmap("<C-n>", "<C-v>", "Enter to block visual mode")

  -- Case switching
  u.xmap("m", "gu", "Make selected text in lower case")
  u.xmap("M", "gU", "Make selected text in upper case")

  -- Swap strat/end
  u.xmap("r", "o", "Swap ends")
end

local function copyPaste()
  -- Normal copy/paste
  u.map("f", '"yy', "Yank operator")
  u.nmap("ff", '"yyy', "Yank the current line")
  u.nmap("F", '"yy$', "Yank to the end of the line")

  u.map("<M-l>", '"yp', "Paste yanked text after the cursor")
  u.map("<M-L>", '"yP', "Paste yanked text before the cursor")

  -- Clipboard copy/paste
  u.map("<leader>f", '"+y', "Yank operator to the clipboard")
  u.nmap("<leader>ff", '"+yy', "Yank the line to the clipboard")
  u.nmap("<leader>fF", '"+y$', "Yank to the end of the line to the clipboard")

  u.map("<leader>l", '"+p', "Paste from the clipboard after the cursor")
  u.map("<leader>L", '"+P', "Paste from the clipboard before the cursor")

  -- Primary copy
  u.map("<leader>F", '"*y', "Yank operator to the primary")
  u.nmap("<leader>Ff", '"*yy', "Yank the current line to the primary")
  u.nmap("<leader>FF", '"*y$', "Yank to the end of the line to the primary")

  -- Unnamed paste
  u.map("l", "p", "Paste from an unnamed register after the cursor")
  u.map("L", "P", "Paste from an unnamed register before the cursor")

  -- Insert paste
  u.imap("<C-l>", '<C-r>"', "Paste from an unnamed register after the cursor")
  u.imap("<M-l>", "<C-r>y", "Paste the yanked text after the cursor")

  -- Highlight yanked area
  u.autocmd("UserHightlightYankedText", "TextYankPost", {
    callback = function()
      vim.highlight.on_yank({
        higroup = "HighlightedyankRegion",
        timeout = 140,
      })
    end,
  })
end

local function search(addPlugin)
  addPlugin("romainl/vim-cool")

  local description = "Search the word under the cursor"
  u.nmap("!", hacks.search.currentWordWithoutMoving, description)
  description = "Search selected word"
  u.xmap("!", hacks.search.selectedText, description)

  description = "Search a next word that matches the word under the cursor"
  u.nmap("*", "g*", description)
  description = "Search a next text that matches selected text"
  u.xmap("*", hacks.search.selectedTextNext, description)

  description = "Search a previous word that matches the word under the cursor"
  u.nmap("#", "g#", description)
  description = "Search a previous text that matches selected text"
  u.xmap("#", hacks.search.selectedTextPrevious, description)

  description = "Search next searched text"
  u.nmap("]", hacks.search.stableNext, description)
  u.xmap("]", hacks.search.stableNext, description)
  local searchNextMap = ':lua require("general.hacks").search.stableNext()<CR>'
  u.omap("]", searchNextMap, description)

  description = "Search previous searched text"
  u.nmap("[", hacks.search.stablePrevious, description)
  u.xmap("[", hacks.search.stablePrevious, description)
  local searchPreviousMap =
    ':lua require("general.hacks").search.stablePrevious()<CR>'
  u.omap("[", searchPreviousMap, description)
end

local function substitute()
  u.map("b", "<nop>", "Change key")

  local function getFeedkeys(keys)
    keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
    return function()
      vim.api.nvim_feedkeys(keys, "c", false)
    end
  end

  local description = "Replace any text to another text"
  u.nmap("bu", getFeedkeys(":%s///g<Left><Left><Left>"), description)
  u.xmap("bu", getFeedkeys(":s///g<Left><Left><Left>"), description)
  description = description .. " with confirmation"
  u.nmap("bU", getFeedkeys(":%s///gc<Left><Left><Left><Left>"), description)
  u.xmap("bU", getFeedkeys(":s///gc<Left><Left><Left><Left>"), description)

  description = "Replace text under the cursor to another text"
  u.nmap("be", getFeedkeys(":%s/<C-r><C-w>//g<Left><Left>"), description)
  u.xmap("be", getFeedkeys(":s/<C-r><C-w>//g<Left><Left>"), description)
  description = description .. " with confirmation"
  u.nmap("bE", getFeedkeys(":%s/<C-r><C-w>//gc<Left><Left><Left>"), description)
  u.xmap("bE", getFeedkeys(":s/<C-r><C-w>//gc<Left><Left><Left>"), description)

  description = "Replace yanked text to another text"
  u.nmap("bo", getFeedkeys(":%s/<C-r>y//g<Left><Left>"), description)
  u.xmap("bo", getFeedkeys(":s/<C-r>y//g<Left><Left>"), description)
  description = description .. " with confirmation"
  u.nmap("bO", getFeedkeys(":%s/<C-r>y//gc<Left><Left><Left>"), description)
  u.xmap("bO", getFeedkeys(":s/<C-r>y//gc<Left><Left><Left>"), description)
end

local function foldings()
  -- TODO: make foldings
  u.map("x", function()
    print("make foldings")
  end, "Jump / fold key")
end

local function improvedRepeat(addPlugin)
  addPlugin("backdround/vim-repeat")

  vim.g.repeat_no_default_key_mappings = 1
  u.nmap(".", "<Plug>(RepeatDot)", "Repeat action")
  u.nmap("m", "<Plug>(RepeatUndo)", "Undo action")
  u.nmap("M", "<Plug>(RepeatRedo)", "Redo action")
end

local function commands()
  -- FilePath command, that prints current file path
  local printCurrentFilePath = function()
    print(vim.fn.expand("%:p"))
  end
  vim.api.nvim_create_user_command("FilePath", printCurrentFilePath, {})

  -- Normal command that expands key notation like "<esc>", "<left>" and so on.
  vim.api.nvim_create_user_command("Normal", function(opts)
    local userSequence =
      vim.api.nvim_replace_termcodes(opts.args, true, true, true)
    local bangSymbol = opts.bang and "!" or ""
    local command = string.format(
      "%s,%snormal%s %s",
      opts.line1,
      opts.line2,
      bangSymbol,
      userSequence
    )
    vim.cmd(command)
  end, {
    bang = true,
    range = true,
    nargs = 1,
  })
  vim.cmd(":cabbrev N Normal")
end

local function misc()
  -- Leader key
  u.map("d", "<nop>", "Leader")
  vim.g.mapleader = "d"

  -- Macro
  u.nmap(";", "q", "Record macro")
  u.nmap("$", "@", "Perform macro")

  -- Language key
  u.imap("<M-c>", "<C-^>", "Toggle language")
  u.cmap("<M-c>", "<C-^>", "Toggle language")

  -- Misc
  vim.opt.pastetoggle = "<F8>"
  u.nmap("_", "<Cmd>write<CR>", "Write buffer")
  u.map("<2-LeftMouse>", "<nop>", "Don't do anything")
end

local function apply(addPlugin)
  misc()
  editing()
  insert()
  visual()
  copyPaste()
  search(addPlugin)
  substitute()
  foldings()
  improvedRepeat(addPlugin)
  commands()
end

return {
  apply = apply,
}
