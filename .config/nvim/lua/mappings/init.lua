local register = require "mappings.utils".register
local map      = require "mappings.utils".map

map("", "<Space>", "<Nop>", {silent = true})
vim.g.mapleader = " "
vim.g.localmapleader = " "


----------------------------------------
--              BUFFERS               --
----------------------------------------

-- File Explorer
register({b = {":NvimTreeToggle<CR>", "Toggle file explorer"}}, {prefix = "<leader>"})

-- Buffers
register({
    ["<leader>q"] = {
        name = "+quit",
        q = {":Bdelete!<CR>", "Quit a buffer"},
        p = {":BufferLinePickClose<CR>", "Pick a buffer to quit"}
    },

    ["gb"] = {":BufferLinePick<CR>", "Pick a buffer to go to"},

    ["[b"] = {":BufferLineCyclePrev<CR>", "Previous buffer"},
    ["]b"] = {":BufferLineCycleNext<CR>", "Next buffer"}
})


----------------------------------------
--             COMPLETION             --
----------------------------------------

_G.tab_complete   = require "mappings.utils".tab_complete
_G.s_tab_complete = require "mappings.utils".s_tab_complete

map({"i", "s"}, "<Tab>", "v:lua.tab_complete()", {silent = false, expr = true})
map({"i", "s"}, "<S-Tab>", "v:lua.s_tab_complete()", {silent = false, expr = true})

map("i", "<C-Space>", "compe#complete()", {silent = true, expr = true})
map("i", "<CR>", "compe#confirm(luaeval('require \"nvim-autopairs\".autopairs_cr()'))", {silent = true, expr = true})
map("i", "<C-e>", "compe#close('<C-e>')", {silent = true, expr = true})
map("i", "<C-f>", "compe#scroll({ 'delta': +4 })", {silent = true, expr = true})
map("i", "<C-d>", "compe#scroll({ 'delta': -4 })", {silent = true, expr = true})


----------------------------------------
--             TELESCOPE              --
----------------------------------------
register({
    ["<leader>"] = {
        f = {
            name = "+file",
            f = { "<cmd>Telescope find_files<cr>", "Find File" },
            r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
        },
    },
})

----------------------------------------
--               FOCUS                --
----------------------------------------
register({
    ["<leader>s"] = {
        ":FocusSplitNicely<CR>",
        "Split window nicely"
    },
    ["<A-l>"] = {
        ":FocusSplitRight<CR>",
        "Go to the right window"
    },
    ["<A-h>"] = {
        ":FocusSplitLeft<CR>",
        "Go to the left window"
    },
    ["<A-j>"] = {
        ":FocusSplitDown<CR>",
        "Go to the down window"
    },
    ["<A-k>"] = {
        ":FocusSplitUp<CR>",
        "Go to the up window"
    },
    ["<A-Right>"] = {
        ":FocusSplitRight<CR>",
        "Go to the right window"
    },
    ["<A-Left>"] = {
        ":FocusSplitLeft<CR>",
        "Go to the left window"
    },
    ["<A-Down>"] = {
        ":FocusSplitDown<CR>",
        "Go to the down window"
    },
    ["<A-Up>"] = {
        ":FocusSplitUp<CR>",
        "Go to the up window"
    }
})


----------------------------------------
--              TERMINAL              --
----------------------------------------
