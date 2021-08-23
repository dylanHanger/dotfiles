require("colorizer").setup()

vim.cmd("autocmd BufReadPost * ColorizerAttachToBuffer")
