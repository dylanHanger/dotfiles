return {
  {
    "mfussenegger/nvim-dap",
    integration = {},
    config = function()
      local dap = require("dap")

      local cutils = require("util.colors")
      vim.api.nvim_set_hl(0, "DapCurrentLine", {
        bg = cutils.hex_to_int("#535525"),
      })

      -- Signs
      local sign = vim.fn.sign_define
      sign("DapBreakpoint", { text = "⬤", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      sign("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      sign("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      sign("DapLogPoint", { text = "", texthl = "DapLogPoint", linehl = "", numhl = "" })
      sign("DapStopped", { text = "", texthl = "DapBreakpoint", linehl = "DapCurrentLine", numhl = "" })

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
