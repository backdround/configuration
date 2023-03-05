local u = require("utilities")

local function splits()
  u.nmap("s", "<nop>", "Split key")

  -- Creation
  u.nmap("s<M-i>", "<Cmd>tabnew<CR>", "New split in new tab")
  u.nmap("s<M-u>", "<Cmd>vsplit<CR>", "New vertical split")
  u.nmap("s<M-e>", "<Cmd>split<CR>", "New horisontal split")

  -- Focusing
  u.nmap("so", "<C-w>h", "Move focus to the left split")
  u.nmap("se", "<C-w>j", "Move focus to the down split")
  u.nmap("su", "<C-w>k", "Move focus to the up split")
  u.nmap("si", "<C-w>l", "Move focus to the right split")

  -- Movement
  u.nmap("sO", "<C-w>H", "Move current split to the right side")
  u.nmap("sE", "<C-w>J", "Move current split to the bottom side")
  u.nmap("sU", "<C-w>K", "Move current split to the up side")
  u.nmap("sI", "<C-w>L", "Move current split to the left side")

  -- Changing size
  u.nmap("ss", "<C-w>=", "Align splits")
  u.nmap("s|", "<C-w>|", "Change split width size")
  u.nmap("s_", "<C-w>_", "Change split height size")
  -- TODO: Use counter = 7/9, when counter is't set
  u.nmap("s+", "<C-w>+", "Increase split height")
  u.nmap("s-", "<C-w>-", "Decrease split height")
  u.nmap("s>", "<C-w>>", "Increase split width")
  u.nmap("s<", "<C-w><", "Decrease split width")

  -- Closing
  u.nmap("sq", "<Cmd>quit<CR>", "Close split")
  u.nmap("<M-x>", "<Cmd>x<CR>", "Save and close split")
  u.imap("<M-x>", "<Cmd>x<CR>", "Save and close split")
end

local function tabs()
  u.nmap("v", "<nop>", "Tab key")

  -- Creation
  u.nmap("vo", "<Cmd>Startify<CR>", "Open greeter in the current split")
  u.nmap("vi", "<Cmd>tabnew +Startify<CR>", "Open greeter in a new tab")
  local description =
    "Open the current buffer at the new tab and restore the previous buffer back"
  u.nmap("v<M-i>", "<Cmd>buffer # | tabnew +buffer #<CR>", description)

  -- Focusing
  u.nmap("ve", "gT", "Focus previous tab")
  u.nmap("vu", "gt", "Focus next tab")
  u.nmap("v1", "<Cmd>tabfirst<CR>", "Focus the first tab")
  u.nmap("v0", "<Cmd>tablast<CR>", "Focus the last tab")

  -- Movement
  description = "Move the current tab forward"
  u.nmap("vp", "<Cmd>execute 'tabmove +' . v:count1<CR>", description)
  description = "Move the current tab backward"
  u.nmap("vs", "<Cmd>execute 'tabmove -' . v:count1<CR>", description)

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

  description = "Close the current tab or exit if the tab is last"
  u.nmap("vq", getCloseTabOrQuit(false), description)
  description = "Close the current tab or exit if the tab is last with force"
  u.nmap("vQ", getCloseTabOrQuit(true), description)

  u.nmap("vx", "<Cmd>quitall<CR>", "Close neovim")
  u.nmap("vX", "<Cmd>quitall!<CR>", "Close neovim with force")
end

local function buffers(addPlugin)
  u.nmap("<M-u>", "<Cmd>:bnext<CR>", "Switch to next buffer")
  u.nmap("<M-e>", "<Cmd>:bprevious<CR>", "Switch to previous buffer")

  addPlugin({
    "famiu/bufdelete.nvim",
    config = function()
      local bufdelete = require("bufdelete").bufdelete
      u.nmap("<M-o>", u.wrap(bufdelete, 0), "Remove current buffer")
      u.nmap("<S-M-o>", u.wrap(bufdelete, 0, true), "Remove current buffer with force")
    end
  })
end

local function apply(addPlugin)
  splits()
  tabs()
  buffers(addPlugin)
end

return {
  apply = apply,
}
