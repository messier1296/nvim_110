return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require "lspconfig"
      local util = require "lspconfig.util"
      local function resolve_typst_root(fname)
        return util.root_pattern("typst.toml", ".git", ".codex")(fname)
          or vim.fs.dirname(vim.fn.fnamemodify(fname, ":p"))
      end

      lspconfig.tinymist.setup {
        root_dir = resolve_typst_root,
        on_new_config = function(new_config, root_dir)
          new_config.settings = new_config.settings or {}
          new_config.settings.tinymist = vim.tbl_deep_extend("force", new_config.settings.tinymist or {}, {
            rootPath = root_dir,
          })
        end,
        settings = {
          tinymist = {
            formatterMode = "typstyle",
            exportPdf = "onSave",
          },
        },
      }
    end,
  },

  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    opts = function()
      local util = require "lspconfig.util"
      local function resolve_typst_root(path)
        return util.root_pattern("typst.toml", ".git", ".codex")(path)
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
