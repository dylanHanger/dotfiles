-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = require("util").map

--- BUFFERLINE ---
-- <leader>bj to enter buffer picking mode
local bufferline = require("bufferline")
map("n", "<leader>bj", function()
  bufferline.pick()
end, { desc = "Pick buffer to jump to" })

-- <leader>bJ to enter buffer picking mode
map("n", "<leader>bJ", function()
  bufferline.close_with_pick()
end, { desc = "Pick buffer to close" })
