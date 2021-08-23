local opt = vim.opt
local g = vim.g


g.auto_save = true

opt.breakindent = true
opt.clipboard = "unnamedplus"
opt.cmdheight = 1
opt.completeopt = "menuone,noinsert,noselect"
opt.completeopt = {"menuone", "noselect"}
opt.cul = true
opt.cursorline = true
opt.cursorlineopt = "both"
opt.expandtab = true
opt.fillchars = { eob = " " }
opt.foldenable = false
opt.formatoptions = "crqnbj" -- :h fo-table
opt.hidden = true
opt.ignorecase = true
opt.inccommand = "nosplit"
opt.mouse = "a"
opt.number = true
opt.relativenumber = false
opt.ruler = false
opt.shiftwidth = 4
opt.shortmess:append "cI"
opt.showmode = false
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.softtabstop = 4
opt.spellcapcheck = ""
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.tabstop = 4
opt.termguicolors = true
opt.textwidth = 80
opt.timeoutlen = 400
opt.timeoutlen = 500
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 250
opt.virtualedit = "onemore"
opt.wrap = false

-- No numbers in terminals
vim.cmd [[ au TermOpen term://* setlocal nonumber norelativenumber ]]
vim.cmd [[ au TermOpen term://* setfiletype terminal ]]
