-- TODO: Which-Key
local map = require "utils".map

map('', '<Space>', '<Nop>', {silent = true})
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


-- Useful things
map("n", "Y", "y$", {noremap = false}) -- Yank to end of line

-- Nvim-Compe / Autopairs
local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col '.' - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' then
        return true
    else
        return false
    end
end

_G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t '<C-n>'
    elseif vim.fn['vsnip#available'](1) == 1 then
        return t "<Plug>(vsnip-expand-or-jump)"
    elseif check_back_space() then
        return t '<Tab>'
    else
        return vim.fn['compe#complete']()
    end
end

_G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
        return t '<C-p>'
    elseif vim.fn['vsnip#available'](1) == 1 then
        return t "<Plug>(vsnip-jump-prev)"
    else
        return t '<S-Tab>'
    end
end

map('i', '<Tab>', 'v:lua.tab_complete()', {expr = true})
map('s', '<Tab>', 'v:lua.tab_complete()', {expr = true})
map('i', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
map('s', '<S-Tab>', 'v:lua.s_tab_complete()', {expr = true})
map('i', '<CR>', [[compe#confirm(luaeval("require('nvim-autopairs').autopairs_cr()"))]], {expr = true})
map('i', '<C-Space>', 'compe#complete()', {expr = true})

-- LSP Saga
map("n", "<C-j>", ":lua require 'lspsaga.action'.smart_scroll_with_saga(1)<CR>",
    {silent = true})
map("n", "<C-k>", ":lua require 'lspsaga.action'.smart_scroll_with_saga(-1)<CR>",
    {silent = true})

map("n", "<leader>r", ":lua require 'lspsaga.rename'.rename()<CR>",
    {silent = true})

map("n", "<leader>ca", ":lua require 'lspsaga.codeaction'.code_action()<CR>", {silent = true})
map("v", "<leader>ca", ":<C-U>lua require 'lspsaga.codeaction'.range_code_action()<CR>", {silent = true})

map("n", "]e", ":Lspsaga diagnostic_jump_next<CR>", {silent = true})
map("n", "[e", ":Lspsaga diagnostic_jump_prev<CR>", {silent = true})

-- TODO: Finder and preview definition

-- Camel Case Motion
map("", "w", "<Plug>CamelCaseMotion_w", {noremap = false})
map("", "b", "<Plug>CamelCaseMotion_b", {noremap = false})
map("", "e", "<Plug>CamelCaseMotion_e", {noremap = false})
map("", "ge", "<Plug>CamelCaseMotion_ge", {noremap = false})

map({"o", "x"}, "iw", "<Plug>CamelCaseMotion_iw", {noremap = false})
map({"o", "x"}, "ib", "<Plug>CamelCaseMotion_ib", {noremap = false})
map({"o", "x"}, "ie", "<Plug>CamelCaseMotion_ie", {noremap = false})

map("i", "<S-Left>", "<C-o><Plug>CamelCaseMotion_b", {noremap = false})
map("i", "<S-Right>", "<C-o><Plug>CamelCaseMotion_w", {noremap = false})

-- File explorer
map("n", "<leader>b", ":NvimTreeToggle<CR>", {silent = true})

-- Buffer management
map("n", "]b", ":BufferLineCycleNext<CR>", {silent = true})
map("n", "[b", ":BufferLineCyclePrev<CR>", {silent = true})

map("n", "gb", ":BufferLinePick<CR>", {silent = true})

map("n", "qb", ":Bdelete", {silent = true})
