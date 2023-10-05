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
  u.imap("<C-h>", hacks.delete_word.left, "Remove a word before cursor")
  u.imap( "<C-M-h>",
    hacks.delete_word.full_left,
    "Delete a full word before cursor"
  )
  u.imap("<C-n>", hacks.delete_word.right, "Remove a word after cursor")
  u.imap( "<C-M-n>",
    hacks.delete_word.full_right,
    "Delete a full word before cursor"
  )
end

local function visual()
  -- Enter mode
  u.nmap("n", hacks.visual.v, "Enter to visual mode")
  u.nmap("N", hacks.visual.V, "Enter to linewise visual mode")
  u.nmap("<C-n>", hacks.visual.b, "Enter to block visual mode")

  -- Case switching
  u.xmap("m", "gu", "Make selected text in lower case")
  u.xmap("M", "gU", "Make selected text in upper case")

  -- Swap strat/end
  u.xmap("r", "o", "Swap ends")
end

local function copy_paste()
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
        timeout = 80,
      })
    end,
  })
end

local function search(add_plugin)
  add_plugin("romainl/vim-cool")

  local description = "Search the word under the cursor"
  u.nmap("!", hacks.search.current_word_without_moving, description)
  description = "Search selected word"
  u.xmap("!", hacks.search.selected_text, description)

  description = "Search a next word that matches the word under the cursor"
  u.nmap("*", "g*", description)
  description = "Search a next text that matches selected text"
  u.xmap("*", hacks.search.selected_text_next, description)

  description = "Search a previous word that matches the word under the cursor"
  u.nmap("#", "g#", description)
  description = "Search a previous text that matches selected text"
  u.xmap("#", hacks.search.selected_text_previous, description)

  description = "Search next searched text"
  u.nmap("]", hacks.search.stable_next, description)
  u.xmap("]", hacks.search.stable_next, description)
  local search_next_map =
    ':lua require("general.hacks").search.stable_next()<CR>'
  u.omap("]", search_next_map, description)

  description = "Search previous searched text"
  u.nmap("[", hacks.search.stable_previous, description)
  u.xmap("[", hacks.search.stable_previous, description)
  local search_previous_map =
    ':lua require("general.hacks").search.stable_previous()<CR>'
  u.omap("[", search_previous_map, description)
end

local function substitute()
  u.map("b", "<nop>", "Change key")

  local function get_feedkeys(keys)
    keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
    return function()
      vim.api.nvim_feedkeys(keys, "c", false)
    end
  end

  local description = "Replace any text to another text"
  u.nmap("bu", get_feedkeys(":%s///g<Left><Left><Left>"), description)
  u.xmap("bu", get_feedkeys(":s///g<Left><Left><Left>"), description)
  description = description .. " with confirmation"
  u.nmap("bU", get_feedkeys(":%s///gc<Left><Left><Left><Left>"), description)
  u.xmap("bU", get_feedkeys(":s///gc<Left><Left><Left><Left>"), description)

  description = "Replace text under the cursor to another text"
  u.nmap("be", get_feedkeys(":%s/<C-r><C-w>//g<Left><Left>"), description)
  description = description .. " with confirmation"
  u.nmap(
    "bE",
    get_feedkeys(":%s/<C-r><C-w>//gc<Left><Left><Left>"),
    description
  )

  description = "Replace yanked text to another text"
  u.nmap("bo", get_feedkeys(":%s/<C-r>y//g<Left><Left>"), description)
  u.xmap("bo", get_feedkeys(":s/<C-r>y//g<Left><Left>"), description)
  description = description .. " with confirmation"
  u.nmap("bO", get_feedkeys(":%s/<C-r>y//gc<Left><Left><Left>"), description)
  u.xmap("bO", get_feedkeys(":s/<C-r>y//gc<Left><Left><Left>"), description)
end

local function foldings()
  -- TODO: make foldings
  u.map("x", function()
    print("make foldings")
  end, "Jump / fold key")
end

local function improved_repeat(add_plugin)
  add_plugin("backdround/vim-repeat")

  vim.g.repeat_no_default_key_mappings = 1
  u.nmap(".", "<Plug>(RepeatDot)", "Repeat action")
  u.nmap("m", "<Plug>(RepeatUndo)", "Undo action")
  u.nmap("M", "<Plug>(RepeatRedo)", "Redo action")
end

local function commands()
  -- file_path command, that prints current file path
  local print_current_file_path = function()
    print(vim.fn.expand("%:p"))
  end
  vim.api.nvim_create_user_command("FilePath", print_current_file_path, {})

  -- Normal command that expands key notation like "<esc>", "<left>" and so on.
  vim.api.nvim_create_user_command("Normal", function(opts)
    local user_sequence =
      vim.api.nvim_replace_termcodes(opts.args, true, true, true)
    local bang_symbol = opts.bang and "!" or ""
    local command = string.format(
      "%s,%snormal%s %s",
      opts.line1,
      opts.line2,
      bang_symbol,
      user_sequence
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

  local maps_to_disable = {
    "<MiddleMouse>",
    "<2-MiddleMouse>",
    "<3-MiddleMouse>",
    "<4-MiddleMouse>",
    "<RightMouse>",
    "<2-RightMouse>",
    "<3-RightMouse>",
    "<4-RightMouse>",
  }
  for _, map in ipairs(maps_to_disable) do
    u.map(map, "<nop>", "Don't do anything")
  end
end

local function apply(add_plugin)
  misc()
  editing()
  insert()
  visual()
  copy_paste()
  search(add_plugin)
  substitute()
  foldings()
  improved_repeat(add_plugin)
  commands()
end

return {
  apply = apply,
}
