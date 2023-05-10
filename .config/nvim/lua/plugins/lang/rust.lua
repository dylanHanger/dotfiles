-- https://github.com/appelgriebsch/Nv/blob/main/lua/plugins/extras/lang/rust.lua
-- TODO: Stop showing disassembly when terminating
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
    dependencies = { "simrat39/rust-tools.nvim" },
    opts = {
      -- make sure mason installs the server
      setup = {
        rust_analyzer = function(_, opts)
          require("lazyvim.util").on_attach(function(client, buffer)
            -- TODO: Clean this shit up
            -- TODO: Display progress of cargo compilation instead of a one-time notification
            local cargoDebug = function()
              local cargo = require("util.cargo")
              local start = function(args)
                local startDap = function(program)
                  local dap = require("dap")

                  -- Pick the correct dap config
                  local dap_config
                  if #dap.configurations.rust == 1 then
                    dap_config = dap.configurations.rust[1]
                  elseif #dap.configurations.rust >= 1 then
                    -- TODO: Prompt the use to pick one
                    vim.notify("Multiple configurations not yet supported.")
                  else
                    dap_config = {
                      name = "Rust tools debug",
                      stopOnEntry = false,

                      -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
                      --
                      --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
                      --
                      -- Otherwise you might get the following error:
                      --
                      --    Error on launch: Failed to attach to the target process
                      --
                      -- But you should be aware of the implications:
                      -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
                      runInTerminal = false,
                    }
                  end

                  vim.tbl_deep_extend("force", dap_config, {
                    type = "rt_lldb",
                    request = "launch",
                    program = program,
                    args = args ~= nil and args.executableArgs or {}, -- TODO: Allow me to insert custom args here
                    cwd = args ~= nil and args.workspaceRoot,
                  })

                  dap.run(dap_config)
                end

                cargo.build_and_run(args, startDap)
              end

              cargo.get_args("build", start)
            end

            if client.name == "rust_analyzer" then
              -- TODO: Make this use the same map function as `keymaps.lua`
              vim.keymap.set("n", "K", "<CMD>RustHoverActions<CR>", { buffer = buffer })
              vim.keymap.set("n", "<leader>dr", cargoDebug, { buffer = buffer, desc = "Run" })
            end
          end)

          local dap = require("dap")
          local rtdap = require("rust-tools.dap")
          local mason_registry = require("mason-registry")

          local rust_tools_opts = vim.tbl_deep_extend("force", opts, {
            tools = {
              on_initialized = function()
                vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "CursorHold", "InsertLeave" }, {
                  pattern = { "*.rs" },
                  callback = function()
                    local _, _ = pcall(vim.lsp.codelens.refresh)
                  end,
                })
              end,
              hover_actions = {
                auto_focus = false,
                border = "rounded",
              },
              runnables = {
                use_telescope = true,
              },
              -- Can't make these look nice until https://github.com/neovim/neovim/pull/9496 is merged
              inlay_hints = {
                -- automatically set inlay hints (type hints)
                -- default: true
                auto = true,

                -- Only show inlay hints for the current line
                only_current_line = false,

                -- whether to show parameter hints with the inlay hints or not
                -- default: true
                show_parameter_hints = true,

                -- prefix for parameter hints
                -- default: "<-"
                parameter_hints_prefix = "<- ",

                -- prefix for all the other hints (type, chaining)
                -- default: "=>"
                other_hints_prefix = "=> ",

                -- whether to align to the length of the longest line in the file
                max_len_align = false,

                -- padding from the left if max_len_align is true
                max_len_align_padding = 0,

                -- whether to align to the extreme right or not
                right_align = false,

                -- padding from the right if right_align is true
                right_align_padding = 7,
                highlight = "InlayHint",
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
          })

          if mason_registry.has_package("codelldb") then
            -- rust tools configuration for debugging support
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

            local adapter = rtdap.get_codelldb_adapter(codelldb_path, liblldb_path)
            dap.adapters.rust = adapter
            rust_tools_opts = vim.tbl_deep_extend("force", rust_tools_opts, {
              dap = {
                adapter = adapter,
              },
            })
          end

          -- FIXME: RustDebuggables creates and uses its own DAP config and this gets ignored
          -- Ideally, rust-tools.nvim should take in configuration options (excl. the parts set by `.start`)
          -- The only part that really needs to be set by `.start` is `program`. Everything else can be set by the user
          -- Additionally, it should be capable of running `cargo debug`/`cargo test` directly,
          -- without requiring the user to select a runnable
          dap.configurations.rust = {
            {
              name = "Launch",
              type = "rt_lldb",
              request = "launch",
              cwd = "${workspaceFolder}",
              program = function()
                return "${workspaceFolder}/target/debug/${workspaceFolderBasename}"
              end,
              stopOnEntry = false,
              args = {},
              env = {
                CARGO_MANIFEST_DIR = "${workspaceFolder}",
              },
              sourceLanguages = { "rust" },
              showDisassembly = "never",
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

          require("rust-tools").setup(rust_tools_opts)

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
