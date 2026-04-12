-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  local result = vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
  if vim.v.shell_error ~= 0 then
    -- stylua: ignore
    vim.api.nvim_echo({ { ("Error cloning lazy.nvim:\n%s\n"):format(result), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
    vim.fn.getchar()
    vim.cmd.quit()
  end
end

vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

require "lazy_setup"
require "polish"
vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = t
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.keymap.set("n", "<leader>ev", "<cmd>edit $MYVIMRC<CR>", { desc = "Open init.lua" })
vim.keymap.set("n", "<leader>sv", "<cmd>source $MYVIMRC<CR>", { desc = "Source init.lua" })
vim.diagnostic.config({
  update_in_insert = true,
  virtual_text = true,
  underline = true,
  signs = true,
})

vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost" }, {
  pattern = "*",
  command = "silent update",
})

vim.keymap.set("i","jj","<Esc>",{noremap = true,silent = true})
vim.keymap.set("n", "<leader>t", "<cmd>Neotree toggle<CR>")
vim.keymap.set("n", "<C-m>", "<cmd>Neotree reveal<CR>")
vim.keymap.set("n", "<leader>b", "<cmd>Neotree float buffers<CR>")
vim.keymap.set("n", "<leader>t", "<Cmd>botright 18split | terminal<CR>", {
  desc = "Open terminal in 18-line split",
})
vim.opt.wrap = true
vim.opt.fileformats = { "unix", "dos", "mac" }
vim.keymap.set("t","<Esc>",[[<C-\><C-n>]], {noremap = true,silent = true})
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { noremap = true, silent = true })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { noremap = true, silent = true })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { noremap = true, silent = true })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { noremap = true, silent = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    local buf = args.buf

    if vim.bo[buf].buftype ~= "" or not vim.bo[buf].modifiable then
      return
    end

    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local changed = false

    for i, line in ipairs(lines) do
      local new = line:gsub("\r", "")
      if new ~= line then
        lines[i] = new
        changed = true
      end
    end

    if changed then
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    end

    vim.bo[buf].fileformat = "unix"
  end,
})
local zenhan = vim.fn.exepath("zenhan")
if zenhan ~= "" then
  local group = vim.api.nvim_create_augroup("WslZenhan", { clear = true })

  vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineLeave" }, {
    group = group,
    callback = function()
      vim.fn.system({ zenhan, "0" })
    end,
  })
end
vim.opt.termguicolors = true
vim.opt.pumblend = 15
vim.opt.winblend = 15
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.rs",
    callback = function()
      vim.lsp.buf.format({ async = false })
    end,
  })
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
