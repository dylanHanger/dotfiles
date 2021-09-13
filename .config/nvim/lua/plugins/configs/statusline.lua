local colors = require("theme").colors

local base16 = {}

base16.normal = {
  a = { bg = colors.base0D, fg = colors.base00, gui = "bold" },
  b = { bg = colors.base02, fg = colors.base0D },
  c = { bg = colors.base01, fg = colors.base05 },
}

base16.insert = {
  a = { bg = colors.base0B, fg = colors.base00, gui = "bold" },
  b = { bg = colors.base02, fg = colors.base0B },
}

base16.command = {
  a = { bg = colors.base0E, fg = colors.base00, gui = "bold" },
  b = { bg = colors.base02, fg = colors.base0E },
}

base16.visual = {
  a = { bg = colors.base0A, fg = colors.base00, gui = "bold" },
  b = { bg = colors.base02, fg = colors.base0A },
}

base16.replace = {
  a = { bg = colors.base08, fg = colors.base00, gui = "bold" },
  b = { bg = colors.base02, fg = colors.base08 },
}

base16.inactive = {
  a = { bg = colors.base01, fg = colors.base0D, gui = "bold" },
  b = { bg = colors.base01, fg = colors.base02, gui = "bold" },
  c = { bg = colors.base01, fg = colors.base02 },
}

require("lualine").setup({
  options = {
    theme = base16,
    section_separators = {'', ''},
    component_separators = {'', ''}
  }
})
