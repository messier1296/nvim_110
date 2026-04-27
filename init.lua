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
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.o.list = true
vim.o.listchars = "tab:» ,trail:·,nbsp:+"
vim.diagnostic.config {
  update_in_insert = true,
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticLineNrError",
      [vim.diagnostic.severity.WARN] = "DiagnosticLineNrWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticLineNrInfo",
      [vim.diagnostic.severity.HINT] = "DiagnosticLineNrHint",
    },
    linehl = {},
  },
  underline = true,
  severity_sort = true,
  float = { border = "rounded" },
}

vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost" }, {
  pattern = "*",
  command = "silent update",
})

vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-c>", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>T", "<cmd>Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
vim.keymap.set("n", "<C-m>", "<cmd>Neotree reveal<CR>", { desc = "Reveal current file in Neo-tree" })
vim.keymap.set("n", "<leader>b", "<cmd>Neotree float buffers<CR>", { desc = "Open Neo-tree buffers" })
vim.keymap.set("n", "<leader>t", "<Cmd>botright 18split | terminal<CR>", {
  desc = "Open terminal in 18-line split",
})
vim.opt.wrap = true
vim.opt.fileformats = { "unix", "dos", "mac" }
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], { noremap = true, silent = true })
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], { noremap = true, silent = true })
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], { noremap = true, silent = true })
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], { noremap = true, silent = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    local buf = args.buf

    if vim.bo[buf].buftype ~= "" or not vim.bo[buf].modifiable then return end

    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    local changed = false

    for i, line in ipairs(lines) do
      local new = line:gsub("\r", "")
      if new ~= line then
        lines[i] = new
        changed = true
      end
    end

    if changed then vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines) end

    vim.bo[buf].fileformat = "unix"
  end,
})
local zenhan = vim.fn.exepath "zenhan"
if zenhan == "" then zenhan = vim.fn.exepath "zenhan.exe" end
if zenhan ~= "" then
  local group = vim.api.nvim_create_augroup("WslZenhan", { clear = true })

  vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineLeave" }, {
    group = group,
    callback = function() vim.fn.system { zenhan, "0" } end,
  })
end
vim.opt.termguicolors = true
vim.opt.pumblend = 15
vim.opt.winblend = 15
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function() vim.lsp.buf.format { async = false } end,
})
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })

local mode_color = {
  n = { bg = "#0969b0" },
  i = { bg = "#6b8f4e" },
  v = { bg = "#8f4fa8" },
  V = { bg = "#8f4fa8" },
  ["\22"] = { bg = "#8f4fa8" },
  r = { bg = "#d93d3d" },
  R = { bg = "#d93d3d" },
}

vim.api.nvim_create_autocmd({ "ModeChanged", "VimEnter" }, {
  group = vim.api.nvim_create_augroup("ModeCursorLineNr", { clear = true }),
  callback = function()
    local mode = vim.fn.mode()
    local color = mode_color[mode] or mode_color.n
    vim.cmd(string.format("highlight CursorLineNr guibg=%s", color.bg))
  end,
})
