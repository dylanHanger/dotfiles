return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "codelldb", "python" },
      handlers = {
        function(config)
          -- all sources with no handler get passed here

          -- Keep original functionality
          require("mason-nvim-dap").default_setup(config)
        end,
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      dap.configurations.rust = {
        -- Try read this from a launch.json somewhere?
        {
          name = "Debug executable",
          type = "codelldb",
          request = "launch",
          program = "${cargo:program}",
          cargo = {
            args = { "build", "--bin=snakes", "--package=snakes" },
            filter = {
              name = "snakes",
              kind = "bin",
            },
          },
          -- TODO: Get args from some workspace config
          args = { "--config", "config.development.yaml" },
          env = {
            CARGO_MANIFEST_DIR = "${workspaceFolder}",
          },
          cwd = "${workspaceFolder}",
        },
        -- {
        --   name = "Launch file",
        --   type = "codelldb",
        --   request = "launch",
        --   program = function()
        --     -- TODO: Read the binary from cargo.toml
        --     -- TODO: Build the binary before running
        --     return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        --   end,
        --   cwd = "${workspaceFolder}",
        --   stopOnEntry = false,
        -- },
      }
    end,
  },
}
