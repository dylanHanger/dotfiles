-- TODO: Setup for more environments
-- Obsidian.md - epwalsh/obsidian.nvim

return {
  { import = "lazyvim.plugins.extras.dap.core" },
  { import = "lazyvim.plugins.extras.test.core" },

  -- Specific languages
  { import = "lazyvim.plugins.extras.dap.nlua" },
  { import = "lazyvim.plugins.extras.lang.json" },

  -- TODO: Would be super nice to auto-include all these
  { import = "plugins.lang.rust" },
  { import = "plugins.lang.python" },
  { import = "plugins.lang.web" },
  { import = "plugins.lang.csharp" },
  { import = "plugins.lang.latex" },

  -- Testing
  {
    "nvim-neotest/neotest",
    opts = {
      icons = {
        child_indent = "│",
        child_prefix = "├",
        collapsed = "─",
        expanded = "┐",
        failed = "",
        final_child_indent = " ",
        final_child_prefix = "└",
        non_collapsible = "─",
        passed = "",
        running = "",
        running_animated = {
          "⠋",
          "⠙",
          "⠹",
          "⠸",
          "⠼",
          "⠴",
          "⠦",
          "⠧",
          "⠇",
          "⠏",
        },
      },
    },
    -- FIXME: This is a corrected version of the default config
    --        When LazyVim updates I can remove this
    -- ~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/test/core.lua
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Replace newline and tab characters with space for more compact diagnostics
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              adapter = adapter(config)
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require("neotest").setup(opts)
    end,
  },

  -- Mason
  {
    "williamboman/mason.nvim",
    opts = {
      PATH = "append", -- This is supposed to fix issues with ensuring the correct Python interpreter is used with Conda
    },
  },
  -- DAP
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

  -- Inlay Hints
  {
    -- NOTE: Oooh I can't wait for inline-virtual text
    -- https://github.com/lvimuser/lsp-inlayhints.nvim/issues/46
    -- TODO: Get this working in lua. I don't know why it doesn't already tbh
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
}
