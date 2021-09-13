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

-- Custom parsers
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.yuck = {
   install_info = {
      url = "~/Documents/TreeSitter/tree-sitter-yuck",
      files = {"src/parser.c"}
   },
}

vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldmethod = "expr"
