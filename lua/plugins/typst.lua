return {
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    opts = function()
      local function resolve_typst_root(path)
        return vim.fs.root(path, { "typst.toml", ".git", "template.typ" })
          or vim.fs.dirname(vim.fn.fnamemodify(path, ":p"))
      end

      return {
        dependencies_bin = {
          tinymist = "tinymist",
        },
        get_root = resolve_typst_root,
      }
    end,
    config = function(_, opts)
      require("typst-preview").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "typst",
        callback = function(args)
          vim.keymap.set("n", "<leader>tp", "<cmd>TypstPreview<CR>", {
            buffer = args.buf,
            desc = "Typst Preview",
          })
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "typst")
    end,
  },
}
