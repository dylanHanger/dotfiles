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
      vim.list_extend(opts.ensure_installed, { "pyright", "black", "isort", "flake8" })
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
      -- FIXME: Path to python with DebugPy installed
      -- I think this should be using the Mason path
      require("dap-python").setup("/usr/bin/python")
    end,
  },

  -- correctly setup neotest adapter
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        require("neotest-python")({
          dap = { justMyCode = false },
        }),
      })
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      setup = {
        -- TODO: Keybindings and stuff I suppose?
      },
    },
  },
}
