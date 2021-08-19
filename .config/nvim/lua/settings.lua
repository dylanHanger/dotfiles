vim.cmd [[syntax enable]]
vim.cmd [[filetype plugin indent on]]

local opt = setmetatable(
    {},
    {
        __newindex = function(_, key, value)
            vim.o[key] = value
            vim.bo[key] = value
        end
    }
)

opt.expandtab = true
opt.formatoptions = "crqnbj" -- :h fo-table
opt.shiftwidth = 4
opt.smartindent = true
opt.softtabstop = 4
opt.spellcapcheck = ""
opt.swapfile = false
opt.tabstop = 4
opt.textwidth = 80
opt.undofile = true
opt.undolevels = 10000

vim.o.breakindent = true
vim.o.clipboard = "unnamedplus"
vim.o.completeopt = "menuone,noinsert,noselect"
vim.o.cursorline = true
vim.o.cursorlineopt = "both"
vim.o.foldenable = false
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.inccommand = 'nosplit'
vim.o.mouse = "a"
vim.o.number = true
vim.o.showmode = false
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.smartcase = true
vim.o.termguicolors = true
vim.o.timeoutlen = 500
vim.o.updatetime = 500
vim.o.virtualedit = "onemore"
vim.o.wrap = false
vim.o.signcolumn = "yes"

vim.g.dashboard_custom_header = {
    [[███╗░░██╗███████╗░█████╗░██╗░░░██╗██╗███╗░░░███╗]],
    [[████╗░██║██╔════╝██╔══██╗██║░░░██║██║████╗░████║]],
    [[██╔██╗██║█████╗░░██║░░██║╚██╗░██╔╝██║██╔████╔██║]],
    [[██║╚████║██╔══╝░░██║░░██║░╚████╔╝░██║██║╚██╔╝██║]],
    [[██║░╚███║███████╗╚█████╔╝░░╚██╔╝░░██║██║░╚═╝░██║]],
    [[╚═╝░░╚══╝╚══════╝░╚════╝░░░░╚═╝░░░╚═╝╚═╝░░░░░╚═╝]],
}
