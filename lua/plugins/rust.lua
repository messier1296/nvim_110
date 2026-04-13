return {
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    ft = { "rust" },
    init = function()
      ---@type rustaceanvim.Opts
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr)
            -- rust-analyzer codelens updates appear to interfere with insert-mode
            -- input in this environment, so keep Rust LSP/completion active but
            -- disable codelens for Rust buffers.
            client.server_capabilities.codeLensProvider = nil
            if vim.lsp.codelens and vim.lsp.codelens.enable then vim.lsp.codelens.enable(false, { bufnr = bufnr }) end
            if vim.lsp.inlay_hint then vim.lsp.inlay_hint.enable(true, { bufnr = bufnr }) end
          end,
          default_settings = {
            ["rust-analyzer"] = {
              check = {
                command = "clippy",
              },
              cargo = {
                allFeatures = true,
              },
              inlayHints = {
                typeHints = {
                  enable = true,
                },
                parameterHints = {
                  enable = true,
                },
                chainingHints = {
                  enable = true,
                },
              },
            },
          },
        },
      }
    end,
  },
}
