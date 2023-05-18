return {
  -- add latex to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "latex", "bibtex" })
    end,
  },

  -- correctly setup mason lsp extensions
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      -- TODO: consider Vale, chktex, latexindent (for use with null-ls)
      vim.list_extend(opts.ensure_installed, { "texlab" })
    end,
  },

  -- TODO: https://github.com/lervag/vimtex
  -- What does it offer over texlab?
  -- How do I integrate it with texlab?
  -- TODO: https://github.com/frabjous/knap?
  -- Is it necessary?

  -- null-ls custom config.
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      local nls_diagnostics = nls.builtins.diagnostics
      local nls_formatting = nls.builtins.formatting
      local diagnostics = {
        -- Linters
      }
      local formatting = {
        -- Formatters
      }
      if type(opts.sources) == "table" then
        opts.sources = vim.list_extend(opts.sources, diagnostics)
        opts.sources = vim.list_extend(opts.sources, formatting)
      end
      opts.debug = true
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        texlab = function(_, opts)
          -- TODO: Setup build request and forward search
          require("lazyvim.util").on_attach(function(client, buffer)
            vim.keymap.set("n", "<leader>cb", function()
              client.request("workspace/executeCommand", {})
            end, { desc = "Build" })
          end)
          return false
        end,
      },
    },
  },
}
