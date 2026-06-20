vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.mouse = "a"
if vim.fn.has "wsl" == 1 and vim.fn.executable "win32yank.exe" == 1 then
  vim.g.clipboard = {
    name = "win32yank",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 0,
  }
end
vim.opt.clipboard = "unnamedplus"
vim.opt.wrap = true
vim.opt.fileformats = { "unix", "dos", "mac" }
vim.opt.termguicolors = true
vim.opt.pumblend = 15
vim.opt.winblend = 15
vim.opt.encoding = "utf-8"
vim.opt.fileencodings = "ucs-bom,utf-8,cp932,sjis,euc-jp,latin1"
vim.o.list = true
vim.o.listchars = "tab:» ,trail:·,nbsp:+"
