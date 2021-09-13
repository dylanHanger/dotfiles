local utils = require("utils")
local M = {}

M.colors = {
  -- Start flavours
base00 = "#2d2d2d", base01 = "#393939", base02 = "#515151", base03 = "#999999",
base04 = "#b4b7b4", base05 = "#cccccc", base06 = "#e0e0e0", base07 = "#ffffff",
base08 = "#f2777a", base09 = "#f99157", base0A = "#ffcc66", base0B = "#99cc99",
base0C = "#66cccc", base0D = "#6699cc", base0E = "#cc99cc", base0F = "#a3685a",
  -- End flavours
}

M.load_colors = function()
  require("base16-colorscheme").setup(M.colors)

  -- Force some plugins to reload
  utils.reload("plugins.configs.statusline")
  utils.reload("plugins.configs.bufferline")

  -- Some custom coloring
  utils.highlight("CursorLineNr", M.colors.base0A, M.colors.base00, "bold")
end

return M
