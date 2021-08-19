vim.cmd [[augroup Autogroup]]

vim.cmd [[autocmd TextYankPost * silent! lua vim.highlight.on_yank({timeout = 200})]]

vim.cmd [[autocmd BufWritePost plugins.lua PackerCompile]]
vim.cmd [[autocmd User PackerComplete,PackerCompileDone lua require("indent_blankline.utils").reset_highlights()]]

vim.cmd [[autocmd FileType dashboard set showtabline=0]]
vim.cmd [[autocmd WinLeave <buffer> set showtabline=2]]

vim.cmd [[autocmd BufReadPost * lua require("colorizer").attach_to_buffer(0)]]

vim.cmd [[autocmd CursorHold * lua require("lspsaga.diagnostic").show_line_diagnostics()]]

vim.cmd [[augroup END]]
