return {
  {
    -- TODO: Make DAP UI stay up when program exits
    -- TODO: Stop assembly buffers breaking everything
    "mfussenegger/nvim-dap",
    integration = {},
    config = function()
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
