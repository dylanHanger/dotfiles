return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      -- Highlights
      local cutils = require("util.colors")
      vim.api.nvim_set_hl(0, "DAPCurrentLine", {
        bg = cutils.hex_to_int("#535525"),
      })

      -- Signs
      vim.fn.sign_define("DapBreakpoint", { text = "⬤", texthl = "DAPUIStop", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DAPUIStop", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DAPUIStop", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DAPUIStop", linehl = "DAPCurrentLine", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DAPUIStop", linehl = "", numhl = "" })

      -- DAP Configurations
      dap.configurations.rust = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          cwd = "${workspaceFolder}",
          program = function()
            vim.fn.jobstart("cargo build")
            return "${workspaceFolder}/target/debug/${workspaceFolderBasename}"
          end,
          stopOnEntry = false,
          args = {},
          env = {
            CARGO_MANIFEST_DIR = "${workspaceFolder}",
          },
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

      -- Override default configurations with `launch.json`
      require("dap.ext.vscode").load_launchjs(".nvim/launch.json", { lldb = { "c", "cpp" }, rt_lldb = { "rust" } })
    end,
  },
}
