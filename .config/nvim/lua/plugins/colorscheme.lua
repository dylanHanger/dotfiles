local cutils = require("util.colors")

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function(_, opts)
      require("catppuccin").setup(opts)
    end,
    opts = {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      background = { -- :h background
        light = "latte",
        dark = "mocha",
      },
      transparent_background = false,
      show_end_of_buffer = false, -- show the '~' characters after the end of buffers
      term_colors = false,
      dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
      },
      no_italic = false, -- Force no italic
      no_bold = false, -- Force no bold
      styles = {
        comments = { "italic" },
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      color_overrides = {},
      custom_highlights = function(colors)
        local dark_yellow = cutils.darken(colors.yellow, 75)
        return {
          InlayHint = { fg = colors.surface1 },
          DapStoppedCurrentLine = { bg = dark_yellow },
        }
      end,
      integrations = {
        cmp = true,
        gitsigns = true,
        illuminate = true,
        mini = true,
        notify = true,
        nvimtree = true,
        telescope = true,
        treesitter = true,
        ts_rainbow2 = true,
        which_key = true,
        semantic_tokens = true,
        -- Special integrations
        indent_blankline = {
          enabled = true,
          colored_indent_levels = true,
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
        dap = {
          enabled = true,
          enable_ui = true,
        },
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
      },
    },
  },

  {
    "akinsho/bufferline.nvim",
    after = "catppuccin",
    opts = function(_, opts)
      opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    after = "catppuccin",
    opts = function(_, opts)
      opts.options = {
        theme = "catppuccin",
      }
    end,
  },
}
