return {
  -- add python to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "python" })
    end,
  },

  -- correctly setup mason lsp extensions
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "pyright", "black", "isort", "ruff-lsp" })
    end,
  },

  -- correctly setup mason dap extensions
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "debugpy" })
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function(_, _)
      -- Path to python with DebugPy installed
      require("dap-python").setup("/usr/bin/python")
    end,
  },

  -- correctly setup neotest adapter
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          dap = { justMyCode = true },
        },
      },
    },
  },

  -- null-ls custom config.
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      local nls_formatting = nls.builtins.formatting
      local formatting = {
        -- Formatters
        nls_formatting.isort.with({ filetypes = { "python" }, command = "isort" }),
        nls_formatting.black.with({ filetypes = { "python" }, command = "black" }),
      }
      if type(opts.sources) == "table" then
        opts.sources = vim.list_extend(opts.sources, formatting)
      end
      opts.debug = true
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      ---@type lspconfig.options
      servers = {
        pyright = {
          handlers = {
            ["textDocument/publishDiagnostics"] = function() end,
          },
          on_attach = function(client, _)
            -- Defer to Ruff for code actions and linting
            client.server_capabilities.codeActionProvider = false
            client.server_capabilities.diagnosticProvider = false
          end,
          settings = {
            pyright = {
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                autoSearchPaths = true,
                typeCheckingMode = "basic",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        ruff_lsp = {
          on_attach = function(client, _)
            -- Defer to PyRight for hover
            client.server_capabilities.hoverProvider = false
          end,
        },
      },
    },
  },
}
