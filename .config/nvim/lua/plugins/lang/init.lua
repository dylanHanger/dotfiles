-- Create a custom highlight group for inlay hints
local cutils = require("util.colors")

-- TODO: Decide on a nice color, and make sure it works
local type_hl = vim.api.nvim_get_hl(0, { name = "Type" })
local fg_hex = string.format("#%06x", type_hl.fg)
vim.api.nvim_set_hl(0, "InlayHint", {
  fg = cutils.lighten(fg_hex, 0.75),
  italic = true,
})

return {
  { import = "lazyvim.plugins.extras.dap.nlua" },
  { import = "plugins.lang.rust" },
}
