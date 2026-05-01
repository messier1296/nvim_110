vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

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
