local util = require 'gruvbox.util'

require "lualine".setup {
    options = {
        theme = "gruvbox-flat"
    },
    extensions = {},
    sections = {
        lualine_a = {"mode"},
        lualine_b = {
            "branch",
            {
                "diff",
                colored = true,
                color_added = util.lighten("#6f8352", 0.75),
                color_removed= util.lighten("#c14a4a", 0.75),
                color_modified = util.lighten("#b47109", 0.75)
            }
        },
        lualine_c = {
            "filename",
            {"diagnostics", sources = {"nvim_lsp"}}
        },
        lualine_x = {
          "encoding",
          "fileformat",
          "filetype"
        },
        lualine_y = {"progress"},
        lualine_z = {"location"}
    }
}
