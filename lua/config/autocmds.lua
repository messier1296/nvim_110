vim.api.nvim_create_autocmd({ "InsertLeave", "FocusLost" }, {
  pattern = "*",
  command = "silent update",
})

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

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function() vim.lsp.buf.format { async = false } end,
})
