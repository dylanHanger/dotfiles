require "nvim-treesitter.configs".setup {
   ensure_installed = "all",
   highlight = {
      enable = true
   },
   indent = {
      enable = true,
      disable = {"python"}
   }
}

vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldmethod = "expr"
