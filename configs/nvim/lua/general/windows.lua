local u = require("utilities")

local function splits()
  u.nmap("s", "<nop>")

  -- Creation
  u.nmap("s<M-i>", "<Cmd>tabnew<CR>")
  u.nmap("s<M-u>", "<Cmd>vsplit<CR>")
  u.nmap("s<M-e>", "<Cmd>split<CR>")

  -- Focusing
  u.nmap("so", "<C-w>h")
  u.nmap("se", "<C-w>j")
  u.nmap("su", "<C-w>k")
  u.nmap("si", "<C-w>l")

  -- Movement
  u.nmap("sO", "<C-w>H")
  u.nmap("sE", "<C-w>J")
  u.nmap("sU", "<C-w>K")
  u.nmap("sI", "<C-w>L")

  -- Changing size
  u.nmap("ss", "<C-w>=")
  u.nmap("s|", "<C-w>|")
  u.nmap("s_", "<C-w>_")
  -- TODO: Use counter = 7/9, when counter is't set
  u.nmap("s+", "<C-w>+")
  u.nmap("s-", "<C-w>-")
  u.nmap("s<", "<C-w><")
  u.nmap("s>", "<C-w>>")

  -- Closing
  u.nmap("sq", "<Cmd>quit<CR>")
  u.nmap("sQ", "<Cmd>quit!<CR>")
  u.nmap("<M-x>", "<Cmd>x<CR>")
  u.imap("<M-x>", "<Cmd>x<CR>")
end

local function tabs()
  u.nmap("v", "<nop>")

  -- Creation
  u.nmap("vo", "<Cmd>Startify<CR>")
  u.nmap("vi", "<Cmd>tabnew +Startify<CR>")
  u.nmap("v<M-i>", "<Cmd>buffer # | tabnew +buffer #<CR>")

  -- Focusing
  u.nmap("ve", "gT")
  u.nmap("vu", "gt")
  u.nmap("v1", "<Cmd>tabfirst<CR>")
  u.nmap("v0", "<Cmd>tablast<CR>")

  -- Movement
  u.nmap("vs", "<Cmd>execute 'tabmove -' . v:count1<CR>")
  u.nmap("vp", "<Cmd>execute 'tabmove +' . v:count1<CR>")

  -- Closing
  local function getCloseTabOrQuit(force)
    return function()
      if #vim.api.nvim_list_tabpages() == 1 then
        vim.cmd(force and "quitall!" or "quitall")
      else
        vim.cmd(force and "tabclose!" or "tabclose")
      end
    end
  end

  u.nmap("vq", getCloseTabOrQuit(false))
  u.nmap("vQ", getCloseTabOrQuit(true))

  u.nmap("vx", "<Cmd>quitall<CR>")
  u.nmap("vX", "<Cmd>quitall!<CR>")
end

local function apply()
  splits()
  tabs()
end

return {
  apply = apply,
}
