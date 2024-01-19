local u = require("utilities")
local hacks = require("general.hacks")

local function editing()
  u.map("h", "c", "Change")
  u.adapted_map("nx", "H", "C", "Change to end of the line")

  u.map("t", "d", "Delete")
  u.adapted_map("nx", "T", "D", "Delete to end of the line")

  u.adapted_map("nx", ",", "r", "Replace current character")
  u.nmap("<Bs>", "X", "Delete previous character")
  u.nmap("<Del>", "x", "Delete current character")

  local join_several = ":<C-u>execute 'normal! ' . (v:count1 + 1) . 'J'<CR>"
  u.nmap('"', join_several, "Join the next lines (v:count)")
  u.xmap('"', "J", "Join the next line")
end

local function insert()
  local insert_mode = function()
    local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
    local current_line =
      vim.api.nvim_buf_get_lines(0, cursor_line - 1, cursor_line, true)[1]
    if current_line:len() == 0 then
      u.feedkeys(vim.v.count1 .. "a<C-f>", "ni")
    else
      u.feedkeys(vim.v.count1 .. "a", "ni")
    end
  end

  -- selene: allow(global_usage)
  _G.Insert_lines_below = function()
    local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
    local current_line =
      vim.api.nvim_buf_get_lines(0, cursor_line - 1, cursor_line, true)[1]

    local new_lines = { current_line }
    for _ = 1, vim.v.count1 do
      table.insert(new_lines, "")
    end

    vim.api.nvim_buf_set_lines(0, cursor_line - 1, cursor_line, true, new_lines)
  end

  local insert_lines_below = function()
    vim.opt.operatorfunc = "v:lua.Insert_lines_below"
    return "g@$"
  end

  -- Enter mode
  u.nmap("g", "i", "Enter insert mode before the cursor")
  u.nmap("G", "I", "Enter insert mode at the start of the line")
  u.nmap("c", insert_mode, "Enter insert mode after the cursor")
  u.nmap("C", "A", "Enter insert mode at the end of the line")

  u.nmap("oB", "+zei", "Enter insert mode at the start of the line below")
  u.nmap("oF", "-zei", "Enter insert mode at the start of the line above")
  u.nmap("o>", "+$a", "Enter insert mode at the end of the line below")
  u.nmap("oR", "-$a", "Enter insert mode at the end of the line above")

  u.nmap("<C-r>", insert_lines_below, {
    desc = "Insert v:count lines below",
    expr = true,
  })
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
  -- Copy
  u.map("f", 'y', "Yank operator")
  u.nmap("F", 'y$', "Yank operator")
  u.nmap("ff", 'yy', "Yank the current line")

  -- Copy all yanked text to all os buffers.
  u.autocmd("UserPutYankedTextInOsBuffers", "TextYankPost", {
    callback = function()
      if vim.v.event.operator ~= "y" then
        return
      end
      local yanked_text = vim.fn.getreg("0")
      vim.fn.setreg("+", yanked_text)
      vim.fn.setreg("*", yanked_text)
    end,
  })

  -- Paste
  u.nmap("l", "p", "Paste unnamed text after the cursor")
  u.nmap("L", "P", "Paste unnamed text before the cursor")
  u.xmap("l", "p", "Replace by unnamed text")

  u.nmap("<M-l>", '"+p', "Paste yanked text after the cursor")
  u.nmap("<M-L>", '"+P', "Paste yanked text before the cursor")
  u.xmap("<M-l>", '"+p', "Replace by yanked text")

  local get_smart_insert = function(regname)
    return function()
      u.feedkeys("<C-r><C-p>" .. regname, "ni")

      if vim.fn.getreg(regname):sub(-1) ~= "\n" then
        return
      end

      vim.schedule(function()
        local line = vim.api.nvim_get_current_line()
        local cursor_position = vim.api.nvim_win_get_cursor(0)
        cursor_position[2] = line:len()
        vim.api.nvim_win_set_cursor(0, cursor_position)
      end)
    end
  end

  u.imap("<C-l>", get_smart_insert('"'), "Paste unnamed register")
  u.imap("<M-l>", get_smart_insert("+"), "Paste yanked text")

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

local function search(plugin_manager)
  plugin_manager.add("romainl/vim-cool")

  plugin_manager.add({
    url = "git@github.com:backdround/improved-search.nvim.git",
    keys = hacks.lazy.generate_keys("nxo", { "!", "*", "#", "[", "]" }),
    config = function()
      local is = require("improved-search")
      local description = "Search the word under the cursor"
      u.nmap("!", is.current_word, description)

      description = "Search selected word"
      u.xmap("!", is.in_place, description)
      u.nmap("|", is.in_place, description)

      description = "Search a next word that matches the word under the cursor"
      u.nmap("*", "g*", description)
      u.omap("*", "g*", description)
      description = "Search a next text that matches selected text"
      u.xmap("*", is.forward, description)

      description = "Search a previous word that matches the word under the cursor"
      u.nmap("#", "g#", description)
      u.omap("#", "g#", description)
      description = "Search a previous text that matches selected text"
      u.xmap("#", is.backward, description)

      description = "Search next searched text"
      u.map("]", is.stable_next, description)
      description = "Search previous searched text"
      u.map("[", is.stable_previous, description)
    end
  })
end

local function substitute()
  u.map("b", "<nop>", "Change key")

  local function get_feedkeys(keys, go_left_amount)
    local lefts = u.replace_termcodes("<Left>")
    lefts = lefts:rep(go_left_amount or 0, "")

    keys = u.replace_termcodes(keys)
    keys = keys .. lefts
    return function()
      vim.api.nvim_feedkeys(keys, "n", false)
    end
  end

  local description = "Replace any text to another text"
  u.nmap("bu", get_feedkeys(":%s///g", 3), description)
  u.xmap("bu", get_feedkeys(":s///g", 3), description)
  description = description .. " with confirmation"
  u.nmap("bU", get_feedkeys(":%s///gc", 4), description)
  u.xmap("bU", get_feedkeys(":s///gc", 4), description)

  description = "Replace yanked text to another text"
  u.nmap("be", get_feedkeys(":%s/<C-r>y//g", 2), description)
  u.xmap("be", get_feedkeys(":s/<C-r>y//g", 2), description)
  description = description .. " with confirmation"
  u.nmap("bE", get_feedkeys(":%s/<C-r>y//gc", 3), description)
  u.xmap("bE", get_feedkeys(":s/<C-r>y//gc", 3), description)

  description = "Replace text under the cursor to another text"
  u.nmap("bo", get_feedkeys(":%s/<C-r><C-w>//g", 2), description)
  description = description .. " with confirmation"
  u.nmap("bO", get_feedkeys(":%s/<C-r><C-w>//gc", 3), description)
end

local function foldings()
  u.map("x", "<Nop>", "Jump / fold key")
  u.adapted_map("nx", "xo", "zo", "Open a folding")
  u.adapted_map("nx", "xe", "zc", "Close a folding")
  u.adapted_map("nx", "x<M-o>", "zO", "Open all folding under the cursor")
  u.adapted_map("nx", "x<M-e>", "zC", "Close all folding under the cursor")
  u.adapted_map("nx", "xO", "zR", "Open all foldings")
  u.adapted_map("nx", "xE", "zM", "Close all foldings")

  u.adapted_map("nx", "xu", "zf", "Create a folding")
  u.adapted_map("nx", "xi", "zd", "Delete a folding")
end

local function improved_repeat(plugin_manager)
  plugin_manager.add("backdround/vim-repeat")

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
    local user_sequence = u.replace_termcodes(opts.args)
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

  -- Indentation
  u.map("<C-b>", "=", "Indentation operator")
  u.imap("<C-b>", "<C-f>", "Indent line")

  -- Language key
  u.imap("<M-c>", "<C-^>", "Toggle language")
  u.cmap("<M-c>", "<C-^>", "Toggle language")

  -- Misc
  u.nmap("_", "<Cmd>write<CR>", "Write buffer")
  u.adapted_map("nx", "<C-d>", '"', "Use a register")
  u.adapted_map("ci", "<C-d>", '<C-r>', "Use a register")

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

local function commandline()
  u.cmap("<M-s>", "<C-c>", "Close command-line")
  u.cmap("<M-o>", "<CR>", "Accept command")
end

---@param plugin_manager UserPluginManager
local function apply(plugin_manager)
  misc()
  editing()
  insert()
  visual()
  copy_paste()
  search(plugin_manager)
  substitute()
  foldings()
  improved_repeat(plugin_manager)
  commands()
  commandline()
end

return {
  apply = apply,
}
