-- https://github.com/appelgriebsch/Nv/blob/main/lua/plugins/extras/lang/rust.lua
-- TODO: Make the compilation terminal when debugging nicer: colors, borders, not centered, etc
-- FIXME: Debugging does not work with dynamic linking, probably related to cargo_inspector
return {
  -- extend auto completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        config = true,
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "crates" },
      }))
    end,
  },

  -- add rust to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "ron", "rust", "toml" })
    end,
  },

  -- correctly setup mason lsp extensions
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "rust-analyzer", "taplo" })
    end,
  },

  -- correctly setup mason dap extensions
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "codelldb" })
    end,
  },

  -- correctly setup neotest adapter
  -- NOTE: neotest-rust requires cargo-nextest.
  {
    "nvim-neotest/neotest",
    dependencies = {
      "rouge8/neotest-rust",
    },
    opts = {
      adapters = {
        ["neotest-rust"] = {
          dap_adapter = "codelldb",
          dap = { justMyCode = true },
        },
      },
    },
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = { "simrat39/rust-tools.nvim" },
    opts = {
      -- make sure mason installs the server
      setup = {
        rust_analyzer = function(_, _)
          local dap = require("dap")
          local mason_registry = require("mason-registry")
          local rust_tools = require("rust-tools")

          require("lazyvim.util").on_attach(function(client, buffer)
            if client.name == "rust_analyzer" then
              vim.keymap.set("n", "K", "<CMD>RustHoverActions<CR>", { buffer = buffer })
              -- NOTE: This is broken in rust-tools
              -- vim.keymap.set("v", "K", "<CMD>RustHoverRange<CR>", { buffer = buffer })
              -- vim.keymap.set("n", "J", "<CMD>RustJoinLines<CR>", { buffer = buffer })
            end
          end)

          local rust_tools_opts = {
            tools = {
              hover_actions = {
                auto_focus = false,
                border = "none",
              },
              inlay_hints = {
                auto = false, -- Handled by inlay-hints
              },
            },
            server = {
              settings = {
                ["rust-analyzer"] = {
                  cargo = {
                    features = "all",
                  },
                  -- Add clippy lints for Rust.
                  checkOnSave = true,
                  check = {
                    command = "clippy",
                    features = "all",
                  },
                  procMacro = {
                    enable = true,
                  },
                },
              },
            },
          }

          if mason_registry.has_package("codelldb") then
            local codelldb = mason_registry.get_package("codelldb")
            local extension_path = codelldb:get_install_path() .. "/extension/"

            local codelldb_path = extension_path .. "adapter/codelldb"
            local liblldb_path = extension_path .. "lldb/lib/liblldb"

            local this_os = vim.loop.os_uname().sysname
            if this_os:find("Windows") then
              codelldb_path = extension_path .. "adapter\\codelldb.exe"
              liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
            else
              -- The liblldb extension is .so for linux and .dylib for macOS
              liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
            end

            local adapter = {
              type = "server",
              port = "${port}",
              host = "127.0.0.1",
              executable = {
                command = codelldb_path,
                args = { "--liblldb", liblldb_path, "--port", "${port}" },
              },
            }
            dap.adapters.codelldb = adapter
            rust_tools_opts = vim.tbl_deep_extend("force", rust_tools_opts, {
              dap = {
                adapter = adapter,
              },
            })
          end

          rust_tools.setup(rust_tools_opts)
          return true
        end,

        taplo = function(_, _)
          local crates = require("crates")

          local function show_documentation()
            if vim.fn.expand("%:t") == "Cargo.toml" and crates.popup_available() then
              crates.show_popup()
            else
              vim.lsp.buf.hover()
            end
          end

          require("lazyvim.util").on_attach(function(client, buffer)
            if client.name == "taplo" then
              vim.keymap.set("n", "K", show_documentation, { buffer = buffer })
            end
          end)

          return false -- make sure the base implementation calls taplo.setup
        end,
      },
    },
  },
}
