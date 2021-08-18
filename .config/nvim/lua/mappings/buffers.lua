local map = require "mappings".map

print("Loading buffer mappings")

-- File Explorer
map("n", "<leader>b", ":NvimTreeToggle<CR>", {silent = true}, "Toggle file explorer")

-- Buffers
map("n", "<leader>q", ":Bdelete!<CR>", {silent = true}, "Quit a buffer")

map("n", "[b", ":BufferLineCyclePrev<CR>", {silent = true}, "Previous buffer")
map("n", "]b", ":BufferLineCycleNext<CR>", {silent = true}, "Next buffer")

map("n", "gb", ":BufferLinePick<CR>", {silent = true}, "Pick a buffer to go to")

