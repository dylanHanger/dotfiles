-- Create a custom highlight group for inlay hints
vim.api.nvim_set_hl(0, "InlayHint", { fg = "#ff0000" })

return {
  { import = "lazyvim.plugins.extras.dap.nlua" },
  { import = "plugins.lang.rust" },
}
