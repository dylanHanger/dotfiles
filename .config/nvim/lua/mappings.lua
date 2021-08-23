local map = require("utils").map

map("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.localmapleader = " "

map("n", "<Esc>", ":noh <CR>")

----------------------------------------
--              BUFFERS               --
----------------------------------------

-- File Explorer
map("n", "<leader>b", ":NvimTreeToggle<CR>")

-- Buffers
map("n", "<leader>qq", ":Bdelete!<CR>") -- Quit Quit
map("n", "<leader>qp", ":BufferLinePickClose<CR>") -- Quit Pick

map("n", "<leader>gb", ":BufferLinePick<CR>") -- Go Buffer

map("n", "[b", ":BufferLineCyclePrev<CR>")
map("n", "]b", ":BufferLineCycleNext<CR>")


----------------------------------------
--             TELESCOPE              --
----------------------------------------
map("n", "<leader>sf", ":Telescope find_files<CR>") -- Search Files
map("n", "<leader>sr", ":Telescope oldfiles<CR>") -- Search Recent
map("n", "<leader>sw", ":Telescope live_grep<CR>") -- Search Word
map("n", "<leader>ss", ":Telescope treesitter<CR>") -- Search Symbols
map("n", "<leader>sm", ":DashboardJumpMarks<CR>") -- Search Marks

----------------------------------------
--             DASHBOARD              --
----------------------------------------
map("n", "<leader>nf", ":DashboardNewFile<CR>") -- New File
