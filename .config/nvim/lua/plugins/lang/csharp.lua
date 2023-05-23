-- https://github.com/appelgriebsch/Nv/blob/main/lua/plugins/extras/lang/rust.lua
return {
  -- add c# to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "c_sharp" })
      -- TODO: Use HTML for XML files?
    end,
  },

  -- correctly setup mason lsp extensions
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "omnisharp" })
    end,
  },

  -- correctly setup mason dap extensions
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "netcoredbg" })
    end,
  },

  -- correctly setup neotest adapter
  {
    "nvim-neotest/neotest",
    dependencies = {
      "Issafalcon/neotest-dotnet",
    },
    opts = {
      adapters = {
        ["neotest-dotnet"] = {
          dap = { justMyCode = true },
          discovery_root = "project", -- "project" | "solution"
        },
      },
    },
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      setup = {},
    },
  },
}
