-- TODO: Setup for more environments
-- Obsidian.md - epwalsh/obsidian.nvim
-- LaTeX
--
return {
  -- Mason
  {
    "williamboman/mason.nvim",
    opts = {
      PATH = "append",
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

  -- Testing
  -- TODO: Make sure debugging tests works. Setting strategy="dap" causes tests to not run
  -- TODO: Setup catppuccin colors here
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      -- which key integration
      {
        "folke/which-key.nvim",
        opts = {
          defaults = {
            ["<leader>dt"] = { name = "+tests" },
          },
        },
      },
      -- TODO: Disable mini.indentscope in the neotest buffers
    },
    opts = {
      adapters = {},
      benchmark = {
        enabled = true,
      },
      consumers = {},
      default_strategy = "integrated",
      diagnostic = {
        enabled = true,
        severity = 1,
      },
      discovery = {
        concurrent = 0,
        enabled = true,
      },
      floating = {
        border = "rounded",
        max_height = 0.6,
        max_width = 0.6,
        options = {},
      },
      highlights = {
        adapter_name = "NeotestAdapterName",
        border = "NeotestBorder",
        dir = "NeotestDir",
        expand_marker = "NeotestExpandMarker",
        failed = "NeotestFailed",
        file = "NeotestFile",
        focused = "NeotestFocused",
        indent = "NeotestIndent",
        marked = "NeotestMarked",
        namespace = "NeotestNamespace",
        passed = "NeotestPassed",
        running = "NeotestRunning",
        select_win = "NeotestWinSelect",
        skipped = "NeotestSkipped",
        target = "NeotestTarget",
        test = "NeotestTest",
        unknown = "NeotestUnknown",
      },
      icons = {
        child_indent = "│",
        child_prefix = "├",
        collapsed = "─",
        expanded = "╮",
        failed = "",
        final_child_indent = " ",
        final_child_prefix = "╰",
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
        skipped = "",
        unknown = "",
      },
      jump = {
        enabled = true,
      },
      log_level = 3,
      output = {
        enabled = true,
        open_on_run = "short",
      },
      output_panel = {
        enabled = true,
        open = "botright split | resize 15",
      },
      projects = {},
      quickfix = {
        enabled = true,
        open = true,
      },
      run = {
        enabled = true,
      },
      running = {
        concurrent = true,
      },
      state = {
        enabled = true,
      },
      status = {
        enabled = true,
        signs = true,
        virtual_text = false,
      },
      strategies = {
        integrated = {
          height = 40,
          width = 120,
        },
      },
      summary = {
        animated = true,
        enabled = true,
        expand_errors = true,
        follow = true,
        mappings = {
          attach = "a",
          clear_marked = "M",
          clear_target = "T",
          debug = "d",
          debug_marked = "D",
          expand = { "<CR>", "<2-LeftMouse>" },
          expand_all = "e",
          jumpto = "i",
          mark = "m",
          next_failed = "J",
          output = "o",
          prev_failed = "K",
          run = "r",
          run_marked = "R",
          short = "O",
          stop = "u",
          target = "t",
        },
        open = "botright vsplit | vertical resize 50",
      },
    },
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

  -- Specific languages
  { import = "lazyvim.plugins.extras.dap.nlua" },
  -- TODO: Would be super nice to auto-include all these
  { import = "plugins.lang.rust" },
  { import = "plugins.lang.python" },
  { import = "plugins.lang.web" },
}
