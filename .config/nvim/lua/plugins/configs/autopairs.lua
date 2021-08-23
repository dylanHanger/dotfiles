require("nvim-autopairs").setup{
   disable_filetype = {"TelescopePrompt"},
   fastwrap = {}
}

require("nvim-autopairs.completion.compe").setup {
   map_complete = true, -- insert () func completion
   map_cr = true,
}

require("nvim-treesitter.configs").setup {
   autopairs = {
      enable = true
   }
}
