return {
  {
    "rcarriga/nvim-dap-ui",
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup(opts)

      local didCrash = false
      dap.listeners.after.event_initialized["dapui_config"] = function()
        didCrash = false -- Reset whenever we start
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        -- If we crashed then we want to see the errors, so don't close
        if not didCrash then
          dapui.close({})
        end
      end
      dap.listeners.before.event_exited["dapui_config"] = function(_, evt)
        -- Set whether we crashed or not
        didCrash = evt.exitCode ~= 0
      end
    end,
  },
  {
    -- TODO: Stop assembly buffers breaking everything
    -- TODO: Stop DapUI closing when the program crashes (non-zero exit)
    "mfussenegger/nvim-dap",
    integration = {},
    config = function()
      local dap = require("dap")

      -- Options
      dap.defaults.fallback.focus_terminal = true

      -- Signs
      local sign = vim.fn.sign_define
      sign("DapBreakpoint", { text = "⬤", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      sign("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      sign("DapBreakpointCondition", { text = "", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      sign("DapLogPoint", { text = "", texthl = "DapLogPoint", linehl = "", numhl = "" })
      sign("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStoppedCurrentLine", numhl = "" })
    end,
  },
  {
    -- NOTE: Oooh I can't wait for inline-virtual text
    -- https://github.com/lvimuser/lsp-inlayhints.nvim/issues/46
    "lvimuser/lsp-inlayhints.nvim",
    event = "LspAttach",
    config = function(_, opts)
      local inlayhints = require("lsp-inlayhints")
      inlayhints.setup(opts)
      require("lazyvim.util").on_attach(inlayhints.on_attach)
    end,
    opts = {
      inlay_hints = {
        parameter_hints = {
          show = true,
          prefix = "<- ",
          separator = ", ",
          remove_colon_start = false,
          remove_colon_end = true,
        },
        type_hints = {
          -- type and other hints
          show = true,
          prefix = "=> ",
          separator = ", ",
          remove_colon_start = true,
          remove_colon_end = false,
        },
        only_current_line = false,
        -- separator between types and parameter hints. Note that type hints are
        -- shown before parameter
        labels_separator = "  ",
        -- whether to align to the length of the longest line in the file
        max_len_align = false,
        -- padding from the left if max_len_align is true
        max_len_align_padding = 1,
        -- highlight group
        highlight = "LspInlayHint",
        -- virt_text priority
        priority = 0,
      },
      enabled_at_startup = true,
      debug_mode = false,
    },
  },
  { import = "lazyvim.plugins.extras.dap.nlua" },
  { import = "plugins.lang.rust" },
}
