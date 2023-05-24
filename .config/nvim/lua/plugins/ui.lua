return {
  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      yadm = {
        enable = true,
      },
    },
  },

  -- Sign columns
  {
    "luukvbaal/statuscol.nvim",
    opts = function(_, opts)
      local builtin = require("statuscol.builtin")
      opts.relculright = true
      opts.bt_ignore = { "nofile" }
      opts.segments = {
        { sign = { name = { "Dap", "neotest" } }, click = "v:lua.ScSa" }, -- Debug symbols
        { sign = { name = { "Diagnostic", "todo*" } }, click = "v:lua.ScSa" }, -- Diagnostic Symbols
        { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" }, -- Line number
        { sign = { name = { "GitSigns" } }, click = "v:lua.ScSa" }, -- GitSigns
        { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" }, -- Fold markers
      }
    end,
  },

  -- Incremental rename
  {
    "folke/noice.nvim",
    opts = {
      presets = {
        -- NOTE: This is a reimplementation of the default inc_rename preset so that it works with renamed Command
        inc_rename = {
          cmdline = {
            format = {
              Rename = {
                pattern = "^:%s*Rename%s+",
                -- icon = " ",
                conceal = true,
                opts = {
                  relative = "cursor",
                  size = { min_width = 20 },
                  position = { row = -2, col = 0 },
                },
              },
            },
          },
        },
      },
    },
  },
  {
    "smjonas/inc-rename.nvim",
    opts = {
      cmd_name = "Rename", -- the name of the command
      hl_group = "Substitute", -- the highlight group used for highlighting the identifier's new name
      preview_empty_name = false, -- whether an empty new name should be previewed; if false the command preview will be cancelled instead
      show_message = false, -- whether to display a `Renamed m instances in n files` message after a rename operation
      input_buffer_type = nil, -- the type of the external input buffer to use (the only supported value is currently "dressing")
      post_hook = nil, -- callback to run after renaming, receives the result table (from LSP handler) as an argument
    },
  },
}
