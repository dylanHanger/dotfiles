-- https://github.com/appelgriebsch/Nv/blob/main/lua/plugins/extras/lang/rust.lua
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

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      setup = {
        rust_analyzer = function(_, _)
          local dap = require("dap")
          local mason_registry = require("mason-registry")

          require("lazyvim.util").on_attach(function(client, _)
            if client.name == "rust_analyzer" then
              vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
                pattern = { "*.rs" },
                callback = function()
                  local _, _ = pcall(vim.lsp.codelens.refresh)
                end,
              })
              vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                pattern = { "launch.json" },
                callback = setupConfigs,
              })
            end
          end)

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

            dap.adapters.codelldb = {
              type = "server",
              port = "${port}",
              host = "127.0.0.1",
              executable = {
                command = codelldb_path,
                args = { "--liblldb", liblldb_path, "--port", "${port}" },
              },
              enrich_config = function(cfg, on_config)
                if cfg["cargo"] ~= nil then
                  on_config(require("util.cargo").cargo_inspector(cfg))
                end
              end,
            }
          end

          -- TODO: Ask rust_analyzer what these configs (name, args, etc) should be, rather than using the workspaceFolderBasename
          -- These commands come from the `experimental/runnables` LSP extension method, and will also include test targets for binaries and libraries
          dap.configurations.rust = {
            {
              name = "Debug",
              type = "codelldb",
              request = "launch",
              cwd = "${workspaceFolder}",
              cargo = {
                -- NOTE: These are taken from VSCode's launch.json
                args = { "build", "--bin=${workspaceFolderBasename}", "--package=${workspaceFolderBasename}" },
                filter = { "name=${workspaceFolderBasename}", "kind=bin" },
              },
              stopOnEntry = false,
              args = {},
              env = {
                CARGO_MANIFEST_DIR = "${workspaceFolder}",
              },
              sourceLanguages = { "rust" },
              initCommands = function()
                local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))

                local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
                local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"

                local commands = {}
                local file = io.open(commands_file, "r")
                if file then
                  for line in file:lines() do
                    table.insert(commands, line)
                  end
                  file:close()
                end
                table.insert(commands, 1, script_import)

                return commands
              end,
            },
          }

          return false -- make sure the base implementation calls rust_analyzer.setup
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
