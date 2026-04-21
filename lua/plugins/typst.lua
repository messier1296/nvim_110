return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      lspconfig.tinymist.setup({
        root_dir = util.root_pattern(".git", "main.typ"),
        settings = {
          formatterMode = "typstyle",
          exportPdf = "onSave",
        },
      })
    end,
  },

  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    opts = {},
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
