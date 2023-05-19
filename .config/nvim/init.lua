-- bootstrap lazy.nvim, LazyVim and your plugins
-- TODO: Make appropriate changes when vim.g.vscode exists
if vim.g.vscode then
  print("Neovim is inside VSCode")
else
  require("config.lazy")
end

-- TODO: Get some more features
-- Dial.nvim - Enhanced incrementing/decrementing
-- Chrome Devtools
