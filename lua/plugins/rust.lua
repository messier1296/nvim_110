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
              checkOnSave = {
                command = "clippy",
                extraArgs = { "--all", "--", "-W", "clippy::all" },
              },
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = { enable = true },
              },
              procMacro = {
                enable = true,
                attributes = { enable = true },
              },
              inlayHints = {
                enable = true,
                chainingHints = { enable = true },
                typeHints = { enable = true, hideClosureInitialization = true },
                parameterHints = { enable = true },
                closureReturnTypeHints = { enable = "with_block" },
                lifetimeElisionHints = { enable = "skip_trivial", useParameterNames = true },
                maxLength = 25,
                bindingModeHints = { enable = true },
                closureCaptureHints = { enable = true },
                discriminantHints = { enable = "fieldless" },
                expressionAdjustmentHints = { enable = "reborrow" },
                rangeExclusiveHints = { enable = true },
              },
              completion = {
                autoimport = { enable = true },
                postfix = { enable = true },
                callable = { snippets = "fill_arguments" },
                fullFunctionSignatures = { enable = true },
                privateEditable = { enable = true },
              },
              imports = {
                granularity = { group = "module" },
                prefix = "self",
              },
              diagnostics = {
                enable = true,
                experimental = { enable = true },
                styleLints = { enable = true },
              },
              semanticHighlighting = {
                operator = { specialization = { enable = true } },
                punctuation = { enable = true, specialization = { enable = true } },
                strings = { enable = true },
              },
              hover = {
                actions = {
                  enable = true,
                  references = { enable = true },
                  run = { enable = true },
                  debug = { enable = true },
                  gotoTypeDef = { enable = true },
                  implementations = { enable = true },
                },
                documentation = { enable = true, keywords = { enable = true } },
                links = { enable = true },
              },
              typing = {
                autoClosingAngleBrackets = { enable = true },
              },
              lens = {
                enable = true,
                references = {
                  enable = true,
                  adt = { enable = true },
                  enumVariant = { enable = true },
                  method = { enable = true },
                  trait = { enable = true },
                },
                implementations = { enable = true },
                run = { enable = true },
                debug = { enable = true },
              },
              workspace = {
                symbol = { search = { kind = "all_symbols" } },
              },
              check = {
                command = "clippy",
                extraArgs = { "--all", "--", "-W", "clippy::all" },
              },
            },
          },
        },
      }
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.rust = { "rustfmt", lsp_format = "fallback" }
      opts.format_on_save = function(bufnr)
        if vim.bo[bufnr].filetype == "rust" then
          return { timeout_ms = 500, lsp_format = "fallback" }
        end
      end
    end,
  },
}
